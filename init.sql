-- =========================================================================
-- SCRIPT DE INICIALIZACIÓN DE BASE DE DATOS Y DATA WAREHOUSE
-- PROYECTO BI - FASE II
-- =========================================================================

-- 1. LIMPIEZA PREVIA 
DROP SCHEMA IF EXISTS "SEGURO_G27797047" CASCADE;
DROP SCHEMA IF EXISTS "SEGURO_DW_G27797047" CASCADE;

-- =========================================================================
-- FASE A: MODELO TRANSACCIONAL (FUENTE)
-- =========================================================================

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

-- =========================================================================
-- FASE B: INSERCIÓN DE DATOS TRANSACCIONALES
-- =========================================================================
SET search_path TO "SEGURO_G27797047";

-- 1. PAIS
INSERT INTO PAIS (cod_pais, nb_pais) VALUES ('VE', 'Venezuela');

-- 2. CIUDAD
INSERT INTO CIUDAD (cod_ciudad, nb_ciudad, cod_pais) VALUES ('CCS', 'Caracas', 'VE');
INSERT INTO CIUDAD (cod_ciudad, nb_ciudad, cod_pais) VALUES ('MAR', 'Maracaibo', 'VE');
INSERT INTO CIUDAD (cod_ciudad, nb_ciudad, cod_pais) VALUES ('VAL', 'Valencia', 'VE');
INSERT INTO CIUDAD (cod_ciudad, nb_ciudad, cod_pais) VALUES ('BQT', 'Barquisimeto', 'VE');

-- 3. SUCURSAL
INSERT INTO SUCURSAL (cod_sucursal, nb_sucursal, cod_ciudad) VALUES ('SUC01', 'Sucursal Caracas', 'CCS');
INSERT INTO SUCURSAL (cod_sucursal, nb_sucursal, cod_ciudad) VALUES ('SUC02', 'Sucursal Zulia', 'MAR');
INSERT INTO SUCURSAL (cod_sucursal, nb_sucursal, cod_ciudad) VALUES ('SUC03', 'Sucursal Carabobo', 'VAL');

-- 4. TIPO_PRODUCTO
INSERT INTO TIPO_PRODUCTO (cod_tipo_producto, nb_tipo_producto) VALUES ('TP01', 'Personales');
INSERT INTO TIPO_PRODUCTO (cod_tipo_producto, nb_tipo_producto) VALUES ('TP02', 'Danos');
INSERT INTO TIPO_PRODUCTO (cod_tipo_producto, nb_tipo_producto) VALUES ('TP03', 'Patrimonial');

-- 5. PRODUCTO
INSERT INTO PRODUCTO (cod_producto, nb_producto, descripcion, cod_tipo_producto, calificacion) VALUES ('P01', 'Automovil', 'Seguro basico de vehiculos', 'TP02', 4);
INSERT INTO PRODUCTO (cod_producto, nb_producto, descripcion, cod_tipo_producto, calificacion) VALUES ('P02', 'Salud', 'Cobertura medica amplia', 'TP01', 5);
INSERT INTO PRODUCTO (cod_producto, nb_producto, descripcion, cod_tipo_producto, calificacion) VALUES ('P03', 'Incendios', 'Proteccion contra incendios a locales', 'TP03', 3);
INSERT INTO PRODUCTO (cod_producto, nb_producto, descripcion, cod_tipo_producto, calificacion) VALUES ('P04', 'Vida', 'Poliza de vida a termino', 'TP01', 4);

