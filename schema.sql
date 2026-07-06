-- Creación y selección del esquema fuente
CREATE SCHEMA IF NOT EXISTS "SEGURO_G27797047";
SET search_path TO "SEGURO_G27797047";

-- 1. PAIS
CREATE TABLE PAIS (
    cod_pais VARCHAR(10) PRIMARY KEY,
    nb_pais VARCHAR(100) NOT NULL
);

-- 2. CIUDAD
CREATE TABLE CIUDAD (
    cod_ciudad VARCHAR(10) PRIMARY KEY,
    nb_ciudad VARCHAR(100) NOT NULL,
    cod_pais VARCHAR(10) REFERENCES PAIS(cod_pais)
);

-- 3. SUCURSAL
CREATE TABLE SUCURSAL (
    cod_sucursal VARCHAR(10) PRIMARY KEY,
    nb_sucursal VARCHAR(100) NOT NULL,
    cod_ciudad VARCHAR(10) REFERENCES CIUDAD(cod_ciudad)
);

-- 4. TIPO_PRODUCTO (TipoSeguro)
CREATE TABLE TIPO_PRODUCTO (
    cod_tipo_producto VARCHAR(10) PRIMARY KEY,
    nb_tipo_producto VARCHAR(100) NOT NULL
);

-- 5. PRODUCTO (Seguro)
CREATE TABLE PRODUCTO (
    cod_producto VARCHAR(10) PRIMARY KEY,
    nb_producto VARCHAR(100) NOT NULL,
    descripcion TEXT,
    cod_tipo_producto VARCHAR(10) REFERENCES TIPO_PRODUCTO(cod_tipo_producto),
    calificacion INTEGER
);

-- 6. CLIENTE
CREATE TABLE CLIENTE (
    cod_cliente VARCHAR(10) PRIMARY KEY,
    nb_cliente VARCHAR(150) NOT NULL,
    ci_rif VARCHAR(20) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
    email VARCHAR(100),
    cod_sucursal VARCHAR(10) REFERENCES SUCURSAL(cod_sucursal)
);

-- 7. EVALUACION_SERVICIO
CREATE TABLE EVALUACION_SERVICIO (
    cod_evaluacion_servicio VARCHAR(10) PRIMARY KEY,
    nb_descripcion VARCHAR(50) NOT NULL
);

-- 8. RECOMIENDA
CREATE TABLE RECOMIENDA (
    cod_cliente VARCHAR(10) REFERENCES CLIENTE(cod_cliente),
    cod_evaluacion_servicio VARCHAR(10) REFERENCES EVALUACION_SERVICIO(cod_evaluacion_servicio),
    cod_producto VARCHAR(10) REFERENCES PRODUCTO(cod_producto),
    recomienda_amigo VARCHAR(2) CHECK (recomienda_amigo IN ('SI', 'NO')),
    PRIMARY KEY (cod_cliente, cod_producto)
);

-- 9. CONTRATO
CREATE TABLE CONTRATO (
    nro_contrato VARCHAR(20) PRIMARY KEY,
    descrip_contrato TEXT
);

-- 10. REGISTRO_CONTRATO
CREATE TABLE REGISTRO_CONTRATO (
    id_registro SERIAL PRIMARY KEY,
    nro_contrato VARCHAR(20) REFERENCES CONTRATO(nro_contrato),
    cod_producto VARCHAR(10) REFERENCES PRODUCTO(cod_producto),
    cod_cliente VARCHAR(10) REFERENCES CLIENTE(cod_cliente),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    monto REAL NOT NULL,
    estado_contrato VARCHAR(20) CHECK (estado_contrato IN ('activo', 'vencido', 'suspendido'))
);

-- 11. SINIESTRO
CREATE TABLE SINIESTRO (
    nro_siniestro VARCHAR(20) PRIMARY KEY,
    descripcion_siniestro TEXT NOT NULL
);

-- 12. REGISTRO_SINIESTRO
CREATE TABLE REGISTRO_SINIESTRO (
    id_registro_siniestro SERIAL PRIMARY KEY,
    nro_siniestro VARCHAR(20) REFERENCES SINIESTRO(nro_siniestro),
    nro_contrato VARCHAR(20) REFERENCES CONTRATO(nro_contrato),
    fecha_siniestro DATE NOT NULL,
    fecha_respuesta DATE,
    id_rechazo VARCHAR(2) CHECK (id_rechazo IN ('SI', 'NO')),
    monto_reconocido REAL,
    monto_solicitado REAL NOT NULL
);