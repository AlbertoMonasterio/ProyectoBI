import re

with open('init.sql', 'r', encoding='utf-8') as f:
    init_sql = f.read()

with open('datos_prueba.sql', 'r', encoding='utf-8') as f:
    datos = f.read()

# Quitar las dos primeras lineas de datos_prueba.sql
datos = datos.split('\n', 2)[-1]

# Buscar FASE B
header_b = '-- FASE B: INSERCI'
idx_fase_b = init_sql.find(header_b)

if idx_fase_b != -1:
    # A partir de FASE B, buscar el set search_path
    start_str = 'SET search_path TO "SEGURO_G27797047";\n'
    start_idx = init_sql.find(start_str, idx_fase_b)
    
    end_str = '-- =========================================================================\n-- FASE C: MODELO DIMENSIONAL'
    end_idx = init_sql.find(end_str, idx_fase_b)
    
    if start_idx != -1 and end_idx != -1:
        new_init = init_sql[:start_idx + len(start_str) + 1] + datos + '\n' + init_sql[end_idx:]
        with open('init.sql', 'w', encoding='utf-8') as f:
            f.write(new_init)
        print("INJECTION SUCCESSFUL")
    else:
        print(f"start_idx: {start_idx}, end_idx: {end_idx}")
else:
    print("FASE B not found")
