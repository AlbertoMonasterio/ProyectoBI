_**Inteligencia de Negocio Proyecto – Fase II Prof. Concettina Di Vasta Marzo2026-Julio2026**_ 

## **Proyecto – Fase II – Aseguradora Valor: 25 % Fecha de Entrega: 13 de Julio** 

Luego de haber realizado la Fase I del Proyecto, se quiere que usted realice las siguientes actividades para completar una solución de inteligencia de negocio: 

**1.** Implementación del **Modelo Relacional de la Base de Datos Transaccional** en el Sistema Manejador de Base de Datos (SMBD) de su preferencia. Puede elegir entre Oracle, PostgreSQL, SQLserver, entre otros.... Usted debe generar datos de prueba. (Creación de Scripts) (Incluir imagen de la implementación) 

**2.** Almacén de datos (Datawarehouse): Implementación física del modelo dimensional que usted considere adecuado utilizando el SMBD que eligió en el paso 1. 

**3.** Diseño e Implementación de los Procesos de Extracción, Transformación y Carga (ETL’s) a partir de la base de datos transaccional hacia el Almacén de Datos, usando cualquier herramienta que permita poblar el Almacén de datos. Puede hacer uso lenguaje de programación Java, un lenguaje procedimental (Ejemplo PL/SQL de Oracle), o alguna herramienta de ETL (Ejemplo: Pentaho Data Integrator (PDI)). Tiene libertad de escoger. 

**4.** Realizar ocho (8) de los indicadores escogidos en la Fase I usando una herramienta OLAP, por ejemplo: OBI (Oracle Business Inteligence), Power BI, Pentaho, Qlik, entre otras. 

## **CONDICIONES Y FORMATOS DE ENTREGA** 

## **De la Fuente de datos y Almacén de datos:** 

1. Los esquemas en el SMBD seleccionado deben seguir la siguiente nomenclatura: 

- **a. SEGURO_GXX** (esquema fuente) 

## b. **SEGURO _DW_GXX** 

donde **XX** es el número de cédula de identidad de alguno de los integrantes del grupo del proyecto. 

2. La Base de datos fuente debe ser poblada con la cantidad de registros suficientes que permitan comprobar los requerimientos solicitados. 

3. Base de Datos Fuente y Almacén de Datos pueden ser entregados en un script (formato .sql) donde incluya tanto la estructura de datos como los datos fuentes 

suministrados y validados por usted. Pueden agregar o ajustar algún atributo del modelado dimensional (si lo consideran relevante). 

## **De los ETL,s:** 

- Repositorio de archivo que incluya los .ktr de cada transformación y Jobs, o las consultas en PLSQL que permitan llenar las estructuras creadas. 

- Script con los procesos ETLs usados 

## **De las Consultas y Cuadro de Mando (Dashboard):** 

- Cuadro de mando integral (Dashboard): Portal web implementado en cualquier herramienta analítica (OBI, Pentaho, Qlik, Tableau, Excel, entre otras) que permita visualizar los indicadores propuestos en la Fase I. Este portal debe contener opciones de búsqueda y diversos tipos de vistas (gráficos barras, torta, tablas dinámicas, selectores de vista, entre otros). Puede utilizar pestanas adicionales para mostrar y agrupar los indicadores. 

## **De la Revisión y Evaluación en general** 

- Esta 2da Fase del proyecto debe ser entregada máximo hasta el día **13 de Julio 2026** en formato digital vía correo electrónico para su revisión. El día 13 de Julio de 2026 se planifica hacer la defensa del proyecto por grupo. Deben participar todos los integrantes del grupo de proyecto. 

## **Modelo Dimensional. Aseguradora** 

## **Proceso de Negocio: Metas** 

**Proceso de Negocio: Evaluación_Servicio** 

## **Proceso de Negocio: Registro Contrato** 

## **Proceso de Negocio: Registro Siniestro** 

**PK Primary Key: Clave primaria FK Foreign Key: Clave Foránea NL. Natural Key: Clave Natural TDVR/tdvr/Mayo2026** 

## **MODELO DIMENSIONAL DE REFERENCIA** 

Modelo dimensional para el Data Warehouse de Seguros Alta Vista, basado en la metodología de Ralph Kimball. Esquema de Constelación de Hechos con 4 tablas de hechos y 8 dimensiones conformadas. 

## **1. Tablas de Hechos (FACT)** 