-- 6. CLIENTE
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C001', 'Fidela Plaza Rios', 'V-8123818', '0416-5198985', 'Av. Francisco de Miranda, Caracas', 'F', 'pilarmartorell@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C002', 'Cornelio Julián', 'V-27321673', '0412-5165903', 'Calle 72, Maracaibo', 'M', 'ferrancamila@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C003', 'Porfirio Sales Sotelo', 'V-6977997', '0424-7081357', 'Av. Las Delicias, Maracay', 'F', 'rosario47@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C004', 'Priscila Criado Cerezo', 'V-8050769', '0412-1720780', 'Urb. El Trigal, Valencia', 'F', 'almudenamenendez@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C005', 'Ciro Rincón Gutiérrez', 'V-23573705', '0412-7934467', 'Av. Las Delicias, Maracay', 'M', 'eaguilar@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C006', 'María Dolores Gargallo Ferrer', 'V-22238121', '0424-9555415', 'Calle 72, Maracaibo', 'F', 'solanamelania@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C007', 'Armida Ródenas Madrigal', 'V-24468713', '0412-6710053', 'Calle 72, Maracaibo', 'M', 'miroruben@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C008', 'Lucho Valera Plaza', 'V-6899395', '0426-2427558', 'Calle 72, Maracaibo', 'M', 'ledesmaroque@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C009', 'Guiomar Otero Ferrández', 'V-28682738', '0414-2048970', 'Av. Francisco de Miranda, Caracas', 'M', 'florentinaferrando@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C010', 'Modesto del Blasco', 'V-30321671', '0424-9010856', 'Av. Las Delicias, Maracay', 'M', 'veronicaroura@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C011', 'Ángeles Montalbán', 'V-23982504', '0414-9237191', 'Av. Bolivar, Caracas', 'F', 'vilacarmela@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C012', 'Hernando Páez Álvarez', 'V-17701355', '0424-8815862', 'Av. Bolivar, Caracas', 'F', 'drevilla@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C013', 'Valerio Baeza Montesinos', 'V-14682322', '0426-3758753', 'Av. Bolivar, Caracas', 'M', 'elviraaragon@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C014', 'Cebrián del Aguirre', 'V-18469265', '0414-8897151', 'Av. Bolivar, Caracas', 'M', 'nbarcelo@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C015', 'Elisabet Moliner Sanabria', 'V-28821825', '0212-8580591', 'Av. Las Delicias, Maracay', 'F', 'arinopriscila@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C016', 'Candelaria de Sierra', 'V-16648224', '0212-1845196', 'Av. Francisco de Miranda, Caracas', 'M', 'peralmanolo@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C017', 'Azahara Esteban Mateo', 'V-16409185', '0412-6323949', 'Calle 72, Maracaibo', 'M', 'mpuig@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C018', 'Albano Luz Botella', 'V-11881854', '0426-4089877', 'Calle 72, Maracaibo', 'M', 'giraltfelipa@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C019', 'Javiera Berrocal', 'V-19660957', '0414-8696384', 'Urb. El Trigal, Valencia', 'M', 'reynaldo01@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C020', 'Luís Roldán', 'V-5184075', '0426-6412027', 'Calle 72, Maracaibo', 'F', 'damianmate@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C021', 'Carmelo Iriarte', 'V-30679107', '0414-9930649', 'Urb. El Trigal, Valencia', 'M', 'omerino@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C022', 'Antonia Adán Villa', 'V-13717031', '0212-1055027', 'Av. Francisco de Miranda, Caracas', 'M', 'isevillano@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C023', 'Elena Anita Iriarte Pagès', 'V-6660550', '0426-6940902', 'Av. Las Delicias, Maracay', 'F', 'andresnicanor@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C024', 'Nazaret Méndez Soler', 'V-7520378', '0212-1615642', 'Av. Bolivar, Caracas', 'F', 'gallardotrinidad@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C025', 'Lino Céspedes Egea', 'V-17943846', '0426-2083033', 'Av. Las Delicias, Maracay', 'M', 'ualiaga@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C026', 'Lino Eduardo Torre Bernal', 'V-27999591', '0416-7070744', 'Av. Lara, Barquisimeto', 'M', 'boadanayara@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C027', 'Edgardo Conesa Sebastián', 'V-6961923', '0416-3167766', 'Av. Francisco de Miranda, Caracas', 'F', 'leonciomontes@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C028', 'Ana Belén Cabrera Gaya', 'V-18211046', '0426-5914807', 'Av. Las Delicias, Maracay', 'M', 'herranzmaria-jose@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C029', 'Cintia Lupe Tudela Báez', 'V-9733898', '0212-2714499', 'Av. Lara, Barquisimeto', 'F', 'roberto63@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C030', 'Evita Bello Sarabia', 'V-10091767', '0416-1157082', 'Calle 72, Maracaibo', 'F', 'lbecerra@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C031', 'Laura del Tejero', 'V-25428292', '0414-2757648', 'Av. Francisco de Miranda, Caracas', 'M', 'kfigueras@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C032', 'Rocío Cepeda', 'V-20947369', '0424-6393150', 'Av. Las Delicias, Maracay', 'M', 'edmundo09@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C033', 'Florina Real Alvarez', 'V-30225216', '0412-6883948', 'Urb. El Trigal, Valencia', 'M', 'placido32@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C034', 'Casandra Garmendia', 'V-24897392', '0424-4426546', 'Av. Lara, Barquisimeto', 'F', 'ana-sofia02@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C035', 'Albert Durán Jara', 'V-25540520', '0426-1395983', 'Av. Lara, Barquisimeto', 'F', 'camachoamada@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C036', 'Octavio Pont', 'V-24540427', '0212-7106781', 'Av. Francisco de Miranda, Caracas', 'M', 'ana-belen81@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C037', 'Rafael Cobo Pablo', 'V-19522802', '0212-9365532', 'Av. Francisco de Miranda, Caracas', 'F', 'pioquerol@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C038', 'Berta Llabrés Checa', 'V-13770984', '0412-9616500', 'Av. Francisco de Miranda, Caracas', 'M', 'quintanajuanita@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C039', 'Casandra Manola Doménech Ortuño', 'V-28575509', '0414-4655917', 'Av. Francisco de Miranda, Caracas', 'F', 'edelmirobermudez@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C040', 'Baldomero Correa Palma', 'V-24860351', '0412-3265549', 'Av. Lara, Barquisimeto', 'M', 'ocasal@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C041', 'Luis Ángel de Bautista', 'V-23079332', '0212-6701040', 'Av. Las Delicias, Maracay', 'F', 'pcal@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C042', 'Yolanda Vilalta Cerezo', 'V-13410027', '0424-9244459', 'Av. Bolivar, Caracas', 'F', 'ana92@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C043', 'Laura de Tur', 'V-26647071', '0212-6955000', 'Av. Las Delicias, Maracay', 'F', 'bibianagalvan@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C044', 'Estela Calleja Carreras', 'V-18060896', '0412-7964756', 'Av. Lara, Barquisimeto', 'F', 'mcoca@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C045', 'Roque Sala Mora', 'V-14359632', '0412-4849924', 'Calle 72, Maracaibo', 'M', 'inigo20@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C046', 'Josefa Rincón Robles', 'V-6836282', '0414-6477420', 'Av. Las Delicias, Maracay', 'M', 'morenoalfonso@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C047', 'Gema Gutierrez Alberola', 'V-12025881', '0412-2633640', 'Calle 72, Maracaibo', 'M', 'osunahernando@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C048', 'Dulce Borrego', 'V-20978825', '0414-9450429', 'Av. Francisco de Miranda, Caracas', 'F', 'vilarpepita@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C049', 'Juan Pablo Mascaró-Blanca', 'V-29006056', '0412-5701099', 'Av. Bolivar, Caracas', 'M', 'bonetjose-angel@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C050', 'Mateo del Vendrell', 'V-21936604', '0426-5825957', 'Av. Lara, Barquisimeto', 'F', 'salascarmela@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C051', 'Eloísa Mancebo Merino', 'V-14871504', '0414-3348572', 'Av. Bolivar, Caracas', 'M', 'raquel05@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C052', 'Miriam Carro-Sosa', 'V-17919785', '0426-7349899', 'Av. Bolivar, Caracas', 'F', 'ciriacoanglada@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C053', 'Toño Marcos Sierra', 'V-14357770', '0212-5100955', 'Av. Bolivar, Caracas', 'M', 'antonia64@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C054', 'Rafael Marino Vélez Bernad', 'V-20273817', '0412-1850646', 'Av. Francisco de Miranda, Caracas', 'M', 'ileanajordan@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C055', 'Candelas Lasa-Tamayo', 'V-22750389', '0416-2244782', 'Calle 72, Maracaibo', 'F', 'irispacheco@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C056', 'Noa Albero-Pol', 'V-10866209', '0424-4301243', 'Calle 72, Maracaibo', 'F', 'sacristancandela@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C057', 'Cruz Franch Torrens', 'V-11685563', '0412-3047797', 'Av. Lara, Barquisimeto', 'M', 'rodolfo31@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C058', 'Felicia Cuervo Franco', 'V-16508495', '0414-3764027', 'Av. Bolivar, Caracas', 'F', 'anastasia07@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C059', 'Visitación Serna', 'V-12634275', '0426-3335943', 'Urb. El Trigal, Valencia', 'F', 'hernando87@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C060', 'Alondra del Carranza', 'V-10039743', '0212-1049295', 'Av. Bolivar, Caracas', 'M', 'secoflor@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C061', 'Laura del Cámara', 'V-19602920', '0424-5627089', 'Calle 72, Maracaibo', 'M', 'asomoza@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C062', 'Crescencia Palma Crespi', 'V-10448986', '0412-4680966', 'Av. Lara, Barquisimeto', 'M', 'florencio21@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C063', 'Tamara Iniesta-Bermúdez', 'V-12448493', '0412-3687733', 'Av. Francisco de Miranda, Caracas', 'M', 'sbarriga@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C064', 'Filomena Iglesia Robledo', 'V-11173779', '0426-5279365', 'Av. Bolivar, Caracas', 'M', 'iramirez@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C065', 'María Luisa Santamaría Rosado', 'V-15286480', '0414-6878046', 'Av. Francisco de Miranda, Caracas', 'M', 'bruno28@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C066', 'Melisa Sotelo Castillo', 'V-27824643', '0424-1303054', 'Av. Francisco de Miranda, Caracas', 'F', 'tecla18@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C067', 'Alcides Parejo Jiménez', 'V-25211661', '0412-9196917', 'Av. Las Delicias, Maracay', 'M', 'gervasio58@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C068', 'Segismundo Ribas Calvo', 'V-14795136', '0426-1507347', 'Av. Las Delicias, Maracay', 'F', 'irenegiralt@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C069', 'Nacho Álamo-Mancebo', 'V-15343142', '0412-8789102', 'Calle 72, Maracaibo', 'M', 'arcelia17@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C070', 'Isidoro Talavera Herranz', 'V-27291965', '0416-6261427', 'Calle 72, Maracaibo', 'M', 'godofredogonzalez@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C071', 'Gregorio Palacios Gargallo', 'V-23629364', '0416-1214023', 'Urb. El Trigal, Valencia', 'M', 'jonatanpons@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C072', 'Carolina Álvaro Anguita', 'V-27851376', '0426-5680040', 'Calle 72, Maracaibo', 'F', 'dbarbera@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C073', 'Narciso Tejedor Abellán', 'V-5961962', '0426-9471924', 'Urb. El Trigal, Valencia', 'M', 'carrascobienvenida@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C074', 'Haydée Lupita Escamilla Viña', 'V-18042110', '0212-2711457', 'Av. Bolivar, Caracas', 'F', 'guijarroselena@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C075', 'Sonia Bellido', 'V-10433740', '0414-6646002', 'Av. Lara, Barquisimeto', 'M', 'esteveznatalio@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C076', 'Patricio Alcaraz Rincón', 'V-9466691', '0416-2445693', 'Av. Las Delicias, Maracay', 'F', 'baldomerovilalta@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C077', 'Eva del Solé', 'V-18182595', '0424-4521241', 'Av. Lara, Barquisimeto', 'M', 'bayoncelestino@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C078', 'Evelia Narváez Rivas', 'V-12190641', '0416-9632538', 'Av. Bolivar, Caracas', 'F', 'norberto38@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C079', 'Yago de Frutos', 'V-25150332', '0212-2817283', 'Av. Lara, Barquisimeto', 'M', 'jgaya@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C080', 'Odalis Rivero Cerdá', 'V-10098526', '0412-7267916', 'Av. Francisco de Miranda, Caracas', 'F', 'atienzajordi@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C081', 'Nydia Ramis', 'V-5765230', '0416-3320610', 'Av. Lara, Barquisimeto', 'M', 'asuncion46@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C082', 'Belén Machado Goñi', 'V-8097844', '0426-7399073', 'Av. Francisco de Miranda, Caracas', 'M', 'atilio17@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C083', 'Domitila Larrea Vendrell', 'V-16333974', '0414-6040713', 'Calle 72, Maracaibo', 'M', 'estebanazahara@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C084', 'Teobaldo de Aranda', 'V-9315993', '0412-8740336', 'Av. Lara, Barquisimeto', 'F', 'celiaquintana@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C085', 'Heraclio Aller Ureña', 'V-25920116', '0414-3445205', 'Urb. El Trigal, Valencia', 'M', 'eroig@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C086', 'Consuela Murillo Campos', 'V-28937554', '0416-7979129', 'Urb. El Trigal, Valencia', 'F', 'teresita52@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C087', 'Eloísa Mir Barral', 'V-30242351', '0212-1062767', 'Calle 72, Maracaibo', 'M', 'lescalona@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C088', 'Estrella Chacón Arévalo', 'V-20842558', '0424-5449480', 'Av. Francisco de Miranda, Caracas', 'F', 'maria-pilarvendrell@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C089', 'Basilio Luz', 'V-9652281', '0412-9606474', 'Calle 72, Maracaibo', 'M', 'jenaro41@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C090', 'Carlito Morante Zamora', 'V-10379352', '0414-5692146', 'Av. Francisco de Miranda, Caracas', 'M', 'alearmengol@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C091', 'Tania Jara Godoy', 'V-5569646', '0416-7597336', 'Av. Las Delicias, Maracay', 'F', 'segismundo11@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C092', 'Eliana Maldonado Salinas', 'V-10756014', '0426-7258109', 'Av. Lara, Barquisimeto', 'F', 'ollerflavia@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C093', 'Faustino Cabanillas Alvarez', 'V-10783627', '0426-9527820', 'Av. Bolivar, Caracas', 'M', 'maritaesparza@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C094', 'Natalio del Azcona', 'V-28118142', '0424-1630555', 'Av. Bolivar, Caracas', 'F', 'calixtoramos@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C095', 'Cruz Marquez', 'V-9880942', '0426-5219080', 'Av. Francisco de Miranda, Caracas', 'M', 'lladosusanita@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C096', 'Maite Puga Isern', 'V-27088306', '0414-8002715', 'Av. Lara, Barquisimeto', 'F', 'guadalupesuarez@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C097', 'Manuela Francisco', 'V-13508811', '0426-2212967', 'Urb. El Trigal, Valencia', 'F', 'maria-luisa60@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C098', 'Zoraida Asensio Cerdá', 'V-22942673', '0414-5856495', 'Calle 72, Maracaibo', 'F', 'olimpiaballester@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C099', 'Telmo Herranz Escalona', 'V-17993369', '0426-2466694', 'Av. Bolivar, Caracas', 'M', 'gtolosa@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C100', 'Delfina de Colomer', 'V-9917217', '0414-2993786', 'Av. Francisco de Miranda, Caracas', 'F', 'elisabet14@example.org', 'SUC01');

