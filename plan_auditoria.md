PLAN DE IMPLEMENTACIÓN - Correcciones de Auditoría
ARCHIVO 1: schema.sql (OLTP)
Paso 1.1 - Modificar tabla RECOMIENDA
Ubicación: Líneas 59-65 del archivo actual.
Reemplazar la tabla RECOMIENDA completa por:
CREATE TABLE RECOMIENDA (
    id_evaluacion SERIAL PRIMARY KEY,
    cod_cliente VARCHAR(10) REFERENCES CLIENTE(cod_cliente),
    cod_evaluacion_servicio VARCHAR(10) REFERENCES EVALUACION_SERVICIO(cod_evaluacion_servicio),
    cod_producto VARCHAR(10) REFERENCES PRODUCTO(cod_producto),
    recomienda_amigo VARCHAR(2) CHECK (recomienda_amigo IN ('SI', 'NO')),
    fecha_evaluacion DATE NOT NULL DEFAULT CURRENT_DATE
);
Razón: Surrogate key permite re-evaluaciones; fecha_evaluacion habilita el Indicador 9 (Top 10 últimos 2 años).
Paso 1.2 - Agregar NOT NULL a estado_contrato
Ubicación: Línea 82 de REGISTRO_CONTRATO.
Cambiar estado_contrato VARCHAR(20) CHECK (...) por:
estado_contrato VARCHAR(20) NOT NULL CHECK (estado_contrato IN ('activo', 'vencido', 'suspendido'))
Paso 1.3 - Crear tabla METAS
Ubicación: Agregar al final del archivo, después de REGISTRO_SINIESTRO.
-- 13. METAS
CREATE TABLE METAS (
    cod_meta SERIAL PRIMARY KEY,
    annio INTEGER NOT NULL,
    cod_producto VARCHAR(10) REFERENCES PRODUCTO(cod_producto),
    meta_asegurados INTEGER NOT NULL,
    meta_renovacion INTEGER NOT NULL,
    meta_ingreso REAL NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    UNIQUE (annio, cod_producto)
);
ARCHIVO 2: schemaDW.sql (DW)
Paso 2.1 - Agregar SK_DIM_SUCURSAL a FACT_REGISTRO_CONTRATO
Ubicación: Líneas 88-100. Agregar después de SK_DIM_ESTADO_CONTRATO:
SK_DIM_SUCURSAL INTEGER REFERENCES DIM_SUCURSAL(SK_DIM_SUCURSAL),
Paso 2.2 - Agregar SK_DIM_TIEMPO a FACT_EVALUACION_SERVICIO
Ubicación: Líneas 118-124. Agregar después de SK_DIM_EVALUACION_SERVICIO:
SK_DIM_TIEMPO_FECHA_EVALUACION INTEGER REFERENCES DIM_TIEMPO(SK_DIM_TIEMPO),
Paso 2.3 - Agregar PKs a todas las tablas de hechos
Agregar al final de cada CREATE TABLE de hechos (antes del );):
- FACT_REGISTRO_CONTRATO:
PRIMARY KEY (SK_DIM_TIEMPO_FECHA_INICIO, SK_DIM_CLIENTE, SK_DIM_CONTRATO, SK_DIM_PRODUCTO)
- FACT_REGISTRO_SINIESTRO:
PRIMARY KEY (SK_FECHA_SINIESTRO, SK_DIM_CLIENTE, SK_DIM_CONTRATO, SK_DIM_SINIESTRO)
- FACT_EVALUACION_SERVICIO:
PRIMARY KEY (SK_DIM_CLIENTE, SK_DIM_PRODUCTO, SK_DIM_EVALUACION_SERVICIO, SK_DIM_TIEMPO_FECHA_EVALUACION)
- FACT_METAS:
PRIMARY KEY (SK_DIM_FECHA_INICIO_META, SK_DIM_PRODUCTO, SK_DIM_CONTRATO)
ARCHIVO 3: actualizar.sql (ETL)
Paso 3.1 - Reemplazar carga de DIM_ESTADO_CONTRATO
Ubicación: Líneas 31-34 (el bloque -- >>> AQUI ESTA LA DIMENSION QUE FALTABA <<<).
Reemplazar el INSERT con SUBSTRING por valores fijos:
INSERT INTO "SEGURO_DW_G27797047".DIM_ESTADO_CONTRATO (COD_ESTADO, DESCRIP_ESTADO) VALUES
    ('AC', 'Activo'),
    ('VE', 'Vencido'),
    ('SU', 'Suspendido')