## **1.1 FACT_REGISTRO_CONTRATO — Indicadores: 2,3,4,7,8,10,15,17,18,19** 

Grano: Un registro por contrato formalizado. DIM_TIEMPO actúa en role-playing: fecha_inicio y fecha_fin. 

## **Campos de FACT_REGISTRO_CONTRATO** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**_SK_DIM_TIEMPO_FECHA_INICIO_**<br>**_(FK)_**|INTEGER|Rol: fecha de inicio de vigencia|
|**_SK_DIM_TIEMPO_FECHA_FIN_**<br>**_(FK)_**|INTEGER|Rol: fecha de fin de vigencia|
|**_SK_DIM_CLIENTE (FK)_**|INTEGER|Cliente contratante|
|**_SK_DIM_CONTRATO (FK)_**|INTEGER|Contrato asociado|
|**_SK_DIM_PRODUCTO (FK)_**|INTEGER|Producto de seguro contratado|
|**_SK_DIM_ESTADO_CONTRATO_**<br>**_(FK)_**|INTEGER|Estado (activo / vencido / suspendido)|
|MONTO|REAL|Ingreso monetario por contrato (aditivo)|



||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|CANTIDAD|INTEGER|Contador de contratos (valor 1 por fila)|
|CANTIDAD_CLIENTE|INTEGER|Contador de clientes distintos|
|CANTIDAD_PRODUCTO|INTEGER|Contador de productos distintos|
|CANTIDAD_CONTRATO|INTEGER|Contador de contratos activos/renovados|



## **1.2 FACT_REGISTRO_SINIESTRO — Indicador: 20** 

Grano: Un registro por siniestro reportado. DIM_TIEMPO en role-playing: SK_FECHA_SINIESTRO y SK_FECHA_RESPUESTA. 

## **Campos de FACT_REGISTRO_SINIESTRO** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**_SK_FECHA_SINIESTRO (FK)_**|INTEGER|Rol: fecha del siniestro|
|**_SK_FECHA_RESPUESTA (FK)_**|INTEGER|Rol: fecha de respuesta|
|**_SK_DIM_CLIENTE (FK)_**|INTEGER|Cliente que reporta el siniestro|
|**_SK_DIM_CONTRATO (FK)_**|INTEGER|Contrato de origen|
|**_SK_DIM_SUCURSAL (FK)_**|INTEGER|Sucursal que procesa el reclamo|
|**_SK_DIM_PRODUCTO (FK)_**|INTEGER|Producto amparado|



||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**_SK_DIM_SINIESTRO (FK)_**|INTEGER|Tipo/naturaleza del siniestro|
|CANTIDAD|INTEGER|Contador de siniestros|
|MONTO_RECONOCIDO|REAL|Monto aprobado (aditivo)|
|MONTO_SOLICITADO|REAL|Monto reclamado (aditivo)|
|ID_RECHAZO|CHAR (2)|Indicador SI/NO de rechazo|



## **1.3 FACT_EVALUACION_SERVICIO — Indicadores: 9,13,14,16** 

Grano: Un registro por evaluación de servicio realizada por un cliente sobre un producto. 

## **Campos de FACT_EVALUACION_SERVICIO** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**_SK_DIM_CLIENTE (FK)_**|INTEGER|Cliente que emite la evaluación|
|**_SK_DIM_PRODUCTO (FK)_**|INTEGER|Producto evaluado|
|**_SK_DIM_EVALUACION_SERVICIO_**<br>**_(FK)_**|INTEGER|Categoría de calificación (1-5)|
|CANTIDAD|INTEGER|Contador de evaluaciones|
|RECOMIENDA_AMIGO|REAL|Porcentaje de recomendaciones positivas|



## **1.4 FACT_METAS — Indicadores: 5,6,11,12** 

Grano: Un registro por meta anual por producto. Tabla de instantánea periódica. Medidas semi-aditivas. DIM_TIEMPO en role-playing: fecha_inicio_meta y fecha_fin_meta. 

## **Campos de FACT_METAS** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**_SK_DIM_FECHA_INICIO_META_**<br>**_(FK)_**|INTEGER|Rol: inicio del periodo de meta|
|**_SK_DIM_FECHA_FIN_META (FK)_**|INTEGER|Rol: fin del periodo de meta|
|**_SK_DIM_CLIENTE (FK)_**|INTEGER|Segmento de clientes objetivo|
|**_SK_DIM_PRODUCTO (FK)_**|INTEGER|Producto al que aplica la meta|
|**_SK_DIM_CONTRATO (FK)_**|INTEGER|Contrato de referencia|
|MONTO_META_INGRESO|REAL|Ingreso esperado (semi-aditivo)|
|META_RENOVACION|INTEGER|Meta de renovaciones (semi-aditivo)|
|META_ASEGURADOS|INTEGER|Meta de asegurados (semi-aditivo)|