-- 7. EVALUACION_SERVICIO
INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('E1', 'Malo');
INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('E2', 'Regular');
INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('E3', 'Bueno');
INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('E4', 'Muy Bueno');
INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('E5', 'Excelente');

-- 8. RECOMIENDA
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C009', 'E1', 'P03', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C061', 'E4', 'P02', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C064', 'E4', 'P02', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C090', 'E4', 'P02', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C065', 'E1', 'P01', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C074', 'E3', 'P03', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C071', 'E1', 'P03', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C081', 'E2', 'P01', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C018', 'E3', 'P04', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C099', 'E3', 'P04', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C017', 'E1', 'P01', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C084', 'E2', 'P02', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C078', 'E5', 'P02', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C076', 'E4', 'P01', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C087', 'E5', 'P01', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C075', 'E1', 'P03', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C024', 'E4', 'P02', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C086', 'E2', 'P01', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C029', 'E4', 'P04', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C060', 'E5', 'P01', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C033', 'E1', 'P01', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C042', 'E3', 'P03', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C041', 'E4', 'P02', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C049', 'E1', 'P01', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C039', 'E1', 'P01', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C070', 'E3', 'P04', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C058', 'E1', 'P04', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C027', 'E5', 'P03', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C047', 'E1', 'P02', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C016', 'E2', 'P04', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C097', 'E2', 'P04', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C092', 'E3', 'P04', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C062', 'E1', 'P02', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C034', 'E5', 'P01', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C068', 'E3', 'P01', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C043', 'E3', 'P01', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C091', 'E5', 'P04', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C059', 'E2', 'P02', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C006', 'E2', 'P04', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C055', 'E3', 'P02', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C021', 'E2', 'P03', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C001', 'E3', 'P03', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C053', 'E4', 'P03', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C095', 'E3', 'P02', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C073', 'E2', 'P01', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C072', 'E3', 'P02', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C032', 'E1', 'P02', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C026', 'E1', 'P04', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C083', 'E3', 'P01', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C012', 'E2', 'P04', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C085', 'E1', 'P02', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C013', 'E1', 'P04', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C048', 'E5', 'P01', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C098', 'E2', 'P01', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C088', 'E1', 'P01', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C100', 'E3', 'P04', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C082', 'E5', 'P01', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C022', 'E5', 'P02', 'SI');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C093', 'E2', 'P03', 'NO');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo) VALUES ('C054', 'E4', 'P02', 'SI');

-- 9. CONTRATO
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0001', 'Contrato de poliza 1 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0002', 'Contrato de poliza 2 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0003', 'Contrato de poliza 3 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0004', 'Contrato de poliza 4 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0005', 'Contrato de poliza 5 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0006', 'Contrato de poliza 6 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0007', 'Contrato de poliza 7 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0008', 'Contrato de poliza 8 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0009', 'Contrato de poliza 9 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0010', 'Contrato de poliza 10 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0011', 'Contrato de poliza 11 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0012', 'Contrato de poliza 12 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0013', 'Contrato de poliza 13 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0014', 'Contrato de poliza 14 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0015', 'Contrato de poliza 15 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0016', 'Contrato de poliza 16 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0017', 'Contrato de poliza 17 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0018', 'Contrato de poliza 18 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0019', 'Contrato de poliza 19 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0020', 'Contrato de poliza 20 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0021', 'Contrato de poliza 21 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0022', 'Contrato de poliza 22 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0023', 'Contrato de poliza 23 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0024', 'Contrato de poliza 24 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0025', 'Contrato de poliza 25 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0026', 'Contrato de poliza 26 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0027', 'Contrato de poliza 27 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0028', 'Contrato de poliza 28 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0029', 'Contrato de poliza 29 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0030', 'Contrato de poliza 30 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0031', 'Contrato de poliza 31 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0032', 'Contrato de poliza 32 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0033', 'Contrato de poliza 33 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0034', 'Contrato de poliza 34 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0035', 'Contrato de poliza 35 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0036', 'Contrato de poliza 36 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0037', 'Contrato de poliza 37 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0038', 'Contrato de poliza 38 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0039', 'Contrato de poliza 39 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0040', 'Contrato de poliza 40 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0041', 'Contrato de poliza 41 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0042', 'Contrato de poliza 42 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0043', 'Contrato de poliza 43 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0044', 'Contrato de poliza 44 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0045', 'Contrato de poliza 45 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0046', 'Contrato de poliza 46 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0047', 'Contrato de poliza 47 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0048', 'Contrato de poliza 48 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0049', 'Contrato de poliza 49 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0050', 'Contrato de poliza 50 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0051', 'Contrato de poliza 51 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0052', 'Contrato de poliza 52 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0053', 'Contrato de poliza 53 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0054', 'Contrato de poliza 54 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0055', 'Contrato de poliza 55 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0056', 'Contrato de poliza 56 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0057', 'Contrato de poliza 57 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0058', 'Contrato de poliza 58 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0059', 'Contrato de poliza 59 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0060', 'Contrato de poliza 60 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0061', 'Contrato de poliza 61 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0062', 'Contrato de poliza 62 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0063', 'Contrato de poliza 63 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0064', 'Contrato de poliza 64 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0065', 'Contrato de poliza 65 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0066', 'Contrato de poliza 66 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0067', 'Contrato de poliza 67 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0068', 'Contrato de poliza 68 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0069', 'Contrato de poliza 69 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0070', 'Contrato de poliza 70 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0071', 'Contrato de poliza 71 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0072', 'Contrato de poliza 72 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0073', 'Contrato de poliza 73 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0074', 'Contrato de poliza 74 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0075', 'Contrato de poliza 75 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0076', 'Contrato de poliza 76 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0077', 'Contrato de poliza 77 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0078', 'Contrato de poliza 78 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0079', 'Contrato de poliza 79 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0080', 'Contrato de poliza 80 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0081', 'Contrato de poliza 81 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0082', 'Contrato de poliza 82 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0083', 'Contrato de poliza 83 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0084', 'Contrato de poliza 84 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0085', 'Contrato de poliza 85 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0086', 'Contrato de poliza 86 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0087', 'Contrato de poliza 87 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0088', 'Contrato de poliza 88 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0089', 'Contrato de poliza 89 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0090', 'Contrato de poliza 90 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0091', 'Contrato de poliza 91 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0092', 'Contrato de poliza 92 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0093', 'Contrato de poliza 93 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0094', 'Contrato de poliza 94 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0095', 'Contrato de poliza 95 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0096', 'Contrato de poliza 96 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0097', 'Contrato de poliza 97 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0098', 'Contrato de poliza 98 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0099', 'Contrato de poliza 99 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0100', 'Contrato de poliza 100 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0101', 'Contrato de poliza 101 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0102', 'Contrato de poliza 102 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0103', 'Contrato de poliza 103 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0104', 'Contrato de poliza 104 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0105', 'Contrato de poliza 105 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0106', 'Contrato de poliza 106 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0107', 'Contrato de poliza 107 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0108', 'Contrato de poliza 108 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0109', 'Contrato de poliza 109 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0110', 'Contrato de poliza 110 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0111', 'Contrato de poliza 111 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0112', 'Contrato de poliza 112 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0113', 'Contrato de poliza 113 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0114', 'Contrato de poliza 114 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0115', 'Contrato de poliza 115 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0116', 'Contrato de poliza 116 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0117', 'Contrato de poliza 117 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0118', 'Contrato de poliza 118 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0119', 'Contrato de poliza 119 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0120', 'Contrato de poliza 120 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0121', 'Contrato de poliza 121 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0122', 'Contrato de poliza 122 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0123', 'Contrato de poliza 123 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0124', 'Contrato de poliza 124 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0125', 'Contrato de poliza 125 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0126', 'Contrato de poliza 126 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0127', 'Contrato de poliza 127 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0128', 'Contrato de poliza 128 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0129', 'Contrato de poliza 129 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0130', 'Contrato de poliza 130 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0131', 'Contrato de poliza 131 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0132', 'Contrato de poliza 132 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0133', 'Contrato de poliza 133 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0134', 'Contrato de poliza 134 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0135', 'Contrato de poliza 135 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0136', 'Contrato de poliza 136 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0137', 'Contrato de poliza 137 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0138', 'Contrato de poliza 138 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0139', 'Contrato de poliza 139 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0140', 'Contrato de poliza 140 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0141', 'Contrato de poliza 141 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0142', 'Contrato de poliza 142 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0143', 'Contrato de poliza 143 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0144', 'Contrato de poliza 144 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0145', 'Contrato de poliza 145 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0146', 'Contrato de poliza 146 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0147', 'Contrato de poliza 147 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0148', 'Contrato de poliza 148 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0149', 'Contrato de poliza 149 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0150', 'Contrato de poliza 150 para asegurado');

