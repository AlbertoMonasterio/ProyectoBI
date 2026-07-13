import random
from datetime import timedelta
import datetime
from faker import Faker

# Usamos es_ES exclusivamente para obtener nombres y apellidos en español
fake = Faker('es_ES')

# ==========================================
# 1. DATOS MAESTROS (Dimensiones Básicas)
# ==========================================
paises = [("VE", "Venezuela")]
ciudades = [
    ("CCS", "Caracas", "VE"), 
    ("MAR", "Maracaibo", "VE"), 
    ("VAL", "Valencia", "VE"),
    ("BQT", "Barquisimeto", "VE")
]

sucursales = [
    ("SUC01", "Sucursal Caracas", "CCS"), 
    ("SUC02", "Sucursal Zulia", "MAR"), 
    ("SUC03", "Sucursal Carabobo", "VAL")
]

tipos_producto = [
    ("TP01", "Personales"),
    ("TP02", "Danos"),
    ("TP03", "Patrimonial")
]

productos = [
    ("P01", "Automovil", "Seguro basico de vehiculos", "TP02", 4),
    ("P02", "Salud", "Cobertura medica amplia", "TP01", 5),
    ("P03", "Incendios", "Proteccion contra incendios a locales", "TP03", 3),
    ("P04", "Vida", "Poliza de vida a termino", "TP01", 4)
]

evaluaciones = [
    ("E1", "Malo"),
    ("E2", "Regular"),
    ("E3", "Bueno"),
    ("E4", "Muy Bueno"),
    ("E5", "Excelente")
]

siniestros_catalogo = [
    ("SIN-01", "Choque vehicular"),
    ("SIN-02", "Robo de vehiculo"),
    ("SIN-03", "Emergencia medica general"),
    ("SIN-04", "Incendio estructural leve"),
    ("SIN-05", "Dano por agua en vivienda")
]

# Vectores para aleatorizar datos de contacto locales
prefijos_tlf = ['0414', '0424', '0412', '0416', '0426', '0212']
direcciones_ve = [
    'Av. Francisco de Miranda, Caracas', 
    'Av. Las Delicias, Maracay', 
    'Calle 72, Maracaibo', 
    'Urb. El Trigal, Valencia', 
    'Av. Lara, Barquisimeto',
    'Av. Bolivar, Caracas'
]

# ==========================================
# 2. GENERACIÓN DE DATOS TRANSACCIONALES
# ==========================================

# Generar 300 CLIENTES
clientes = []
for i in range(1, 301):
    cod_cliente = f"C{i:03d}"
    nb_cliente = fake.name()
    ci_rif = f"V-{random.randint(5000000, 31000000)}"
    telefono = f"{random.choice(prefijos_tlf)}-{random.randint(1000000, 9999999)}"
    direccion = random.choice(direcciones_ve)
    sexo = random.choice(['M', 'F'])
    email = fake.email()
    cod_sucursal = random.choice([s[0] for s in sucursales])
    clientes.append((cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal))

# Generar 150 RECOMENDACIONES (EVALUACION_SERVICIO)
recomendaciones = []
# Evitamos duplicidad de llaves primarias en Recomendaciones seleccionando clientes únicos
clientes_evaluando = random.sample(clientes, 150)
for c in clientes_evaluando:
    cod_cliente = c[0]
    evaluacion_obj = random.choice(evaluaciones)
    cod_eval = evaluacion_obj[0]
    cod_producto = random.choice(productos)[0]
    # Logica simple: si evalua bien (E3, E4, E5), recomienda.
    recomienda = 'SI' if cod_eval in ['E3', 'E4', 'E5'] else 'NO'
    fecha_eval = fake.date_between(start_date='-2y', end_date='today')
    recomendaciones.append((cod_cliente, cod_eval, cod_producto, recomienda, fecha_eval))

# Generar 500 CONTRATOS y REGISTRO_CONTRATO
contratos = []
registros_contratos = []
estados_contrato = ['activo', 'vencido', 'suspendido']

for i in range(1, 501):
    nro_contrato = f"CT-{i:04d}"
    descrip = f"Contrato de poliza {i} para asegurado"
    contratos.append((nro_contrato, descrip))
    
    cod_producto = random.choice(productos)[0]
    cod_cliente = random.choice(clientes)[0]
    
    # Fechas explicitamente entre 2023 y 2026
    start_date = fake.date_between(start_date=datetime.date(2023, 1, 1), end_date=datetime.date(2026, 12, 31))
    end_date = start_date + timedelta(days=365)
    
    monto = round(random.uniform(150.0, 2500.0), 2)
    estado = random.choice(estados_contrato)
    
    registros_contratos.append((nro_contrato, cod_producto, cod_cliente, start_date, end_date, monto, estado))

# Generar 150 REGISTRO_SINIESTRO basados en los contratos existentes
registros_siniestros = []
contratos_con_siniestro = random.sample(registros_contratos, 150)

