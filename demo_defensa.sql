-- ===========================================================================
-- SCRIPT DE DEMO PARA LA DEFENSA EN VIVO
-- Proyecto BI - Aseguradora - Fase II
-- ===========================================================================
-- INSTRUCCIONES:
--   PASO 1: Ejecutar todos los INSERT de abajo
--   PASO 2: Ejecutar: CALL actualizar_datawarehouse();
--   PASO 3: Refrescar el dashboard en Power BI y mostrar los cambios
-- ===========================================================================

SET search_path TO "SEGURO_G27797047";

-- ===========================================================================
-- PASO 1A: INSERT QUE AFECTAN DIMENSIONES
-- 10 nuevos clientes → afectan DIM_CLIENTE
-- 10 nuevos contratos en catálogo → afectan DIM_CONTRATO
-- ===========================================================================

-- 10 nuevos clientes
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES
('D001', 'Sofía Valentina Ramos',    'V-40100001', '0412-1000001', 'Av. Bolivar, Caracas',              'F', 'sofia.ramos@demo.com',    'SUC01'),
('D002', 'Alejandro Torres Gil',     'V-40100002', '0424-1000002', 'Calle 72, Maracaibo',               'M', 'alex.torres@demo.com',    'SUC02'),
('D003', 'María José Pereira',       'V-40100003', '0416-1000003', 'Urb. El Trigal, Valencia',          'F', 'mj.pereira@demo.com',     'SUC03'),
('D004', 'Carlos Eduardo Bermúdez',  'V-40100004', '0414-1000004', 'Av. Las Delicias, Maracay',         'M', 'carlos.berm@demo.com',    'SUC01'),
('D005', 'Valentina Castillo',       'V-40100005', '0426-1000005', 'Av. Francisco de Miranda, Caracas', 'F', 'val.castillo@demo.com',   'SUC02'),
('D006', 'Andrés Felipe Morales',    'V-40100006', '0412-1000006', 'Av. Lara, Barquisimeto',            'M', 'andres.mora@demo.com',    'SUC03'),
('D007', 'Isabella Fernández',       'V-40100007', '0424-1000007', 'Av. Bolivar, Caracas',              'F', 'isa.fern@demo.com',       'SUC01'),
('D008', 'Luis Miguel Soto',         'V-40100008', '0416-1000008', 'Calle 72, Maracaibo',               'M', 'lm.soto@demo.com',        'SUC02'),
('D009', 'Gabriela Inés Molina',     'V-40100009', '0414-1000009', 'Urb. El Trigal, Valencia',          'F', 'gabi.molina@demo.com',    'SUC03'),
('D010', 'Roberto Antonio Blanco',   'V-40100010', '0426-1000010', 'Av. Las Delicias, Maracay',         'M', 'rob.blanco@demo.com',     'SUC01');

-- 10 nuevos contratos en catálogo
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES
('CT-D001', 'Póliza de automóvil – cliente demo D001'),
('CT-D002', 'Póliza de salud – cliente demo D002'),
('CT-D003', 'Póliza de incendios – cliente demo D003'),
('CT-D004', 'Póliza de vida – cliente demo D004'),
('CT-D005', 'Póliza de automóvil – cliente demo D005'),
('CT-D006', 'Póliza de salud – cliente demo D006'),
('CT-D007', 'Póliza de incendios – cliente demo D007'),
('CT-D008', 'Póliza de vida – cliente demo D008'),
('CT-D009', 'Póliza de automóvil – cliente demo D009'),
('CT-D010', 'Póliza de salud – cliente demo D010');

-- ===========================================================================
-- PASO 1B: INSERT QUE AFECTAN FACT_REGISTRO_CONTRATO
-- 10 registros de contratos nuevos con montos altos para impactar gráficos
-- ===========================================================================
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES
('CT-D001', 'P01', 'D001', '2026-07-13', '2027-07-13', 3200.00,  'activo'),
('CT-D002', 'P02', 'D002', '2026-07-13', '2027-07-13', 4800.00,  'activo'),
('CT-D003', 'P03', 'D003', '2026-07-13', '2027-07-13', 2750.00,  'activo'),
('CT-D004', 'P04', 'D004', '2026-07-13', '2027-07-13', 5500.00,  'activo'),
('CT-D005', 'P01', 'D005', '2026-07-13', '2027-07-13', 2900.00,  'activo'),
('CT-D006', 'P02', 'D006', '2026-07-13', '2027-07-13', 4100.00,  'activo'),
('CT-D007', 'P03', 'D007', '2026-07-13', '2027-07-13', 3300.00,  'activo'),
('CT-D008', 'P04', 'D008', '2026-07-13', '2027-07-13', 6000.00,  'activo'),
('CT-D009', 'P01', 'D009', '2026-07-13', '2027-07-13', 2500.00,  'activo'),
('CT-D010', 'P02', 'D010', '2026-07-13', '2027-07-13', 4400.00,  'activo');