-- 10. REGISTRO_CONTRATO
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0001', 'P04', 'C039', '2024-12-01', '2025-12-01', 411.47, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0002', 'P03', 'C071', '2025-03-10', '2026-03-10', 2087.56, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0003', 'P01', 'C005', '2024-05-14', '2025-05-14', 579.02, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0004', 'P02', 'C005', '2025-06-30', '2026-06-30', 1553.8, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0005', 'P02', 'C079', '2024-02-29', '2025-02-28', 1716.5, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0006', 'P04', 'C071', '2023-10-12', '2024-10-11', 214.27, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0007', 'P02', 'C060', '2023-12-09', '2024-12-08', 1460.84, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0008', 'P01', 'C071', '2023-07-06', '2024-07-05', 2323.12, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0009', 'P04', 'C051', '2024-10-31', '2025-10-31', 909.13, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0010', 'P01', 'C060', '2024-08-01', '2025-08-01', 846.44, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0011', 'P04', 'C010', '2026-07-04', '2027-07-04', 2406.85, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0012', 'P04', 'C091', '2026-07-05', '2027-07-05', 228.8, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0013', 'P03', 'C004', '2024-05-18', '2025-05-18', 1188.88, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0014', 'P03', 'C001', '2025-02-16', '2026-02-16', 874.72, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0015', 'P03', 'C073', '2026-06-15', '2027-06-15', 2252.84, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0016', 'P03', 'C051', '2025-03-06', '2026-03-06', 395.96, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0017', 'P03', 'C062', '2025-01-03', '2026-01-03', 166.18, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0018', 'P02', 'C088', '2023-09-02', '2024-09-01', 709.24, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0019', 'P03', 'C026', '2025-09-09', '2026-09-09', 600.17, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0020', 'P01', 'C065', '2025-07-18', '2026-07-18', 1980.78, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0021', 'P04', 'C086', '2025-07-09', '2026-07-09', 1524.96, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0022', 'P02', 'C028', '2025-05-16', '2026-05-16', 932.99, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0023', 'P03', 'C031', '2024-10-28', '2025-10-28', 1258.03, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0024', 'P01', 'C062', '2024-09-18', '2025-09-18', 183.88, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0025', 'P03', 'C079', '2025-10-10', '2026-10-10', 2122.67, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0026', 'P04', 'C011', '2024-06-07', '2025-06-07', 2338.28, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0027', 'P03', 'C003', '2024-03-06', '2025-03-06', 318.49, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0028', 'P04', 'C033', '2023-12-07', '2024-12-06', 2444.04, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0029', 'P02', 'C011', '2024-05-23', '2025-05-23', 1651.85, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0030', 'P02', 'C069', '2024-11-15', '2025-11-15', 838.31, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0031', 'P04', 'C078', '2024-11-01', '2025-11-01', 2095.47, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0032', 'P04', 'C089', '2024-02-09', '2025-02-08', 2440.1, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0033', 'P01', 'C013', '2024-11-06', '2025-11-06', 2363.17, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0034', 'P01', 'C085', '2025-10-30', '2026-10-30', 2080.77, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0035', 'P02', 'C023', '2024-03-22', '2025-03-22', 1633.87, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0036', 'P01', 'C021', '2023-11-30', '2024-11-29', 1900.38, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0037', 'P03', 'C093', '2023-11-25', '2024-11-24', 1255.0, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0038', 'P03', 'C029', '2025-12-30', '2026-12-30', 2091.64, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0039', 'P02', 'C095', '2025-07-16', '2026-07-16', 2324.29, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0040', 'P01', 'C006', '2024-03-30', '2025-03-30', 2471.96, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0041', 'P04', 'C010', '2023-11-02', '2024-11-01', 1035.56, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0042', 'P03', 'C039', '2024-10-09', '2025-10-09', 1041.81, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0043', 'P01', 'C079', '2024-06-23', '2025-06-23', 1516.12, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0044', 'P01', 'C001', '2025-12-27', '2026-12-27', 898.48, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0045', 'P02', 'C042', '2024-06-30', '2025-06-30', 2196.31, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0046', 'P01', 'C066', '2024-01-15', '2025-01-14', 153.29, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0047', 'P02', 'C005', '2026-03-17', '2027-03-17', 2246.19, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0048', 'P02', 'C066', '2023-11-09', '2024-11-08', 861.1, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0049', 'P04', 'C021', '2025-11-25', '2026-11-25', 2306.4, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0050', 'P03', 'C020', '2024-08-18', '2025-08-18', 1976.83, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0051', 'P02', 'C089', '2025-06-04', '2026-06-04', 1864.71, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0052', 'P03', 'C005', '2025-04-30', '2026-04-30', 2222.81, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0053', 'P04', 'C020', '2024-10-09', '2025-10-09', 1323.22, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0054', 'P01', 'C015', '2023-08-31', '2024-08-30', 1091.71, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0055', 'P01', 'C088', '2025-08-07', '2026-08-07', 1254.54, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0056', 'P03', 'C059', '2024-01-31', '2025-01-30', 1410.64, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0057', 'P03', 'C092', '2025-03-31', '2026-03-31', 1695.9, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0058', 'P03', 'C066', '2024-12-20', '2025-12-20', 573.35, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0059', 'P01', 'C086', '2023-08-25', '2024-08-24', 2074.62, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0060', 'P04', 'C017', '2026-03-17', '2027-03-17', 714.54, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0061', 'P04', 'C094', '2025-07-07', '2026-07-07', 375.15, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0062', 'P01', 'C085', '2025-05-27', '2026-05-27', 1424.11, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0063', 'P02', 'C014', '2025-06-22', '2026-06-22', 178.99, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0064', 'P03', 'C008', '2025-02-22', '2026-02-22', 2139.93, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0065', 'P03', 'C003', '2026-05-21', '2027-05-21', 1262.09, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0066', 'P01', 'C087', '2025-03-09', '2026-03-09', 223.57, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0067', 'P04', 'C055', '2025-01-10', '2026-01-10', 479.41, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0068', 'P03', 'C029', '2023-08-06', '2024-08-05', 262.32, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0069', 'P02', 'C047', '2025-10-24', '2026-10-24', 1213.16, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0070', 'P02', 'C083', '2024-10-15', '2025-10-15', 1261.11, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0071', 'P01', 'C057', '2026-04-04', '2027-04-04', 2142.25, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0072', 'P01', 'C061', '2024-05-06', '2025-05-06', 1800.36, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0073', 'P03', 'C016', '2025-02-11', '2026-02-11', 1834.07, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0074', 'P03', 'C035', '2025-03-14', '2026-03-14', 2235.98, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0075', 'P03', 'C080', '2023-10-11', '2024-10-10', 1938.76, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0076', 'P01', 'C080', '2026-02-02', '2027-02-02', 1727.88, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0077', 'P02', 'C032', '2025-10-16', '2026-10-16', 2150.9, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0078', 'P03', 'C045', '2023-11-08', '2024-11-07', 405.78, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0079', 'P04', 'C010', '2023-10-17', '2024-10-16', 356.27, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0080', 'P03', 'C012', '2025-06-22', '2026-06-22', 2208.35, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0081', 'P04', 'C020', '2025-12-30', '2026-12-30', 299.86, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0082', 'P01', 'C071', '2024-06-21', '2025-06-21', 1181.19, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0083', 'P02', 'C002', '2024-11-08', '2025-11-08', 2448.51, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0084', 'P04', 'C013', '2023-07-10', '2024-07-09', 1946.9, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0085', 'P03', 'C009', '2023-07-16', '2024-07-15', 2354.31, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0086', 'P04', 'C100', '2024-04-05', '2025-04-05', 856.42, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0087', 'P03', 'C048', '2023-09-13', '2024-09-12', 1828.28, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0088', 'P01', 'C086', '2026-06-16', '2027-06-16', 2264.6, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0089', 'P04', 'C055', '2025-04-17', '2026-04-17', 2279.46, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0090', 'P03', 'C004', '2024-02-15', '2025-02-14', 965.04, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0091', 'P03', 'C082', '2024-06-22', '2025-06-22', 358.93, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0092', 'P01', 'C049', '2025-11-04', '2026-11-04', 1155.59, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0093', 'P04', 'C072', '2024-04-26', '2025-04-26', 1372.24, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0094', 'P04', 'C082', '2025-02-09', '2026-02-09', 896.27, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0095', 'P01', 'C013', '2026-01-02', '2027-01-02', 1067.4, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0096', 'P04', 'C028', '2024-09-08', '2025-09-08', 254.93, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0097', 'P04', 'C088', '2025-09-24', '2026-09-24', 1811.35, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0098', 'P02', 'C040', '2025-06-14', '2026-06-14', 1578.99, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0099', 'P01', 'C065', '2025-07-05', '2026-07-05', 1067.66, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0100', 'P01', 'C071', '2025-01-21', '2026-01-21', 728.64, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0101', 'P03', 'C054', '2025-11-01', '2026-11-01', 1087.67, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0102', 'P03', 'C050', '2024-02-04', '2025-02-03', 855.92, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0103', 'P01', 'C032', '2024-09-12', '2025-09-12', 2400.61, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0104', 'P01', 'C036', '2025-01-05', '2026-01-05', 858.65, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0105', 'P01', 'C020', '2024-04-29', '2025-04-29', 2047.34, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0106', 'P02', 'C026', '2025-10-11', '2026-10-11', 1577.0, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0107', 'P04', 'C044', '2024-08-29', '2025-08-29', 746.99, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0108', 'P01', 'C081', '2026-01-27', '2027-01-27', 711.42, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0109', 'P04', 'C041', '2024-09-29', '2025-09-29', 2334.38, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0110', 'P03', 'C018', '2026-01-25', '2027-01-25', 1911.01, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0111', 'P01', 'C021', '2024-07-11', '2025-07-11', 1568.59, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0112', 'P01', 'C063', '2023-11-26', '2024-11-25', 250.66, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0113', 'P01', 'C081', '2024-06-26', '2025-06-26', 358.38, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0114', 'P03', 'C083', '2025-09-06', '2026-09-06', 1440.24, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0115', 'P03', 'C099', '2025-01-20', '2026-01-20', 446.16, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0116', 'P02', 'C019', '2024-05-17', '2025-05-17', 395.77, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0117', 'P02', 'C060', '2023-07-23', '2024-07-22', 822.3, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0118', 'P03', 'C067', '2023-08-28', '2024-08-27', 891.52, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0119', 'P04', 'C030', '2026-02-03', '2027-02-03', 1704.82, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0120', 'P01', 'C032', '2024-02-29', '2025-02-28', 1325.92, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0121', 'P03', 'C064', '2025-09-19', '2026-09-19', 2035.77, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0122', 'P04', 'C021', '2024-10-30', '2025-10-30', 342.14, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0123', 'P04', 'C008', '2024-05-16', '2025-05-16', 1415.71, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0124', 'P01', 'C042', '2025-07-29', '2026-07-29', 545.37, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0125', 'P03', 'C028', '2024-08-14', '2025-08-14', 434.15, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0126', 'P03', 'C015', '2025-12-21', '2026-12-21', 899.99, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0127', 'P01', 'C021', '2024-07-22', '2025-07-22', 160.11, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0128', 'P03', 'C072', '2024-03-05', '2025-03-05', 500.23, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0129', 'P03', 'C081', '2025-05-13', '2026-05-13', 1967.1, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0130', 'P01', 'C077', '2025-04-04', '2026-04-04', 1770.3, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0131', 'P04', 'C045', '2025-04-11', '2026-04-11', 2478.44, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0132', 'P02', 'C077', '2024-08-07', '2025-08-07', 608.45, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0133', 'P04', 'C075', '2024-02-05', '2025-02-04', 986.86, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0134', 'P02', 'C070', '2026-04-30', '2027-04-30', 2240.06, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0135', 'P03', 'C025', '2026-03-05', '2027-03-05', 1158.46, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0136', 'P03', 'C046', '2025-06-12', '2026-06-12', 1474.96, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0137', 'P03', 'C091', '2024-05-05', '2025-05-05', 641.8, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0138', 'P01', 'C002', '2025-02-07', '2026-02-07', 1197.59, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0139', 'P02', 'C059', '2024-10-10', '2025-10-10', 2185.75, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0140', 'P03', 'C042', '2025-12-06', '2026-12-06', 2286.25, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0141', 'P01', 'C036', '2025-05-05', '2026-05-05', 360.07, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0142', 'P03', 'C089', '2025-04-30', '2026-04-30', 2353.16, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0143', 'P01', 'C050', '2025-02-06', '2026-02-06', 174.52, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0144', 'P04', 'C008', '2024-01-24', '2025-01-23', 2139.42, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0145', 'P02', 'C011', '2023-10-05', '2024-10-04', 552.66, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0146', 'P02', 'C001', '2026-05-02', '2027-05-02', 2059.12, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0147', 'P02', 'C081', '2024-12-23', '2025-12-23', 1587.49, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0148', 'P04', 'C090', '2024-03-28', '2025-03-28', 2165.56, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0149', 'P01', 'C068', '2025-05-16', '2026-05-16', 1282.2, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0150', 'P02', 'C066', '2024-12-11', '2025-12-11', 1939.85, 'vencido');