for reg_c in contratos_con_siniestro:
    nro_contrato = reg_c[0]
    nro_siniestro = random.choice(siniestros_catalogo)[0]
    fecha_ini_contrato = reg_c[3]
    
    # El siniestro ocurre despues del inicio del contrato
    fecha_siniestro = fecha_ini_contrato + timedelta(days=random.randint(10, 300))
    # La respuesta ocurre despues del siniestro
    fecha_respuesta = fecha_siniestro + timedelta(days=random.randint(2, 30))
    
    id_rechazo = random.choice(['SI', 'NO'])
    monto_solicitado = round(random.uniform(100.0, 5000.0), 2)
    # Si se rechaza, el monto reconocido es 0
    monto_reconocido = monto_solicitado if id_rechazo == 'NO' else 0.0
    
    registros_siniestros.append((nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado))

# Generar METAS anuales por producto (años 2019-2026, 4 productos)
metas = []
cod_meta_id = 1
for annio in range(2019, 2027):  # 8 años
    for producto in productos:
        cod_producto = producto[0]
        meta_asegurados = random.randint(15, 40)
        meta_renovacion = random.randint(8, 20)
        meta_ingreso = round(random.uniform(30000.0, 80000.0), 2)
        fecha_inicio = f"{annio}-01-01"
        fecha_fin = f"{annio}-12-31"
        metas.append((cod_meta_id, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin))
        cod_meta_id += 1

# ==========================================
# 3. ESCRITURA DEL ARCHIVO SQL
# ==========================================
with open('datos_prueba.sql', 'w', encoding='utf-8') as f:
    f.write("SET search_path TO SEGURO_GXX;\n\n") 
    
    f.write("-- 1. PAIS\n")
    for row in paises:
        f.write(f"INSERT INTO PAIS (cod_pais, nb_pais) VALUES ('{row[0]}', '{row[1]}');\n")
        
    f.write("\n-- 2. CIUDAD\n")
    for row in ciudades:
        f.write(f"INSERT INTO CIUDAD (cod_ciudad, nb_ciudad, cod_pais) VALUES ('{row[0]}', '{row[1]}', '{row[2]}');\n")
        
    f.write("\n-- 3. SUCURSAL\n")
    for row in sucursales:
        f.write(f"INSERT INTO SUCURSAL (cod_sucursal, nb_sucursal, cod_ciudad) VALUES ('{row[0]}', '{row[1]}', '{row[2]}');\n")

    f.write("\n-- 4. TIPO_PRODUCTO\n")
    for row in tipos_producto:
        f.write(f"INSERT INTO TIPO_PRODUCTO (cod_tipo_producto, nb_tipo_producto) VALUES ('{row[0]}', '{row[1]}');\n")

    f.write("\n-- 5. PRODUCTO\n")
    for row in productos:
        f.write(f"INSERT INTO PRODUCTO (cod_producto, nb_producto, descripcion, cod_tipo_producto, calificacion) VALUES ('{row[0]}', '{row[1]}', '{row[2]}', '{row[3]}', {row[4]});\n")
        
    f.write("\n-- 6. CLIENTE\n")
    for row in clientes:
        f.write(f"INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('{row[0]}', '{row[1]}', '{row[2]}', '{row[3]}', '{row[4]}', '{row[5]}', '{row[6]}', '{row[7]}');\n")

    f.write("\n-- 7. EVALUACION_SERVICIO\n")
    for row in evaluaciones:
        f.write(f"INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('{row[0]}', '{row[1]}');\n")

    f.write("\n-- 8. RECOMIENDA\n")
    for row in recomendaciones:
        f.write(f"INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('{row[0]}', '{row[1]}', '{row[2]}', '{row[3]}', '{row[4]}');\n")

    f.write("\n-- 9. CONTRATO\n")
    for row in contratos:
        f.write(f"INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('{row[0]}', '{row[1]}');\n")

    f.write("\n-- 10. REGISTRO_CONTRATO\n")
    for row in registros_contratos:
        f.write(f"INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('{row[0]}', '{row[1]}', '{row[2]}', '{row[3]}', '{row[4]}', {row[5]}, '{row[6]}');\n")

    f.write("\n-- 11. SINIESTRO\n")
    for row in siniestros_catalogo:
        f.write(f"INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('{row[0]}', '{row[1]}');\n")

    f.write("\n-- 12. REGISTRO_SINIESTRO\n")
    for row in registros_siniestros:
        f.write(f"INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('{row[0]}', '{row[1]}', '{row[2]}', '{row[3]}', '{row[4]}', {row[5]}, {row[6]});\n")

    f.write("\n-- 13. METAS\n")
    for row in metas:
        f.write(f"INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES ({row[0]}, {row[1]}, '{row[2]}', {row[3]}, {row[4]}, {row[5]}, '{row[6]}', '{row[7]}');\n")

print("Archivo datos_prueba.sql generado exitosamente con 13 tablas (incluyendo METAS).")