ON CONFLICT (COD_ESTADO) DO UPDATE SET DESCRIP_ESTADO = EXCLUDED.DESCRIP_ESTADO;
Paso 3.2 - Actualizar FACT_REGISTRO_CONTRATO
Ubicación: Líneas 41-47.
Reemplazar el bloque completo por:
TRUNCATE TABLE "SEGURO_DW_G27797047".FACT_REGISTRO_CONTRATO;
INSERT INTO "SEGURO_DW_G27797047".FACT_REGISTRO_CONTRATO (
    SK_DIM_TIEMPO_FECHA_INICIO, SK_DIM_TIEMPO_FECHA_FIN, SK_DIM_CLIENTE,
    SK_DIM_CONTRATO, SK_DIM_PRODUCTO, SK_DIM_ESTADO_CONTRATO,
    SK_DIM_SUCURSAL, MONTO, CANTIDAD, CANTIDAD_CLIENTE, CANTIDAD_PRODUCTO, CANTIDAD_CONTRATO
)
SELECT
    to_char(rc.fecha_inicio, 'YYYYMMDD')::integer,
    to_char(rc.fecha_fin, 'YYYYMMDD')::integer,
    dc.SK_DIM_CLIENTE, dcon.SK_DIM_CONTRATO, dp.SK_DIM_PRODUCTO, de.SK_DIM_ESTADO,
    dsuc.SK_DIM_SUCURSAL, rc.monto, 1, 1, 1, 1
FROM "SEGURO_G27797047".REGISTRO_CONTRATO rc
JOIN "SEGURO_DW_G27797047".DIM_CLIENTE dc ON rc.cod_cliente = dc.COD_CLIENTE
JOIN "SEGURO_DW_G27797047".DIM_CONTRATO dcon ON rc.nro_contrato = dcon.NRO_CONTRATO
JOIN "SEGURO_DW_G27797047".DIM_PRODUCTO dp ON rc.cod_producto = dp.COD_PRODUCTO
LEFT JOIN "SEGURO_DW_G27797047".DIM_ESTADO_CONTRATO de
    ON de.COD_ESTADO = CASE rc.estado_contrato WHEN 'activo' THEN 'AC' WHEN 'vencido' THEN 'VE' WHEN 'suspendido' THEN 'SU' END
JOIN "SEGURO_G27797047".CLIENTE c ON rc.cod_cliente = c.cod_cliente
JOIN "SEGURO_DW_G27797047".DIM_SUCURSAL dsuc ON c.cod_sucursal = dsuc.COD_SUCURSAL;
Paso 3.3 - Actualizar FACT_EVALUACION_SERVICIO
Ubicación: Líneas 72-78.
Reemplazar por:
TRUNCATE TABLE "SEGURO_DW_G27797047".FACT_EVALUACION_SERVICIO;
INSERT INTO "SEGURO_DW_G27797047".FACT_EVALUACION_SERVICIO (
    SK_DIM_CLIENTE, SK_DIM_PRODUCTO, SK_DIM_EVALUACION_SERVICIO,
    SK_DIM_TIEMPO_FECHA_EVALUACION, CANTIDAD, RECOMIENDA_AMIGO
)
SELECT dc.SK_DIM_CLIENTE, dp.SK_DIM_PRODUCTO, de.SK_DIM_EVALUACION,
    to_char(r.fecha_evaluacion, 'YYYYMMDD')::integer, 1,
    CASE WHEN r.recomienda_amigo = 'SI' THEN 1.0 ELSE 0.0 END
FROM "SEGURO_G27797047".RECOMIENDA r
JOIN "SEGURO_DW_G27797047".DIM_CLIENTE dc ON r.cod_cliente = dc.COD_CLIENTE
JOIN "SEGURO_DW_G27797047".DIM_PRODUCTO dp ON r.cod_producto = dp.COD_PRODUCTO
JOIN "SEGURO_DW_G27797047".DIM_EVALUACION_SERVICIO de ON r.cod_evaluacion_servicio = de.COD_EVALUACION;
Paso 3.4 - Reescribir FACT_METAS (leer de tabla METAS del OLTP)
Ubicación: Líneas 81-87.
Reemplazar por:
TRUNCATE TABLE "SEGURO_DW_G27797047".FACT_METAS;
INSERT INTO "SEGURO_DW_G27797047".FACT_METAS (
    SK_DIM_FECHA_INICIO_META, SK_DIM_FECHA_FIN_META,
    SK_DIM_PRODUCTO, SK_DIM_CONTRATO,
    MONTO_META_INGRESO, META_RENOVACION, META_ASEGURADOS
)
SELECT
    to_char(m.fecha_inicio, 'YYYYMMDD')::integer,
    to_char(m.fecha_fin, 'YYYYMMDD')::integer,
    dp.SK_DIM_PRODUCTO,
    dcon.SK_DIM_CONTRATO,
    m.meta_ingreso, m.meta_renovacion, m.meta_asegurados