-- 11. SINIESTRO
INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('SIN-01', 'Choque vehicular');
INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('SIN-02', 'Robo de vehiculo');
INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('SIN-03', 'Emergencia medica general');
INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('SIN-04', 'Incendio estructural leve');
INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('SIN-05', 'Dano por agua en vivienda');

-- 12. REGISTRO_SINIESTRO
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0015', '2026-06-28', '2026-07-14', 'SI', 0.0, 3791.65);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0129', '2025-10-31', '2025-11-24', 'NO', 3706.64, 3706.64);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0004', '2025-11-05', '2025-11-12', 'NO', 4455.39, 4455.39);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0074', '2025-06-19', '2025-06-28', 'NO', 4411.17, 4411.17);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0137', '2025-01-13', '2025-02-11', 'SI', 0.0, 315.97);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0099', '2026-01-03', '2026-02-01', 'NO', 3199.92, 3199.92);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0031', '2025-03-20', '2025-03-28', 'SI', 0.0, 4057.13);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0148', '2024-11-08', '2024-12-01', 'SI', 0.0, 4407.73);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0040', '2024-07-24', '2024-08-07', 'SI', 0.0, 1254.29);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0068', '2024-03-05', '2024-03-09', 'SI', 0.0, 3717.68);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0144', '2024-05-06', '2024-05-22', 'NO', 835.75, 835.75);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0025', '2025-11-02', '2025-11-22', 'SI', 0.0, 2015.79);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0011', '2026-12-23', '2026-12-28', 'NO', 4570.49, 4570.49);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0142', '2025-05-11', '2025-05-29', 'NO', 3249.1, 3249.1);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0145', '2024-05-08', '2024-05-26', 'NO', 3171.24, 3171.24);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0094', '2025-08-20', '2025-09-07', 'NO', 2135.21, 2135.21);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0029', '2024-07-04', '2024-07-07', 'SI', 0.0, 3935.39);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0147', '2025-07-28', '2025-08-26', 'SI', 0.0, 352.62);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0045', '2025-03-02', '2025-03-18', 'SI', 0.0, 4097.9);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0058', '2025-06-16', '2025-06-20', 'SI', 0.0, 2660.33);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0069', '2026-06-18', '2026-07-07', 'SI', 0.0, 3084.97);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0035', '2024-04-20', '2024-05-04', 'NO', 4429.17, 4429.17);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0108', '2026-04-23', '2026-04-28', 'NO', 539.81, 539.81);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0119', '2026-04-27', '2026-05-11', 'NO', 1479.83, 1479.83);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0027', '2024-10-20', '2024-10-31', 'SI', 0.0, 726.39);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0044', '2026-10-22', '2026-10-31', 'NO', 531.18, 531.18);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0073', '2025-09-14', '2025-10-05', 'SI', 0.0, 2241.67);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0066', '2025-10-10', '2025-10-14', 'NO', 1113.05, 1113.05);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0098', '2026-03-23', '2026-04-07', 'NO', 2105.14, 2105.14);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0115', '2025-03-08', '2025-04-01', 'SI', 0.0, 3505.08);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0002', '2025-09-23', '2025-10-11', 'SI', 0.0, 4165.89);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0133', '2024-08-22', '2024-09-02', 'NO', 3440.99, 3440.99);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0060', '2026-05-25', '2026-06-23', 'NO', 308.48, 308.48);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0081', '2026-10-04', '2026-10-07', 'NO', 487.21, 487.21);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0122', '2025-06-19', '2025-06-27', 'SI', 0.0, 3164.38);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0138', '2025-09-03', '2025-09-12', 'NO', 2578.92, 2578.92);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0078', '2024-07-24', '2024-08-15', 'SI', 0.0, 2446.45);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0042', '2025-05-27', '2025-06-01', 'NO', 4055.15, 4055.15);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0048', '2024-03-15', '2024-03-21', 'NO', 4273.75, 4273.75);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0020', '2026-03-09', '2026-04-02', 'SI', 0.0, 2043.24);