## **2. Dimensiones Conformadas** 

## **DIM_TIEMPO** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**SK_DIM_TIEMPO (PK)**|INTEGER|Clave subrogada única de tiempo|
|COD_ANNIO|INTEGER|Año calendario|
|COD_MES|INTEGER|Numero de mes (1-12)|
|COD_DIA|INTEGER|Dia del mes (1-31)|
|DESC_MES|VARCHAR|Nombre del mes (ej. Enero)|
|DESC_TRIMESTRE|VARCHAR|Trimestre (Q1, Q2, Q3, Q4)|
|DESC_SEMESTRE|VARCHAR|Semestre (S1, S2)|
|FECHA_COMPLETA|DATE|Fecha completa YYYY-MM-DD|



## **DIM_CLIENTE** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**SK_DIM_CLIENTE (PK)**|INTEGER|Clave subrogada única|
|COD_CLIENTE (NK)|VARCHAR|Clave natural del sistema transaccional|



||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|NB_CLIENTE|VARCHAR|Nombre completo del cliente|
|CI_RIF|VARCHAR|Cédula de identidad o RIF|
|TELEFONO|VARCHAR|Número de teléfono|
|DIRECCION|VARCHAR|Dirección de residencia|
|SEXO|CHAR (1)|Sexo del cliente (M/F)|
|EMAIL|VARCHAR|Correo electrónico|



## **DIM_PRODUCTO** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**SK_DIM_PRODUCTO (PK)**|INTEGER|Clave subrogada única|
|COD_PRODUCTO (NK)|VARCHAR|Clave natural del sistema transaccional|
|NB_PRODUCTO|VARCHAR|Nombre del producto de seguro|
|DESCRIP_PRODUCTO|VARCHAR|Descripción detallada|
|COD_TIPO_PRODUCTO|VARCHAR|Código del tipo de producto|
|NB_TIPO_PRODUCTO|VARCHAR|Nombre del tipo (Personal, Danos, Patrimonial)|



||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|CALIFICACION|INTEGER|Calificación promedio del producto|



## **DIM_CONTRATO** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**SK_DIM_CONTRATO (PK)**|INTEGER|Clave subrogada única|
|NRO_CONTRATO (NK)|VARCHAR|Numero operacional del contrato|
|DESCRIP_CONTRATO|VARCHAR|Descripción del contrato|



## **DIM_SUCURSAL** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**SK_DIM_SUCURSAL (PK)**|INTEGER|Clave subrogada única|
|COD_SUCURSAL (NK)|VARCHAR|Código operacional|
|NB_SUCURSAL|VARCHAR|Nombre de la sucursal|
|COD_CIUDAD|VARCHAR|Código de la ciudad|



||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|NB_CIUDAD|VARCHAR|Nombre de la ciudad|
|COD_PAIS|VARCHAR|Código del país|
|NB_PAIS|VARCHAR|Nombre del país|



## **DIM_ESTADO_CONTRATO** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**SK_DIM_ESTADO (PK)**|INTEGER|Clave subrogada única|
|COD_ESTADO|CHAR (2)|Código del estado del contrato|
|DESCRIP_ESTADO|VARCHAR|Descripción (Activo, Vencido, Suspendido)|



## **DIM_EVALUACION_SERVICIO** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**SK_DIM_EVALUACION (PK)**|INTEGER|Clave subrogada única|
|COD_EVALUACION (NK)|VARCHAR|Clave natural del sistema transaccional|
|NB_DESCRIP|VARCHAR|Descripción (Malo, Regular, Bueno, Muy Bueno, Excelente)|



## **DIM_SINIESTRO** 

||||
|---|---|---|
|**Campo**|**Tipo**|**Descripción**|
|**SK_DIM_SINIESTRO (PK)**|INTEGER|Clave subrogada única|
|NRO_SINIESTRO (NK)|VARCHAR|Número operacional del siniestro|
|DESCRIP_SINIESTRO|VARCHAR|Descripción del tipo de siniestro|