-- ===========================================================================
-- PASO 1C: INSERT QUE AFECTAN FACT_REGISTRO_SINIESTRO
-- 8 siniestros nuevos (mix de aprobados y rechazados) para impactar KPIs
-- ===========================================================================
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES
('SIN-01', 'CT-D001', '2026-07-13', '2026-07-14', 'NO', 3200.00,  3200.00),
('SIN-02', 'CT-D002', '2026-07-13', '2026-07-15', 'NO', 4800.00,  4800.00),
('SIN-03', 'CT-D003', '2026-07-13', '2026-07-16', 'SI',    0.00,  2750.00),
('SIN-04', 'CT-D004', '2026-07-13', '2026-07-14', 'NO', 5500.00,  5500.00),
('SIN-05', 'CT-D005', '2026-07-13', '2026-07-17', 'SI',    0.00,  2900.00),
('SIN-01', 'CT-D006', '2026-07-13', '2026-07-14', 'NO', 4100.00,  4100.00),
('SIN-02', 'CT-D007', '2026-07-13', '2026-07-15', 'NO', 3300.00,  3300.00),
('SIN-03', 'CT-D008', '2026-07-13', '2026-07-16', 'NO', 6000.00,  6000.00);

-- ===========================================================================
-- PASO 1D: INSERT QUE AFECTAN FACT_EVALUACION_SERVICIO
-- 10 evaluaciones, la mayoría positivas (E4/E5) para mostrar índice de satisfacción
-- ===========================================================================
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES
('D001', 'E5', 'P01', 'SI', '2026-07-13'),
('D002', 'E4', 'P02', 'SI', '2026-07-13'),
('D003', 'E5', 'P03', 'SI', '2026-07-13'),
('D004', 'E3', 'P04', 'SI', '2026-07-13'),
('D005', 'E4', 'P01', 'SI', '2026-07-13'),
('D006', 'E5', 'P02', 'SI', '2026-07-13'),
('D007', 'E2', 'P03', 'NO', '2026-07-13'),
('D008', 'E4', 'P04', 'SI', '2026-07-13'),
('D009', 'E5', 'P01', 'SI', '2026-07-13'),
('D010', 'E1', 'P02', 'NO', '2026-07-13');

-- ===========================================================================
-- PASO 2: EJECUTAR EL ETL INCREMENTAL
-- ===========================================================================
CALL actualizar_datawarehouse();

-- ===========================================================================
-- VERIFICACIÓN: comprobar que los datos llegaron al DW sin duplicados
-- ===========================================================================
SET search_path TO "SEGURO_DW_G27797047";

-- Conteo total en cada tabla de hechos
SELECT 'FACT_REGISTRO_CONTRATO'   AS tabla, COUNT(*) AS total_registros FROM FACT_REGISTRO_CONTRATO
UNION ALL
SELECT 'FACT_REGISTRO_SINIESTRO'  AS tabla, COUNT(*) AS total_registros FROM FACT_REGISTRO_SINIESTRO
UNION ALL
SELECT 'FACT_EVALUACION_SERVICIO' AS tabla, COUNT(*) AS total_registros FROM FACT_EVALUACION_SERVICIO
UNION ALL
SELECT 'FACT_METAS'               AS tabla, COUNT(*) AS total_registros FROM FACT_METAS;

-- Mostrar los 10 nuevos contratos en el DW
SELECT dc.COD_CLIENTE, dc.NB_CLIENTE, dp.NB_PRODUCTO, frc.MONTO, dcon.NRO_CONTRATO
FROM FACT_REGISTRO_CONTRATO frc
JOIN DIM_CLIENTE  dc   ON frc.SK_DIM_CLIENTE   = dc.SK_DIM_CLIENTE
JOIN DIM_PRODUCTO dp   ON frc.SK_DIM_PRODUCTO   = dp.SK_DIM_PRODUCTO
JOIN DIM_CONTRATO dcon ON frc.SK_DIM_CONTRATO   = dcon.SK_DIM_CONTRATO
WHERE dcon.NRO_CONTRATO LIKE 'CT-D%'
ORDER BY frc.MONTO DESC;

-- Mostrar los nuevos siniestros en el DW
SELECT dc.COD_CLIENTE, dsin.DESCRIP_SINIESTRO, frs.MONTO_SOLICITADO, frs.MONTO_RECONOCIDO, frs.ID_RECHAZO
FROM FACT_REGISTRO_SINIESTRO frs
JOIN DIM_CLIENTE  dc   ON frs.SK_DIM_CLIENTE   = dc.SK_DIM_CLIENTE
JOIN DIM_SINIESTRO dsin ON frs.SK_DIM_SINIESTRO = dsin.SK_DIM_SINIESTRO
WHERE dc.COD_CLIENTE LIKE 'D%'
ORDER BY frs.MONTO_SOLICITADO DESC;