FROM "SEGURO_G27797047".METAS m
JOIN "SEGURO_DW_G27797047".DIM_PRODUCTO dp ON m.cod_producto = dp.COD_PRODUCTO
JOIN "SEGURO_DW_G27797047".DIM_CONTRATO dcon ON TRUE
LIMIT 50;
Nota: El JOIN con DIM_CONTRATO usa ON TRUE (cross join limitado) porque las metas son por producto/año, no por contrato específico. Se toma el primer contrato disponible como referencia. Si se desea eliminar la dependencia de DIM_CONTRATO, se puede quitar la FK de FACT_METAS y remover esta columna.
ARCHIVO 4: init.sql (Sincronización)
Paso 4.1 - Sincronizar FASE A (schema OLTP)
Aplicar los mismos cambios de los pasos 1.1, 1.2 y 1.3 en las secciones correspondientes:
- RECOMIENDA: líneas 72-78
- REGISTRO_CONTRATO: línea 95
- METAS: agregar después de REGISTRO_SINIESTRO (después de línea 114)
Paso 4.2 - Actualizar datos de prueba (FASE B)
- RECOMIENDA: Agregar columna fecha_evaluacion a todos los INSERTs existentes (líneas 256-316). Usar fechas distribuidas entre 2024-2026 para que el Indicador 9 funcione. Ejemplo:
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C009', 'E1', 'P03', 'NO', '2025-03-15');
- METAS: Agregar INSERTs con datos reales de metas anuales por producto. Mínimo 8-12 filas cubriendo años 2019-2026 y los 4 productos:
INSERT INTO METAS (annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES
(2024, 'P01', 20, 10, 50000.00, '2024-01-01', '2024-12-31'),
(2024, 'P02', 25, 12, 60000.00, '2024-01-01', '2024-12-31'),
...
(2026, 'P01', 30, 15, 70000.00, '2026-01-01', '2026-12-31');
Paso 4.3 - Sincronizar FASE C (schema DW)
Aplicar los mismos cambios de los pasos 2.1, 2.2 y 2.3 en las secciones correspondientes:
- FACT_REGISTRO_CONTRATO: líneas 764-776
- FACT_EVALUACION_SERVICIO: líneas 794-800
- PKs: agregar a las 4 fact tables
Paso 4.4 - Sincronizar FASE E (ETL)
Aplicar los mismos cambios de los pasos 3.1, 3.2, 3.3 y 3.4 en el procedimiento almacenado (líneas 832-936).
ORDEN DE EJECUCIÓN RECOMENDADO
1. schema.sql primero (define la estructura OLTP)
2. schemaDW.sql segundo (define la estructura DW)
3. actualizar.sql tercero (define el ETL)
4. init.sql último (consolida todo y debe quedar idéntico a los 3 anteriores en sus secciones correspondientes)
VERIFICACIÓN POST-IMPLEMENTACIÓN
Después de aplicar todos los cambios, ejecutar en PostgreSQL:
-- Verificar que la tabla METAS existe
SELECT * FROM "SEGURO_G27797047".METAS LIMIT 5;

-- Verificar que RECOMIENDA tiene fecha_evaluacion
SELECT fecha_evaluacion FROM "SEGURO_G27797047".RECOMIENDA LIMIT 5;

-- Ejecutar el ETL
CALL actualizar_datawarehouse();

-- Verificar indicadores críticos
-- Indicador 2: Contratos por estado
SELECT de.DESCRIP_ESTADO, COUNT(*) FROM "SEGURO_DW_G27797047".FACT_REGISTRO_CONTRATO f
JOIN "SEGURO_DW_G27797047".DIM_ESTADO_CONTRATO de ON f.SK_DIM_ESTADO_CONTRATO = de.SK_DIM_ESTADO
GROUP BY de.DESCRIP_ESTADO;

-- Indicador 7: Distribución por sucursal
SELECT ds.NB_SUCURSAL, COUNT(*) FROM "SEGURO_DW_G27797047".FACT_REGISTRO_CONTRATO f
JOIN "SEGURO_DW_G27797047".DIM_SUCURSAL ds ON f.SK_DIM_SUCURSAL = ds.SK_DIM_SUCURSAL
GROUP BY ds.NB_SUCURSAL;

-- Indicador 9: Top productos últimos 2 años
SELECT dp.NB_PRODUCTO, SUM(f.CANTIDAD) FROM "SEGURO_DW_G27797047".FACT_EVALUACION_SERVICIO f
JOIN "SEGURO_DW_G27797047".DIM_PRODUCTO dp ON f.SK_DIM_PRODUCTO = dp.SK_DIM_PRODUCTO
JOIN "SEGURO_DW_G27797047".DIM_TIEMPO dt ON f.SK_DIM_TIEMPO_FECHA_EVALUACION = dt.SK_DIM_TIEMPO
WHERE dt.COD_ANNIO >= 2024 GROUP BY dp.NB_PRODUCTO ORDER BY SUM(f.CANTIDAD) DESC LIMIT 10;

-- Indicadores 5,6,11,12: Metas
SELECT * FROM "SEGURO_DW_G27797047".FACT_METAS LIMIT 10;