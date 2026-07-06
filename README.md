# Proyecto BI - Data Warehouse de Seguros

Este repositorio contiene la arquitectura completa de la base de datos para el proyecto de Inteligencia de Negocios. Incluye el modelo transaccional, el Data Warehouse (DW) en esquema de constelación y el proceso ETL automatizado mediante procedimientos almacenados.

## 🚀 Cómo empezar

Para montar el entorno de base de datos completo, sigue estos pasos:

1. **Requisitos**: Tener instalado [PostgreSQL](https://www.postgresql.org/download/) y [pgAdmin](https://www.pgadmin.org/download/).
2. **Crear base de datos**:
   - En pgAdmin, crea una nueva base de datos llamada `proyectoMainBI`.
3. **Ejecutar script de inicialización**:
   - Abre el **Query Tool** en la base de datos `proyectoMainBI`.
   - Abre el archivo `init.sql` ubicado en este repositorio.
   - Pega todo el contenido y presiona **F5** (o el botón de ejecutar).

> **¿Qué hace este script?** 
> - Crea los esquemas transaccionales y el DW.
> - Inserta los datos de prueba necesarios.
> - Pobla la dimensión tiempo automáticamente.
> - Compila y ejecuta el proceso ETL que llena las tablas de hechos.

## 📁 Estructura del Proyecto
- **Esquema `SEGURO_G27797047`**: Modelo transaccional fuente.
- **Esquema `SEGURO_DW_G27797047`**: Data Warehouse (Dimensiones y Facts).
- **ETL**: Procedimiento almacenado `actualizar_datawarehouse()` que sincroniza ambos esquemas.

## 📊 Conexión con BI
Para construir el Cuadro de Mando (Power BI/Qlik/Tableau), conéctate a la base de datos `proyectoMainBI` y apunta exclusivamente al esquema `SEGURO_DW_G27797047`.
