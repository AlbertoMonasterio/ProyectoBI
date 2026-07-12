_**Inteligencia de Negocio Proyecto – Fase I Prof. Concettina Di Vasta Marzo2026-Julio2026**_ 

## **PROYECTO FASE I - 15%** 

El grupo Seguros Alta Vista desea gerenciar la empresa de manera exitosa en el complejo y dinámico mundo actual. Para ello, se ha propuesto analizar efectivamente sus indicadores, gestionar productivamente los procesos y acercarse de manera motivadora a sus clientes para ser exitoso de manera sostenida en su nicho de negocios. 

Específicamente, tiene como propósito gestionar los negocios a través de indicadores clave (de rendimiento, riesgo y control) con el fin de: 

1. Gobernar ágilmente la organización tanto a lo interno como a lo externo 

2. Mantener estructurados sus datos para generar información dinámicamente a demanda 

3. Transformar, crecer y evolucionar digitalmente la empresa al ritmo de la tecnología y la demanda de unos clientes cada vez más exigentes. 

A raíz del desastre en los negocios de toda índole generado por la pandemia del COVID 19, los directivos han decidido obtener estadísticas relevantes y confiables con la finalidad de realizar un análisis preciso de sus productos, evaluar el interés del público hacia los mismos y conocer con mayor precisión sus ingresos a través del tiempo. Por ello, para gerenciar de manera efectiva la empresa ha decidido manejar los indicadores de las siguientes áreas: 

1. Valor del Producto 

2. Visibilidad del Producto y Satisfacción del Cliente 

3. Calidad del Servicio 

4. Prudencia Financiera 

El negocio principal es la venta de productos (pólizas de seguros). En principio, la empresa tiene tres clases de seguros y cada clase de seguro tiene varias categorías o productos. Todos los productos tienen unas características predefinidas y su precio varía en función de las mismas. 

Al momento de cerrar la negociación, el cliente establece un contrato con la empresa, identificando el tipo de Producto que requiere y de esta manera se cierra el precio de la negociación. El sistema automáticamente le asigna un número de contrato/Producto calificándolo de acuerdo con una categorización predefinida en el sistema. 

1 

Por otro lado, se presentan los siniestros, eventos que suceden cuando un asegurado hace un reclamo por un daño que está cubierto en una póliza del producto por la cual está asegurado. Este reclamo puede ser aceptado o no; en ambos casos, se graba las fechas de solicitud y de respuesta 

Adicionalmente, la empresa Seguros Alta Vista mantiene un control estricto sobre los consumidores de sus Productos. El asegurado, al momento de adquirir el Producto, se identifica con unos datos mínimos como cédula, nombre y sexo, y se le informa que a la finalización del tiempo del seguro tendrá la posibilidad de calificarlo. Para evaluar un Producto es preciso responder: ¿lo recomendaría a un amigo (Si/No) ?, luego calificarlo de acuerdo a un rango (1 al 5) que significa el número de estrellas obtenidas (1-Malo, 2- Regular, 3-Bueno, 4-Muy Bueno, 5-Excelente). 

Para lograr que el asegurado realmente califique el Producto, existe un programa de incentivos donde el cliente opta por premios al final del contrato, si realmente realiza la evaluación. 

Como estadística importante, la empresa desea conocer si están alcanzando los objetivos trazados a nivel de ingresos, clientes y calidad del Producto. En cada año, la gerencia de estadística de la empresa tiene en una Hoja de Excel el número de clientes mínimo que debería asegurar y renovar en cada Producto. Así mismo, la Gerencia de Producción quiere conocer si realmente en la ejecución de la venta de Productos está alcanzando todas las metas que han propuesto inicialmente y si los ingresos sobrepasan o no los estimados por cada Producto. 

A continuación, se anexa un listado de los requerimientos que Seguros Alta Vista desea obtener: 

**1. Cantidad de Productos por Tipo de Producto.** 

**2. Cantidad de contratos por estado del mismo.** 

**3. Ingresos en el Año por Producto.** 

4. Meses de altas ventas a asegurados por cada Producto. 

**5. Cumplimiento de la meta de venta de cada Producto** 

6. Cumplimiento de la meta de renovación de cada Producto 

**7. Distribución (%) de Clientes en el año por Sucursal.** 