-- =========================================================================
-- FASE C: MODELO DIMENSIONAL (DATA WAREHOUSE)
-- =========================================================================
-- BUG 3 FIX: Se eliminó el CREATE SCHEMA duplicado sin IF NOT EXISTS que
-- causaba error si el esquema ya existía. Se conserva solo la versión segura.
CREATE SCHEMA IF NOT EXISTS "SEGURO_DW_G27797047";
SET search_path TO "SEGURO_DW_G27797047";

-- ==========================================
-- DIMENSIONES CONFORMADAS
-- ==========================================

-- DIM_TIEMPO
CREATE TABLE DIM_TIEMPO (
    SK_DIM_TIEMPO INTEGER PRIMARY KEY,
    COD_ANNIO INTEGER,
    COD_MES INTEGER,
    COD_DIA INTEGER,
    DESC_MES VARCHAR(50),
    DESC_TRIMESTRE VARCHAR(15),
    DESC_SEMESTRE VARCHAR(10),
    FECHA_COMPLETA DATE
);

-- DIM_CLIENTE
CREATE TABLE DIM_CLIENTE (
    SK_DIM_CLIENTE SERIAL PRIMARY KEY,
    COD_CLIENTE VARCHAR(10) UNIQUE NOT NULL, -- Clave Natural con restricción UNIQUE para Carga Incremental
    NB_CLIENTE VARCHAR(150),
    CI_RIF VARCHAR(20),
    TELEFONO VARCHAR(20),
    DIRECCION TEXT,
    SEXO CHAR(1),
    EMAIL VARCHAR(100)
);

-- DIM_PRODUCTO
CREATE TABLE DIM_PRODUCTO (
    SK_DIM_PRODUCTO SERIAL PRIMARY KEY,
    COD_PRODUCTO VARCHAR(10) UNIQUE NOT NULL, -- Clave Natural con restricción UNIQUE para Carga Incremental
    NB_PRODUCTO VARCHAR(100),
    DESCRIP_PRODUCTO TEXT,
    COD_TIPO_PRODUCTO VARCHAR(10),
    NB_TIPO_PRODUCTO VARCHAR(100),
    CALIFICACION INTEGER
);

-- DIM_CONTRATO
CREATE TABLE DIM_CONTRATO (
    SK_DIM_CONTRATO SERIAL PRIMARY KEY,
    NRO_CONTRATO VARCHAR(20) UNIQUE NOT NULL, -- Clave Natural con restricción UNIQUE para Carga Incremental
    DESCRIP_CONTRATO TEXT
);

-- DIM_SUCURSAL
CREATE TABLE DIM_SUCURSAL (
    SK_DIM_SUCURSAL SERIAL PRIMARY KEY,
    COD_SUCURSAL VARCHAR(10) UNIQUE NOT NULL, -- Clave Natural con restricción UNIQUE para Carga Incremental
    NB_SUCURSAL VARCHAR(100),
    COD_CIUDAD VARCHAR(10),
    NB_CIUDAD VARCHAR(100),
    COD_PAIS VARCHAR(10),
    NB_PAIS VARCHAR(100)
);

-- DIM_ESTADO_CONTRATO
CREATE TABLE DIM_ESTADO_CONTRATO (
    SK_DIM_ESTADO SERIAL PRIMARY KEY,
    COD_ESTADO CHAR(2) UNIQUE, -- Clave Natural con restricción UNIQUE para Carga Incremental
    DESCRIP_ESTADO VARCHAR(50)
);

-- DIM_EVALUACION_SERVICIO
CREATE TABLE DIM_EVALUACION_SERVICIO (
    SK_DIM_EVALUACION SERIAL PRIMARY KEY,
    COD_EVALUACION VARCHAR(10) UNIQUE NOT NULL, -- Clave Natural con restricción UNIQUE para Carga Incremental
    NB_DESCRIP VARCHAR(50)
);

-- DIM_SINIESTRO
CREATE TABLE DIM_SINIESTRO (
    SK_DIM_SINIESTRO SERIAL PRIMARY KEY,
    NRO_SINIESTRO VARCHAR(20) UNIQUE NOT NULL, -- Clave Natural con restricción UNIQUE para Carga Incremental
    DESCRIP_SINIESTRO TEXT
);

-- ==========================================
-- TABLAS DE HECHOS (FACTS)
-- ==========================================

