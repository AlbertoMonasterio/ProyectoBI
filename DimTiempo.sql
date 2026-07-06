-- 1. Limpiamos la tabla (CASCADE borrará temporalmente los hechos, 
-- pero no importa porque tu procedimiento almacenado los vuelve a llenar)
TRUNCATE TABLE "SEGURO_DW_G27797047".DIM_TIEMPO CASCADE;

-- 2. Insertamos la jerarquía de tiempo completa (2015 al 2030)
INSERT INTO "SEGURO_DW_G27797047".DIM_TIEMPO (
    SK_DIM_TIEMPO, COD_ANNIO, COD_MES, COD_DIA, DESC_MES, DESC_TRIMESTRE, DESC_SEMESTRE, FECHA_COMPLETA
)
SELECT 
    to_char(fecha, 'YYYYMMDD')::integer AS SK_DIM_TIEMPO,
    extract(year from fecha)::integer AS COD_ANNIO,
    extract(month from fecha)::integer AS COD_MES,
    extract(day from fecha)::integer AS COD_DIA,
    -- Nombres de meses fijos en español para el Dashboard
    CASE extract(month from fecha)
        WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
        WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre'
        WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
    END AS DESC_MES,
    -- Trimestres formateados
    'Trimestre ' || extract(quarter from fecha) AS DESC_TRIMESTRE,
    -- Cálculo exacto del semestre
    CASE WHEN extract(month from fecha) <= 6 THEN 'Semestre 1' ELSE 'Semestre 2' END AS DESC_SEMESTRE,
    fecha AS FECHA_COMPLETA
FROM generate_series('2015-01-01'::date, '2030-12-31'::date, '1 day'::interval) as fecha;