**8. Porcentaje de asegurados (que tienen un contrato) del sexo femenino por Producto.** 

9. Listado de Top 10 de los Productos con mayor calificación (ranking) en los últimos 2 años. 

**10. Variación de ingresos por Producto obtenidos en el año 2020 con respecto al año 2019.** 

## **11. Cumplimiento de la meta de asegurados.** 

## 12. Ingresos por Producto vendidos vs lo esperado. 

**13. Porcentaje calificaciones de “Recomendaría a un amigo” por Producto** 

14. Porcentaje calificaciones de “No Recomendaría a un amigo” por Producto 

2 

15. Clientes recurrentes (clientes que han adquirido más de un Producto en los últimos 2 años). 

16. Cantidad de Calificaciones por Producto y Tipo de Calificación. (Bueno, Excelente, etc.) 

17. Proporción de asegurados (que tienen un contrato) Masculinos. 

18. Distribución porcentual (%) por Tipo de Producto en el año. 

19. **Reporte operativo (por Producto, total de Productos, cantidad de calificaciones, cantidad de asegurados).** 

20. Cantidad de siniestros e Total del Monto reconocido por Tipo Siniestro. 

## **Ejemplo de PRODUCTOS** 

## **MODELO RELACIONAL** 

- **PAIS (** cod_pais, nb_pais **)** 

- **CIUDAD (** cod_ciudad, nb_ciudad, cod_pais), **cod_pais es FK referencia a cod_pais en PAIS** 

- **SUCURSAL** (cod_sucursal, nb_ sucursal, cod_ciudad) Ej. de nb_sucursal : Sucursal Caracas, Sucursal Zulia, Sucursal Guayana, entre otras. **cod_ciudad es FK referencia a cod_ciudad en CIUDAD** 

- **TIPO_PRODUCTO (TipoSeguro) (** cod_tipo_producto, nb_tipo_producto) Los tipos de producto pueden ser: Prestación de Servicios, Personales, Daños o Patrimoniales 

- **PRODUCTO (Seguro) (** cod_producto, nb_producto, descripcion, cod_tipo_producto, calificacion **)** Los nb_producto pueden ser: Automóvil, Crédito y Caución, Incendios, Salud, entre otros. 

## **cod_tipo_producto es FK referencia a cod_tipo_producto en TIPO_PRODUCTO** 

- **CLIENTE** (cod_cliente, nb_cliente, ci_rif/Cedula, teléfono, dirección, sexo, email, cod_sucursal) **cod_sucursal es FK referencia a cod_sucursal en SUCURSAL** 

3 

- **EVALUACION_SERVICIO** (cod_evaluacion_servicio, nb_descripcion) (1.Malo/2.-Regular/3.-Bueno, 4.-Muy Bueno, 5.-Excelente) 

- **RECOMIENDA (** cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) 

- **CONTRATO** (nro_ contrato, descrip_contrato) 

- **REGISTRO_CONTRATO** (nro_ contrato, cod_producto, cod_cliente , 

   - fecha_inicio, fecha_fin, monto, estado_contrato). El estado del contrato por producto puede ser: activo, vencido, suspendido. 

- **REGISTRO_SINIESTRO** : (nro_ siniestro, nro_ contrato, fecha_siniestro, fecha_respuesta, id_rechazo (SI/NO), monto_reconocido, monto_solicitado) 

- **SINIESTRO** : (nro_ siniestro, descripcion_siniestro) 

## **A partir de la información proveída, se desea que usted realice:** 

- **1.- Modelo Dimensional** identificando todos los pasos para el diseño 

   1. Identificación del (los) Proceso(s) del Negocio 

   2. Identificación de la granularidad 

   3. Identificación de las Dimensiones 

   4. Identificación de los Hechos 

   5. Selección del esquema a utilizar 

Recuerde que el modelo diseñado debe considerar la obtención de todos los indicadores expuestos anteriormente. 

Esta primera fase del proyecto debe ser entregado el **día 25 de Mayo de 2026 (semana 10)** en formato pdf en la tarea creada para tal fin en Módulo 7 . 

## **Grupo máximo de 3 personas** 

**Éxito** 

**Prof. Concettina Di Vasta I-2026** 

4 