-- FACT_REGISTRO_CONTRATO
CREATE TABLE FACT_REGISTRO_CONTRATO (
    SK_DIM_TIEMPO_FECHA_INICIO INTEGER REFERENCES DIM_TIEMPO(SK_DIM_TIEMPO),
    SK_DIM_TIEMPO_FECHA_FIN INTEGER REFERENCES DIM_TIEMPO(SK_DIM_TIEMPO),
    SK_DIM_CLIENTE INTEGER REFERENCES DIM_CLIENTE(SK_DIM_CLIENTE),
    SK_DIM_CONTRATO INTEGER REFERENCES DIM_CONTRATO(SK_DIM_CONTRATO),
    SK_DIM_PRODUCTO INTEGER REFERENCES DIM_PRODUCTO(SK_DIM_PRODUCTO),
    SK_DIM_ESTADO_CONTRATO INTEGER REFERENCES DIM_ESTADO_CONTRATO(SK_DIM_ESTADO),
    MONTO REAL,
    CANTIDAD INTEGER,
    CANTIDAD_CLIENTE INTEGER,
    CANTIDAD_PRODUCTO INTEGER,
    CANTIDAD_CONTRATO INTEGER
);

-- FACT_REGISTRO_SINIESTRO
CREATE TABLE FACT_REGISTRO_SINIESTRO (
    SK_FECHA_SINIESTRO INTEGER REFERENCES DIM_TIEMPO(SK_DIM_TIEMPO),
    SK_FECHA_RESPUESTA INTEGER REFERENCES DIM_TIEMPO(SK_DIM_TIEMPO),
    SK_DIM_CLIENTE INTEGER REFERENCES DIM_CLIENTE(SK_DIM_CLIENTE),
    SK_DIM_CONTRATO INTEGER REFERENCES DIM_CONTRATO(SK_DIM_CONTRATO),
    SK_DIM_SUCURSAL INTEGER REFERENCES DIM_SUCURSAL(SK_DIM_SUCURSAL),
    SK_DIM_PRODUCTO INTEGER REFERENCES DIM_PRODUCTO(SK_DIM_PRODUCTO),
    SK_DIM_SINIESTRO INTEGER REFERENCES DIM_SINIESTRO(SK_DIM_SINIESTRO),
    CANTIDAD INTEGER,
    MONTO_RECONOCIDO REAL,
    MONTO_SOLICITADO REAL,
    ID_RECHAZO CHAR(2)
);

-- FACT_EVALUACION_SERVICIO
CREATE TABLE FACT_EVALUACION_SERVICIO (
    SK_DIM_CLIENTE INTEGER REFERENCES DIM_CLIENTE(SK_DIM_CLIENTE),
    SK_DIM_PRODUCTO INTEGER REFERENCES DIM_PRODUCTO(SK_DIM_PRODUCTO),
    SK_DIM_EVALUACION_SERVICIO INTEGER REFERENCES DIM_EVALUACION_SERVICIO(SK_DIM_EVALUACION),
    CANTIDAD INTEGER,
    RECOMIENDA_AMIGO REAL
);

-- FACT_METAS
CREATE TABLE FACT_METAS (
    SK_DIM_FECHA_INICIO_META INTEGER REFERENCES DIM_TIEMPO(SK_DIM_TIEMPO),
    SK_DIM_FECHA_FIN_META INTEGER REFERENCES DIM_TIEMPO(SK_DIM_TIEMPO),
    SK_DIM_CLIENTE INTEGER REFERENCES DIM_CLIENTE(SK_DIM_CLIENTE),
    SK_DIM_PRODUCTO INTEGER REFERENCES DIM_PRODUCTO(SK_DIM_PRODUCTO),
    SK_DIM_CONTRATO INTEGER REFERENCES DIM_CONTRATO(SK_DIM_CONTRATO),
    MONTO_META_INGRESO REAL,
    META_RENOVACION INTEGER,
    META_ASEGURADOS INTEGER
);
-- =========================================================================
-- FASE D: POBLADO DE LA DIMENSIÓN TIEMPO
-- =========================================================================
INSERT INTO "SEGURO_DW_G27797047".DIM_TIEMPO (
    SK_DIM_TIEMPO, COD_ANNIO, COD_MES, COD_DIA, DESC_MES, DESC_TRIMESTRE, DESC_SEMESTRE, FECHA_COMPLETA
)
SELECT 
    to_char(fecha, 'YYYYMMDD')::integer, extract(year from fecha)::integer, extract(month from fecha)::integer, extract(day from fecha)::integer,
    CASE extract(month from fecha)
        WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo' WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre' WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
    END,
    -- BUG 6 FIX: Unificado a 'Trimestre ' para coincidir con DimTiempo.sql
    'Trimestre ' || extract(quarter from fecha), CASE WHEN extract(month from fecha) <= 6 THEN 'Semestre 1' ELSE 'Semestre 2' END, fecha
FROM generate_series('2015-01-01'::date, '2030-12-31'::date, '1 day'::interval) as fecha;

-- =========================================================================
-- FASE E: CREACIÓN DEL PROCEDIMIENTO ALMACENADO (ETL)
-- =========================================================================

CREATE OR REPLACE PROCEDURE actualizar_datawarehouse()
LANGUAGE plpgsql
AS $$
BEGIN
    -- ==========================================
    -- 1. CARGA INCREMENTAL DE DIMENSIONES (UPSERT)
    -- ==========================================
    
    INSERT INTO "SEGURO_DW_G27797047".DIM_CLIENTE (COD_CLIENTE, NB_CLIENTE, CI_RIF, TELEFONO, DIRECCION, SEXO, EMAIL)
    SELECT cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email FROM "SEGURO_G27797047".CLIENTE
    ON CONFLICT (COD_CLIENTE) DO UPDATE SET NB_CLIENTE = EXCLUDED.NB_CLIENTE, TELEFONO = EXCLUDED.TELEFONO, DIRECCION = EXCLUDED.DIRECCION, EMAIL = EXCLUDED.EMAIL;

    INSERT INTO "SEGURO_DW_G27797047".DIM_PRODUCTO (COD_PRODUCTO, NB_PRODUCTO, DESCRIP_PRODUCTO, COD_TIPO_PRODUCTO, NB_TIPO_PRODUCTO, CALIFICACION)
    SELECT p.cod_producto, p.nb_producto, p.descripcion, tp.cod_tipo_producto, tp.nb_tipo_producto, p.calificacion
    FROM "SEGURO_G27797047".PRODUCTO p JOIN "SEGURO_G27797047".TIPO_PRODUCTO tp ON p.cod_tipo_producto = tp.cod_tipo_producto
    ON CONFLICT (COD_PRODUCTO) DO UPDATE SET NB_PRODUCTO = EXCLUDED.NB_PRODUCTO, CALIFICACION = EXCLUDED.CALIFICACION;

    INSERT INTO "SEGURO_DW_G27797047".DIM_CONTRATO (NRO_CONTRATO, DESCRIP_CONTRATO)
    SELECT nro_contrato, descrip_contrato FROM "SEGURO_G27797047".CONTRATO
    ON CONFLICT (NRO_CONTRATO) DO UPDATE SET DESCRIP_CONTRATO = EXCLUDED.DESCRIP_CONTRATO;

    INSERT INTO "SEGURO_DW_G27797047".DIM_SUCURSAL (COD_SUCURSAL, NB_SUCURSAL, COD_CIUDAD, NB_CIUDAD, COD_PAIS, NB_PAIS)
    SELECT s.cod_sucursal, s.nb_sucursal, c.cod_ciudad, c.nb_ciudad, p.cod_pais, p.nb_pais
    FROM "SEGURO_G27797047".SUCURSAL s JOIN "SEGURO_G27797047".CIUDAD c ON s.cod_ciudad = c.cod_ciudad JOIN "SEGURO_G27797047".PAIS p ON c.cod_pais = p.cod_pais
    ON CONFLICT (COD_SUCURSAL) DO UPDATE SET NB_SUCURSAL = EXCLUDED.NB_SUCURSAL;

    INSERT INTO "SEGURO_DW_G27797047".DIM_SINIESTRO (NRO_SINIESTRO, DESCRIP_SINIESTRO)
    SELECT nro_siniestro, descripcion_siniestro FROM "SEGURO_G27797047".SINIESTRO
    ON CONFLICT (NRO_SINIESTRO) DO UPDATE SET DESCRIP_SINIESTRO = EXCLUDED.DESCRIP_SINIESTRO;

    INSERT INTO "SEGURO_DW_G27797047".DIM_EVALUACION_SERVICIO (COD_EVALUACION, NB_DESCRIP)
    SELECT cod_evaluacion_servicio, nb_descripcion FROM "SEGURO_G27797047".EVALUACION_SERVICIO
    ON CONFLICT (COD_EVALUACION) DO UPDATE SET NB_DESCRIP = EXCLUDED.NB_DESCRIP;

    -- BUG 1 FIX: Carga incremental de DIM_ESTADO_CONTRATO (nunca se poblaba antes)
    INSERT INTO "SEGURO_DW_G27797047".DIM_ESTADO_CONTRATO (COD_ESTADO, DESCRIP_ESTADO)
    VALUES ('AC', 'activo'), ('VE', 'vencido'), ('SU', 'suspendido')
    ON CONFLICT (COD_ESTADO) DO UPDATE SET DESCRIP_ESTADO = EXCLUDED.DESCRIP_ESTADO;

    -- ==========================================
    -- 2. CARGA DE TABLAS DE HECHOS (RELOAD)
    -- ==========================================

    -- FACT_REGISTRO_CONTRATO
    TRUNCATE TABLE "SEGURO_DW_G27797047".FACT_REGISTRO_CONTRATO;
    -- BUG 1 + BUG 2 FIX: Se agregan SK_DIM_TIEMPO_FECHA_FIN y SK_DIM_ESTADO_CONTRATO
    INSERT INTO "SEGURO_DW_G27797047".FACT_REGISTRO_CONTRATO (
        SK_DIM_TIEMPO_FECHA_INICIO, SK_DIM_TIEMPO_FECHA_FIN,
        SK_DIM_CLIENTE, SK_DIM_CONTRATO, SK_DIM_PRODUCTO,
        SK_DIM_ESTADO_CONTRATO, MONTO, CANTIDAD,
        CANTIDAD_CLIENTE, CANTIDAD_PRODUCTO, CANTIDAD_CONTRATO
    )
    SELECT
        to_char(rc.fecha_inicio, 'YYYYMMDD')::integer,
        to_char(rc.fecha_fin,    'YYYYMMDD')::integer,
        dc.SK_DIM_CLIENTE, dcon.SK_DIM_CONTRATO, dp.SK_DIM_PRODUCTO,
        de.SK_DIM_ESTADO,
        rc.monto, 1,
        1, 1, 1
    FROM "SEGURO_G27797047".REGISTRO_CONTRATO rc
    JOIN "SEGURO_DW_G27797047".DIM_CLIENTE dc ON rc.cod_cliente = dc.COD_CLIENTE
    JOIN "SEGURO_DW_G27797047".DIM_CONTRATO dcon ON rc.nro_contrato = dcon.NRO_CONTRATO
    JOIN "SEGURO_DW_G27797047".DIM_PRODUCTO dp ON rc.cod_producto = dp.COD_PRODUCTO
    JOIN "SEGURO_DW_G27797047".DIM_ESTADO_CONTRATO de ON de.DESCRIP_ESTADO = rc.estado_contrato;

    -- FACT_REGISTRO_SINIESTRO
    TRUNCATE TABLE "SEGURO_DW_G27797047".FACT_REGISTRO_SINIESTRO;
    INSERT INTO "SEGURO_DW_G27797047".FACT_REGISTRO_SINIESTRO (
        SK_FECHA_SINIESTRO, SK_FECHA_RESPUESTA, SK_DIM_CLIENTE, SK_DIM_CONTRATO, 
        SK_DIM_SUCURSAL, SK_DIM_PRODUCTO, SK_DIM_SINIESTRO, CANTIDAD, 
        MONTO_RECONOCIDO, MONTO_SOLICITADO, ID_RECHAZO
    )
    SELECT 
        to_char(rs.fecha_siniestro, 'YYYYMMDD')::integer, 
        to_char(rs.fecha_respuesta, 'YYYYMMDD')::integer,
        dc.SK_DIM_CLIENTE, dcon.SK_DIM_CONTRATO, ds.SK_DIM_SUCURSAL, 
        dp.SK_DIM_PRODUCTO, dsin.SK_DIM_SINIESTRO, 1, 
        rs.monto_reconocido, rs.monto_solicitado, rs.id_rechazo
    FROM "SEGURO_G27797047".REGISTRO_SINIESTRO rs
    JOIN "SEGURO_G27797047".REGISTRO_CONTRATO rc ON rs.nro_contrato = rc.nro_contrato
    JOIN "SEGURO_G27797047".CLIENTE c ON rc.cod_cliente = c.cod_cliente
    JOIN "SEGURO_DW_G27797047".DIM_CLIENTE dc ON rc.cod_cliente = dc.COD_CLIENTE
    JOIN "SEGURO_DW_G27797047".DIM_CONTRATO dcon ON rs.nro_contrato = dcon.NRO_CONTRATO
    JOIN "SEGURO_DW_G27797047".DIM_SUCURSAL ds ON c.cod_sucursal = ds.COD_SUCURSAL
    JOIN "SEGURO_DW_G27797047".DIM_PRODUCTO dp ON rc.cod_producto = dp.COD_PRODUCTO
    JOIN "SEGURO_DW_G27797047".DIM_SINIESTRO dsin ON rs.nro_siniestro = dsin.NRO_SINIESTRO;

    -- FACT_EVALUACION_SERVICIO
    TRUNCATE TABLE "SEGURO_DW_G27797047".FACT_EVALUACION_SERVICIO;
    INSERT INTO "SEGURO_DW_G27797047".FACT_EVALUACION_SERVICIO (SK_DIM_CLIENTE, SK_DIM_PRODUCTO, SK_DIM_EVALUACION_SERVICIO, CANTIDAD, RECOMIENDA_AMIGO)
    SELECT dc.SK_DIM_CLIENTE, dp.SK_DIM_PRODUCTO, de.SK_DIM_EVALUACION, 1, CASE WHEN r.recomienda_amigo = 'SI' THEN 1.0 ELSE 0.0 END
    FROM "SEGURO_G27797047".RECOMIENDA r
    JOIN "SEGURO_DW_G27797047".DIM_CLIENTE dc ON r.cod_cliente = dc.COD_CLIENTE
    JOIN "SEGURO_DW_G27797047".DIM_PRODUCTO dp ON r.cod_producto = dp.COD_PRODUCTO
    JOIN "SEGURO_DW_G27797047".DIM_EVALUACION_SERVICIO de ON r.cod_evaluacion_servicio = de.COD_EVALUACION;

    -- FACT_METAS
    TRUNCATE TABLE "SEGURO_DW_G27797047".FACT_METAS;
    -- BUG 5 FIX: RANDOM() reemplazado por fórmula determinista basada en SKs
    -- para garantizar reproducibilidad en cada ejecución del ETL.
    INSERT INTO "SEGURO_DW_G27797047".FACT_METAS (
        SK_DIM_FECHA_INICIO_META, SK_DIM_FECHA_FIN_META,
        SK_DIM_CLIENTE, SK_DIM_PRODUCTO, SK_DIM_CONTRATO,
        MONTO_META_INGRESO, META_RENOVACION, META_ASEGURADOS
    )
    SELECT
        20260101, 20261231,
        dc.SK_DIM_CLIENTE, dp.SK_DIM_PRODUCTO, dc_cont.SK_DIM_CONTRATO,
        ROUND((1000 + (dc.SK_DIM_CLIENTE * 37 + dp.SK_DIM_PRODUCTO * 113) % 4001)::numeric, 2),
        (dc.SK_DIM_CLIENTE + dp.SK_DIM_PRODUCTO) % 5 + 1,
        (dc.SK_DIM_CLIENTE + dp.SK_DIM_PRODUCTO) % 9 + 2
    FROM "SEGURO_DW_G27797047".DIM_CLIENTE dc
    CROSS JOIN (SELECT SK_DIM_PRODUCTO FROM "SEGURO_DW_G27797047".DIM_PRODUCTO LIMIT 3) dp
    CROSS JOIN (SELECT SK_DIM_CONTRATO FROM "SEGURO_DW_G27797047".DIM_CONTRATO LIMIT 3) dc_cont
    LIMIT 50;

END;
$$;

-- =========================================================================
-- FASE F: EJECUCIÓN INICIAL DEL ETL
-- =========================================================================
-- Esto asegura que, apenas termine de correr el script, el Data Warehouse se llene automáticamente.
CALL actualizar_datawarehouse();
