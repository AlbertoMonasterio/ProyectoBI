-- =========================================================================
-- SCRIPT DE INICIALIZACIÃ“N DE BASE DE DATOS Y DATA WAREHOUSE
-- PROYECTO BI - FASE II
-- =========================================================================

-- 1. LIMPIEZA PREVIA 
DROP SCHEMA IF EXISTS "SEGURO_G27797047" CASCADE;
DROP SCHEMA IF EXISTS "SEGURO_DW_G27797047" CASCADE;

-- =========================================================================
-- FASE A: MODELO TRANSACCIONAL (FUENTE)
-- =========================================================================

-- CreaciÃ³n y selecciÃ³n del esquema fuente
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
    id_evaluacion SERIAL PRIMARY KEY,
    cod_cliente VARCHAR(10) REFERENCES CLIENTE(cod_cliente),
    cod_evaluacion_servicio VARCHAR(10) REFERENCES EVALUACION_SERVICIO(cod_evaluacion_servicio),
    cod_producto VARCHAR(10) REFERENCES PRODUCTO(cod_producto),
    recomienda_amigo VARCHAR(2) CHECK (recomienda_amigo IN ('SI', 'NO')),
    fecha_evaluacion DATE NOT NULL DEFAULT CURRENT_DATE
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
    estado_contrato VARCHAR(20) NOT NULL CHECK (estado_contrato IN ('activo', 'vencido', 'suspendido'))
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

-- =========================================================================
-- FASE B: INSERCIÃ“N DE DATOS TRANSACCIONALES
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
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C001', 'Victor Manuel Leiva', 'V-25863638', '0414-4258907', 'Urb. El Trigal, Valencia', 'F', 'juliemorales@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C002', 'Paloma Paz Conesa', 'V-5915514', '0424-2822995', 'Av. Bolivar, Caracas', 'F', 'marisolbusquets@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C003', 'Antonia Torre Manrique', 'V-21608375', '0212-6586773', 'Av. Lara, Barquisimeto', 'M', 'lidiachaparro@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C004', 'Eva Calzada Alcalá', 'V-10363157', '0412-1166016', 'Av. Francisco de Miranda, Caracas', 'F', 'alexandramir@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C005', 'Gabriela Álvaro Baena', 'V-20584049', '0426-9492474', 'Urb. El Trigal, Valencia', 'F', 'calistoleiva@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C006', 'Daniela Almudena Gras Pablo', 'V-6924940', '0424-9524673', 'Av. Francisco de Miranda, Caracas', 'F', 'eustaquio81@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C007', 'Paulino Coll Quirós', 'V-11924449', '0424-8897748', 'Av. Bolivar, Caracas', 'F', 'sarabiaramiro@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C008', 'Basilio Ariño Agudo', 'V-29769169', '0412-4166771', 'Av. Bolivar, Caracas', 'F', 'xrosello@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C009', 'Moisés Ángel-Tapia', 'V-23495196', '0424-9225920', 'Av. Bolivar, Caracas', 'M', 'htomas@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C010', 'Candelaria Carpio', 'V-16096497', '0416-1851954', 'Av. Las Delicias, Maracay', 'M', 'ariaschuy@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C011', 'Chema Heredia Pallarès', 'V-29042669', '0212-2462361', 'Av. Bolivar, Caracas', 'M', 'munozlucio@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C012', 'Reyes Avilés', 'V-5178659', '0416-6661957', 'Av. Francisco de Miranda, Caracas', 'M', 'jandres@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C013', 'Nidia Herranz González', 'V-10794900', '0212-2438478', 'Av. Francisco de Miranda, Caracas', 'F', 'pepe40@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C014', 'Jafet Cuevas Piñeiro', 'V-6447119', '0424-8643982', 'Av. Lara, Barquisimeto', 'F', 'nydiabayo@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C015', 'Agustín Bou Solsona', 'V-22669942', '0424-7308209', 'Av. Las Delicias, Maracay', 'M', 'btoledo@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C016', 'Bibiana Vera Tejero Losada', 'V-16696977', '0412-6315638', 'Av. Francisco de Miranda, Caracas', 'M', 'amayachema@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C017', 'Anita Soria Sarmiento', 'V-13833606', '0414-1956363', 'Urb. El Trigal, Valencia', 'F', 'jordamercedes@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C018', 'Domitila Carrillo Tirado', 'V-19399883', '0426-2116996', 'Av. Lara, Barquisimeto', 'M', 'agoni@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C019', 'Custodia Peláez Castillo', 'V-25335596', '0412-5186199', 'Calle 72, Maracaibo', 'F', 'valentinabonilla@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C020', 'Fernanda Sevilla Llorens', 'V-14711015', '0414-3699199', 'Av. Bolivar, Caracas', 'F', 'icobos@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C021', 'Renata Peláez Valencia', 'V-17501262', '0424-2156814', 'Urb. El Trigal, Valencia', 'F', 'zabalagregorio@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C022', 'Prudencia Quevedo Escobar', 'V-27330474', '0424-9917614', 'Av. Bolivar, Caracas', 'M', 'reynaldo80@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C023', 'Jovita Martí', 'V-23624566', '0414-2052099', 'Av. Lara, Barquisimeto', 'F', 'ponceernesto@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C024', 'Mariano Santos Tomé Juliá', 'V-16017039', '0416-5131998', 'Calle 72, Maracaibo', 'F', 'javisaavedra@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C025', 'Eduardo de Goñi', 'V-26074748', '0426-9778090', 'Av. Lara, Barquisimeto', 'F', 'nacuna@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C026', 'Rosa Flor Sainz Balaguer', 'V-22213424', '0424-9080920', 'Av. Bolivar, Caracas', 'F', 'bporta@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C027', 'Javi Blanca-Zurita', 'V-20160333', '0414-7492255', 'Av. Lara, Barquisimeto', 'M', 'heraclio36@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C028', 'Julio Jover Pujadas', 'V-28203089', '0412-7444679', 'Calle 72, Maracaibo', 'F', 'donosomarcela@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C029', 'Serafina Villena Gomez', 'V-23450029', '0212-3352724', 'Av. Francisco de Miranda, Caracas', 'M', 'oaramburu@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C030', 'Angelita Cardona Salmerón', 'V-15176680', '0416-1524351', 'Urb. El Trigal, Valencia', 'M', 'balaguermaria@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C031', 'Teodora Taboada Heras', 'V-21108406', '0414-5405292', 'Av. Las Delicias, Maracay', 'F', 'julianmarcial@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C032', 'Nazaret Palacio Montenegro', 'V-25629903', '0424-7075215', 'Av. Francisco de Miranda, Caracas', 'M', 'lazarosobrino@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C033', 'Charo Cabezas Alba', 'V-21527455', '0424-6945949', 'Av. Las Delicias, Maracay', 'F', 'pio84@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C034', 'Fermín del Roma', 'V-28270362', '0416-9081078', 'Av. Las Delicias, Maracay', 'F', 'dvega@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C035', 'Saturnina Solís Recio', 'V-14731855', '0412-9260719', 'Av. Francisco de Miranda, Caracas', 'F', 'josefinaroman@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C036', 'Severino Agustín Gascón', 'V-14780390', '0416-1521082', 'Av. Francisco de Miranda, Caracas', 'F', 'berengueredelmira@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C037', 'Consuelo Lopez Sales', 'V-12721608', '0426-4120998', 'Av. Bolivar, Caracas', 'F', 'tpombo@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C038', 'Tere Aramburu Reguera', 'V-15638181', '0424-4613333', 'Av. Las Delicias, Maracay', 'M', 'carvajalapolinar@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C039', 'Maricela Flor Doménech', 'V-11816310', '0212-8685522', 'Av. Las Delicias, Maracay', 'F', 'alcazarabilio@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C040', 'Gerardo Francisco Gibert Guillen', 'V-6553873', '0414-3815078', 'Av. Francisco de Miranda, Caracas', 'F', 'lucioluque@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C041', 'Samu Aznar-Riba', 'V-26993226', '0426-2549998', 'Calle 72, Maracaibo', 'M', 'saezmaria-fernanda@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C042', 'Catalina Téllez Arribas', 'V-26312313', '0424-1437831', 'Calle 72, Maracaibo', 'M', 'tcortina@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C043', 'Nazaret de Figueras', 'V-17351267', '0414-5686350', 'Av. Bolivar, Caracas', 'M', 'labascal@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C044', 'Vasco Cabanillas Blazquez', 'V-28328541', '0426-6455722', 'Urb. El Trigal, Valencia', 'F', 'fidela14@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C045', 'Luciano de Noriega', 'V-15876411', '0414-6180010', 'Calle 72, Maracaibo', 'F', 'htorrens@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C046', 'Felipa Marqués', 'V-13194163', '0426-1544572', 'Calle 72, Maracaibo', 'M', 'cristianjerez@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C047', 'Timoteo Olivé Casals', 'V-25666804', '0424-5799271', 'Calle 72, Maracaibo', 'F', 'abenito@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C048', 'Marina Angulo Bautista', 'V-12132663', '0424-5888275', 'Av. Bolivar, Caracas', 'F', 'jimenezmiguel@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C049', 'Fanny del Goicoechea', 'V-30220972', '0416-4399845', 'Av. Bolivar, Caracas', 'M', 'adela42@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C050', 'Candelario Carlos Chaves', 'V-20132711', '0426-8076768', 'Av. Bolivar, Caracas', 'F', 'palmerbienvenida@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C051', 'Isa Ropero Noriega', 'V-12084328', '0426-4182655', 'Urb. El Trigal, Valencia', 'M', 'teofila76@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C052', 'Luciana de Ros', 'V-18241583', '0412-1083725', 'Calle 72, Maracaibo', 'F', 'ysaenz@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C053', 'María Miguel Ángel Carbajo Redondo', 'V-25263699', '0414-2040723', 'Urb. El Trigal, Valencia', 'F', 'rosaliasebastian@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C054', 'Jose Angel Valero-Borrás', 'V-19943002', '0212-2695280', 'Calle 72, Maracaibo', 'F', 'abarba@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C055', 'Germán Santana-Adadia', 'V-26210483', '0416-1442830', 'Av. Las Delicias, Maracay', 'F', 'esmeralda28@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C056', 'Sara Mir', 'V-22644950', '0424-4423014', 'Av. Bolivar, Caracas', 'F', 'uguardia@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C057', 'Primitiva Enríquez Torrecilla', 'V-8057001', '0426-7917768', 'Calle 72, Maracaibo', 'F', 'maricela89@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C058', 'Ignacio Fernandez Peñas', 'V-14320328', '0426-3884072', 'Av. Bolivar, Caracas', 'M', 'ballesterosmaria-pilar@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C059', 'Manu de Machado', 'V-6108477', '0416-6126016', 'Av. Bolivar, Caracas', 'M', 'jorgecamacho@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C060', 'Celia Amador Calvo', 'V-27044934', '0424-1927967', 'Urb. El Trigal, Valencia', 'F', 'usantiago@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C061', 'Eusebio de Salmerón', 'V-19963687', '0416-6280276', 'Av. Francisco de Miranda, Caracas', 'F', 'sergiomayoral@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C062', 'Geraldo Victor Manuel Aguado Martorell', 'V-19186792', '0416-5779291', 'Urb. El Trigal, Valencia', 'F', 'sancho34@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C063', 'Remedios Merino Francisco', 'V-18780365', '0416-3219688', 'Calle 72, Maracaibo', 'M', 'fuentejuan-jose@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C064', 'Rosaura Barón Lasa', 'V-10181524', '0416-8359744', 'Urb. El Trigal, Valencia', 'M', 'maria-luisa04@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C065', 'Ángeles Ema Cáceres Perez', 'V-12181297', '0424-6797164', 'Av. Bolivar, Caracas', 'F', 'xbartolome@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C066', 'Petrona Mateos Rozas', 'V-30947241', '0414-6679490', 'Av. Bolivar, Caracas', 'F', 'luchomarino@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C067', 'Máxima Álamo Enríquez', 'V-13040790', '0414-7048089', 'Av. Lara, Barquisimeto', 'M', 'alcides77@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C068', 'Juan Bautista Rubén Andrés Toledo', 'V-23649422', '0414-4229191', 'Av. Lara, Barquisimeto', 'F', 'geraldomateu@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C069', 'Simón Carrillo Mendez', 'V-21986480', '0414-1507903', 'Calle 72, Maracaibo', 'F', 'olivaresramon@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C070', 'Ruperto Poza Mas', 'V-24080368', '0424-1322754', 'Av. Lara, Barquisimeto', 'F', 'hernandonatanael@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C071', 'Pascual Posada Espejo', 'V-28273565', '0426-3371132', 'Av. Francisco de Miranda, Caracas', 'M', 'dalmaulalo@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C072', 'Iris Cuéllar', 'V-27407041', '0414-1204797', 'Av. Las Delicias, Maracay', 'F', 'jaureguiirma@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C073', 'Nuria Pina-Adán', 'V-12190237', '0412-3395406', 'Av. Bolivar, Caracas', 'M', 'carrionjuan-luis@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C074', 'Berta Abellán Maestre', 'V-16661209', '0212-7625982', 'Av. Lara, Barquisimeto', 'M', 'danmesa@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C075', 'Pancho Cisneros-Doménech', 'V-29926464', '0416-9471539', 'Av. Lara, Barquisimeto', 'M', 'camilaneira@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C076', 'Apolinar Gaya Caballero', 'V-6871697', '0416-6215329', 'Av. Francisco de Miranda, Caracas', 'M', 'adolforosales@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C077', 'Bibiana Ortiz', 'V-7134395', '0412-1846983', 'Av. Francisco de Miranda, Caracas', 'F', 'bmarques@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C078', 'Eustaquio de Pina', 'V-15552808', '0426-1986653', 'Calle 72, Maracaibo', 'F', 'natalio36@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C079', 'Roxana Ramón-Rosa', 'V-10392154', '0412-5058284', 'Av. Francisco de Miranda, Caracas', 'F', 'estrellaperera@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C080', 'Elba Juárez Mena', 'V-24532259', '0416-9259459', 'Urb. El Trigal, Valencia', 'F', 'miguelbenita@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C081', 'Gala Pinto-Conde', 'V-18297884', '0412-7387579', 'Urb. El Trigal, Valencia', 'F', 'qmoll@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C082', 'Rosendo Fernández Calderón', 'V-28776813', '0212-4200484', 'Av. Lara, Barquisimeto', 'F', 'imir@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C083', 'Mario Madrigal', 'V-9154394', '0426-7128233', 'Av. Las Delicias, Maracay', 'F', 'rosariozapata@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C084', 'Marcelino Armas Andrade', 'V-24415425', '0416-4972860', 'Av. Las Delicias, Maracay', 'F', 'pepitoalbero@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C085', 'Roberta Yuste Moraleda', 'V-11993133', '0212-2034349', 'Av. Bolivar, Caracas', 'F', 'fernando12@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C086', 'Ainara Sanchez', 'V-9297223', '0424-1574407', 'Av. Francisco de Miranda, Caracas', 'F', 'aduque@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C087', 'Primitiva Carretero Cañete', 'V-29783844', '0412-4939806', 'Calle 72, Maracaibo', 'M', 'barriojose-antonio@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C088', 'Teo Yuste-Priego', 'V-20477630', '0424-3200491', 'Av. Las Delicias, Maracay', 'M', 'hernandovalderrama@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C089', 'Marisol Claudia Bayón Español', 'V-9178276', '0426-6264875', 'Urb. El Trigal, Valencia', 'F', 'rosaura78@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C090', 'Catalina Roma Bárcena', 'V-28856428', '0426-9086616', 'Av. Francisco de Miranda, Caracas', 'F', 'paca53@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C091', 'Urbano Zapata Pozo', 'V-26305371', '0416-4268928', 'Av. Las Delicias, Maracay', 'F', 'raimundo51@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C092', 'Leonel Dalmau Castejón', 'V-10215658', '0414-4243685', 'Calle 72, Maracaibo', 'M', 'rosendo56@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C093', 'Bibiana Canales Nuñez', 'V-27316571', '0212-3082296', 'Av. Lara, Barquisimeto', 'F', 'villenainmaculada@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C094', 'Adelia Ballester Valcárcel', 'V-17104751', '0414-2326061', 'Av. Francisco de Miranda, Caracas', 'M', 'socorro91@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C095', 'Fernando Bermudez Hurtado', 'V-25283560', '0424-6824829', 'Av. Bolivar, Caracas', 'M', 'pablosantiago@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C096', 'Florinda Evelia Gaya Boix', 'V-10805869', '0412-4264083', 'Urb. El Trigal, Valencia', 'F', 'vduenas@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C097', 'Santiago Pinilla Fortuny', 'V-24232081', '0416-3163340', 'Calle 72, Maracaibo', 'F', 'marciaperera@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C098', 'Duilio Barrios Medina', 'V-9541276', '0212-1186587', 'Av. Bolivar, Caracas', 'F', 'perallupe@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C099', 'Perlita Arteaga Acuña', 'V-9132771', '0212-5489747', 'Calle 72, Maracaibo', 'F', 'mircarolina@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C100', 'Ismael Porras Gimenez', 'V-19493020', '0416-3526996', 'Calle 72, Maracaibo', 'M', 'jordana27@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C101', 'Nieves Valls Heredia', 'V-21367453', '0426-2073345', 'Av. Bolivar, Caracas', 'M', 'nilovillegas@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C102', 'Germán Carpio Manrique', 'V-28532004', '0416-1483337', 'Av. Francisco de Miranda, Caracas', 'M', 'dconesa@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C103', 'Heriberto Jódar-Trujillo', 'V-5003677', '0426-8784761', 'Av. Bolivar, Caracas', 'F', 'asalvador@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C104', 'Aroa Blanco Salas', 'V-20685744', '0416-5431516', 'Av. Lara, Barquisimeto', 'M', 'rodrigocasemiro@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C105', 'Fulgencio Jordán Maza', 'V-25971467', '0212-8009969', 'Av. Bolivar, Caracas', 'M', 'rrio@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C106', 'Juanita Cárdenas-Peñas', 'V-23673416', '0212-4694356', 'Av. Las Delicias, Maracay', 'M', 'jenny22@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C107', 'Carlos Salazar Moliner', 'V-22756185', '0416-8250868', 'Av. Lara, Barquisimeto', 'M', 'galcazar@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C108', 'Ruth Peiró-Blanca', 'V-14054010', '0412-1001648', 'Av. Bolivar, Caracas', 'F', 'nfuentes@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C109', 'Dorotea Suárez Abad', 'V-29222582', '0212-2988616', 'Calle 72, Maracaibo', 'F', 'esolera@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C110', 'Cloe Calderón Esteve', 'V-13830922', '0424-6488043', 'Av. Francisco de Miranda, Caracas', 'M', 'maristela32@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C111', 'Felicia Inmaculada Villalba Tomé', 'V-29265738', '0426-9655211', 'Urb. El Trigal, Valencia', 'F', 'zabaletaoctavio@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C112', 'Celia Hurtado Machado', 'V-30419175', '0426-3011636', 'Av. Bolivar, Caracas', 'F', 'francisca80@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C113', 'César Izquierdo Manrique', 'V-29175644', '0414-5926900', 'Urb. El Trigal, Valencia', 'M', 'rogelioanguita@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C114', 'Lilia Carmona Águila', 'V-19124839', '0424-6031957', 'Av. Lara, Barquisimeto', 'M', 'maestreimelda@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C115', 'Seve Arcos Antúnez', 'V-20780366', '0426-4601381', 'Urb. El Trigal, Valencia', 'F', 'yolandatorre@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C116', 'Danilo del Oliveras', 'V-9931258', '0412-9527520', 'Av. Las Delicias, Maracay', 'M', 'nietocandido@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C117', 'Carolina Marí-Estévez', 'V-6973869', '0212-4767264', 'Av. Francisco de Miranda, Caracas', 'M', 'jose-angel30@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C118', 'Rosa Lilia Arribas Bonilla', 'V-28353824', '0212-8746445', 'Av. Lara, Barquisimeto', 'F', 'flaviavalentin@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C119', 'Eleuterio Cáceres Lucas', 'V-23099899', '0414-6791041', 'Urb. El Trigal, Valencia', 'M', 'baldomero67@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C120', 'Amador del Martínez', 'V-26204271', '0414-5816984', 'Calle 72, Maracaibo', 'F', 'kike95@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C121', 'Etelvina Jara Godoy', 'V-29123058', '0412-8854664', 'Av. Francisco de Miranda, Caracas', 'M', 'ursularedondo@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C122', 'Carlito Valdés Coloma', 'V-15846513', '0412-2949320', 'Calle 72, Maracaibo', 'M', 'rossellojaime@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C123', 'Sabina Lopez Amador', 'V-7648809', '0426-9396645', 'Av. Bolivar, Caracas', 'M', 'tsolis@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C124', 'Pelayo Ledesma Santamaría', 'V-9295531', '0414-4725588', 'Av. Lara, Barquisimeto', 'F', 'pcoronado@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C125', 'Carmelita de Ribera', 'V-9483184', '0412-7140275', 'Calle 72, Maracaibo', 'F', 'antonio86@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C126', 'Segismundo Chaves Sosa', 'V-9026712', '0424-1301255', 'Av. Francisco de Miranda, Caracas', 'F', 'celiamartinez@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C127', 'Petrona Cañete Montenegro', 'V-26894937', '0414-9356767', 'Av. Las Delicias, Maracay', 'M', 'mcano@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C128', 'Isa Anna Bellido Benitez', 'V-14574937', '0414-4775668', 'Av. Las Delicias, Maracay', 'M', 'paulina70@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C129', 'Rodrigo Calzada Matas', 'V-23983060', '0424-2210586', 'Calle 72, Maracaibo', 'F', 'patricia51@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C130', 'Rita Coronado Larrea', 'V-27361933', '0426-3299316', 'Av. Las Delicias, Maracay', 'M', 'ayalaofelia@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C131', 'Manola Pedrosa Ferrándiz', 'V-19736423', '0414-1682669', 'Av. Bolivar, Caracas', 'M', 'zbarranco@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C132', 'Nando Fiol Cuadrado', 'V-28949256', '0426-2581589', 'Av. Bolivar, Caracas', 'M', 'yesica90@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C133', 'Asunción Huguet Amores', 'V-6256291', '0414-3084839', 'Urb. El Trigal, Valencia', 'M', 'tmariscal@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C134', 'Petrona Gonzalo Sancho', 'V-6779843', '0414-9383169', 'Av. Las Delicias, Maracay', 'M', 'abrilrozas@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C135', 'Eutimio Reguera Ibarra', 'V-10644021', '0414-8625656', 'Av. Lara, Barquisimeto', 'M', 'nsacristan@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C136', 'Jenaro Collado Priego', 'V-13733098', '0412-8283414', 'Av. Francisco de Miranda, Caracas', 'F', 'reynaldo57@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C137', 'Zaira Sosa Luján', 'V-16266520', '0414-1149627', 'Av. Bolivar, Caracas', 'M', 'arcelia05@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C138', 'Toño Vélez-Franco', 'V-7733792', '0412-1743775', 'Av. Bolivar, Caracas', 'F', 'aparra@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C139', 'Agustina Pedro Ferrández', 'V-21180351', '0424-5290882', 'Av. Francisco de Miranda, Caracas', 'F', 'rrodriguez@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C140', 'Andrés Felipe Perera Morera', 'V-13483132', '0416-3487248', 'Av. Francisco de Miranda, Caracas', 'M', 'florinda92@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C141', 'Juan Antonio Gracia Muñoz', 'V-12518679', '0212-6354041', 'Calle 72, Maracaibo', 'F', 'micaeladalmau@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C142', 'Maribel Martínez Goicoechea', 'V-19309077', '0424-5736235', 'Av. Bolivar, Caracas', 'F', 'fatimainiesta@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C143', 'Rafaela Marí Guerrero', 'V-26391519', '0424-6619153', 'Calle 72, Maracaibo', 'M', 'aragonfermin@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C144', 'Cayetano Casanova Carrasco', 'V-20839959', '0426-5513284', 'Calle 72, Maracaibo', 'F', 'marianela30@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C145', 'Berta Berrocal', 'V-9348001', '0412-4780186', 'Calle 72, Maracaibo', 'M', 'bernabeamaya@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C146', 'Ángela Milla-Calzada', 'V-16326245', '0414-2595127', 'Av. Las Delicias, Maracay', 'M', 'eugenia78@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C147', 'Anselmo Espada Barrena', 'V-23477756', '0416-9285197', 'Av. Bolivar, Caracas', 'F', 'renato24@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C148', 'Rebeca Sanchez', 'V-13439420', '0414-7770230', 'Av. Francisco de Miranda, Caracas', 'M', 'wpineda@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C149', 'Severiano Hervás Donaire', 'V-16355841', '0212-1022447', 'Av. Lara, Barquisimeto', 'F', 'azahara92@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C150', 'René Che Manrique Ávila', 'V-6590597', '0212-8203398', 'Av. Las Delicias, Maracay', 'M', 'oviana@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C151', 'Buenaventura Patiño-Pina', 'V-11272039', '0414-2955206', 'Calle 72, Maracaibo', 'M', 'fortunatomartin@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C152', 'Santos Roselló Canales', 'V-19025344', '0412-5217324', 'Calle 72, Maracaibo', 'F', 'perezjose-manuel@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C153', 'Mamen Rivero Pino', 'V-21518408', '0212-8890209', 'Urb. El Trigal, Valencia', 'F', 'chus82@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C154', 'Cirino del Acuña', 'V-28428835', '0212-7372397', 'Urb. El Trigal, Valencia', 'F', 'whervas@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C155', 'María Pilar Silva Jaén', 'V-21688068', '0212-3214078', 'Av. Bolivar, Caracas', 'M', 'mamencaballero@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C156', 'Jose Francisco Toño Aller Collado', 'V-30508225', '0212-2757215', 'Av. Las Delicias, Maracay', 'M', 'yegea@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C157', 'Amelia Medina Araujo', 'V-21890195', '0414-4096592', 'Calle 72, Maracaibo', 'M', 'baudelio83@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C158', 'Ricardo Moreno-Olivares', 'V-16870609', '0414-8528727', 'Av. Las Delicias, Maracay', 'F', 'kblasco@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C159', 'Santos Calatayud Miguel', 'V-7989560', '0416-2683613', 'Av. Las Delicias, Maracay', 'F', 'arielpalau@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C160', 'Eva María Esperanza Mora Ribas', 'V-11360050', '0416-8267265', 'Av. Las Delicias, Maracay', 'F', 'sdominguez@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C161', 'Sigfrido Leiva Rubio', 'V-18067777', '0414-6760642', 'Urb. El Trigal, Valencia', 'M', 'nicodemourrutia@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C162', 'Bibiana Blasco Correa', 'V-13585779', '0212-3391026', 'Av. Lara, Barquisimeto', 'M', 'pblanes@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C163', 'Edelmira Camila Rivera Rodríguez', 'V-11745218', '0212-6688087', 'Av. Bolivar, Caracas', 'M', 'ordonezesther@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C164', 'Vilma Pinilla Lastra', 'V-17964294', '0426-9899785', 'Calle 72, Maracaibo', 'M', 'pinocarmina@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C165', 'Erasmo del Mora', 'V-28662660', '0424-5309346', 'Urb. El Trigal, Valencia', 'F', 'isaias24@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C166', 'Fabricio Garzón Villaverde', 'V-10143541', '0212-8793933', 'Av. Lara, Barquisimeto', 'M', 'teofilocarrion@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C167', 'Clímaco Peñas Muro', 'V-28656276', '0424-9092674', 'Calle 72, Maracaibo', 'M', 'emigdionaranjo@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C168', 'Che Alberto Ribera Boada', 'V-9686395', '0424-2287697', 'Av. Bolivar, Caracas', 'F', 'xanglada@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C169', 'Roberta Pinto Vega', 'V-15711628', '0416-6892414', 'Av. Francisco de Miranda, Caracas', 'F', 'maria-luisa86@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C170', 'Baldomero Carrión Ferrando', 'V-20101932', '0426-9054766', 'Av. Las Delicias, Maracay', 'M', 'enebot@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C171', 'Íngrid Plaza Amaya', 'V-29500902', '0212-4545740', 'Av. Bolivar, Caracas', 'M', 'fhurtado@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C172', 'Alfonso Castellanos Ariño', 'V-22208799', '0212-8024947', 'Av. Las Delicias, Maracay', 'M', 'feijoochus@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C173', 'Jesusa Pablo Bauzà', 'V-8419279', '0212-5585156', 'Av. Lara, Barquisimeto', 'F', 'jalberola@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C174', 'Adolfo Gras Bayona', 'V-5309258', '0412-7131878', 'Av. Francisco de Miranda, Caracas', 'M', 'cortinabienvenida@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C175', 'Jose Quiroga Reina', 'V-5803200', '0212-4215477', 'Av. Las Delicias, Maracay', 'M', 'dlujan@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C176', 'Elpidio Rocha Mascaró', 'V-28115751', '0424-3550721', 'Calle 72, Maracaibo', 'M', 'daniela62@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C177', 'Ceferino Gallo-Ferrández', 'V-14153587', '0212-6432322', 'Urb. El Trigal, Valencia', 'F', 'bpalacios@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C178', 'Zacarías Pozo', 'V-7032356', '0424-1901560', 'Urb. El Trigal, Valencia', 'M', 'eligia11@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C179', 'Eva Bejarano Vicente', 'V-26641187', '0416-2226210', 'Av. Francisco de Miranda, Caracas', 'F', 'zcanizares@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C180', 'Teobaldo Ortuño Valbuena', 'V-21948474', '0412-5921288', 'Av. Las Delicias, Maracay', 'F', 'jmillan@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C181', 'Guadalupe Gallo', 'V-6508863', '0416-6942161', 'Av. Francisco de Miranda, Caracas', 'F', 'aaguila@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C182', 'Porfirio Viana', 'V-17965270', '0426-1083632', 'Av. Las Delicias, Maracay', 'M', 'emilianocobos@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C183', 'Sol Jáuregui Valencia', 'V-30531506', '0424-5393579', 'Av. Bolivar, Caracas', 'M', 'ypadilla@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C184', 'Arcelia José Soler Maldonado', 'V-8386984', '0412-9486845', 'Av. Lara, Barquisimeto', 'M', 'marcial34@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C185', 'Candelario Barba Cañete', 'V-21162109', '0416-5345978', 'Av. Francisco de Miranda, Caracas', 'M', 'piaalonso@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C186', 'Magdalena Nuñez Bolaños', 'V-18262916', '0416-1710798', 'Av. Bolivar, Caracas', 'F', 'virginia49@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C187', 'Ruperto Almeida Buendía', 'V-21050100', '0412-1450414', 'Av. Lara, Barquisimeto', 'F', 'boschestela@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C188', 'Filomena Patiño', 'V-12986320', '0212-9558174', 'Urb. El Trigal, Valencia', 'F', 'emolina@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C189', 'Javi Coca Tolosa', 'V-5085686', '0424-3792655', 'Av. Las Delicias, Maracay', 'F', 'manuelsanmartin@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C190', 'Maxi Tovar Domingo', 'V-5598965', '0416-2325594', 'Av. Bolivar, Caracas', 'M', 'teoguardia@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C191', 'Amor Benítez', 'V-17208952', '0414-6843512', 'Calle 72, Maracaibo', 'F', 'dsalmeron@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C192', 'Alba Aller Botella', 'V-14541455', '0414-1055753', 'Av. Bolivar, Caracas', 'F', 'arseniogabaldon@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C193', 'Nacio Ayllón Angulo', 'V-8599613', '0412-4641747', 'Av. Las Delicias, Maracay', 'M', 'tamarithortensia@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C194', 'Raúl Rosselló Salinas', 'V-23550990', '0416-7835185', 'Av. Lara, Barquisimeto', 'M', 'renato53@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C195', 'Apolonia Vilar Arnaiz', 'V-9820707', '0212-1478864', 'Calle 72, Maracaibo', 'F', 'aurelio28@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C196', 'Ángeles Andrés-Bermejo', 'V-18487801', '0412-1548219', 'Av. Lara, Barquisimeto', 'F', 'encarnacionpascual@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C197', 'Jacinta Revilla Abellán', 'V-8762489', '0424-6483927', 'Av. Bolivar, Caracas', 'M', 'maria-fernanda15@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C198', 'Ciriaco Benet Sabater', 'V-7856422', '0416-5553677', 'Av. Bolivar, Caracas', 'M', 'chitapalomar@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C199', 'Adalberto Anaya Calderon', 'V-27695451', '0426-4422477', 'Av. Las Delicias, Maracay', 'M', 'yhervia@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C200', 'José del Losa', 'V-17615196', '0416-2661755', 'Av. Bolivar, Caracas', 'F', 'marino42@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C201', 'Modesta Antón Amat', 'V-21429590', '0414-2472925', 'Calle 72, Maracaibo', 'F', 'julietabermudez@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C202', 'Olga Mir Somoza', 'V-18299951', '0416-7466760', 'Av. Lara, Barquisimeto', 'M', 'maria-del-carmen51@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C203', 'Xiomara Saez Galan', 'V-20452601', '0424-5793640', 'Av. Bolivar, Caracas', 'M', 'galaochoa@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C204', 'Amaro Torralba Losa', 'V-17816481', '0416-8525971', 'Calle 72, Maracaibo', 'F', 'pia67@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C205', 'Delfina Belda Barros', 'V-18318057', '0426-4774354', 'Calle 72, Maracaibo', 'M', 'noeotero@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C206', 'Dionisio Duran', 'V-9212892', '0426-8233591', 'Av. Bolivar, Caracas', 'M', 'hurtadoale@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C207', 'Áurea Iniesta Alberto', 'V-23456432', '0412-9360869', 'Calle 72, Maracaibo', 'M', 'bolanosbaltasar@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C208', 'Maxi Almazán Salinas', 'V-21365649', '0416-3403360', 'Urb. El Trigal, Valencia', 'M', 'angelespaniagua@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C209', 'Faustino Comas Arteaga', 'V-23566096', '0412-6228852', 'Av. Bolivar, Caracas', 'M', 'ortunoadan@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C210', 'Aura Alemany-Piñeiro', 'V-27339682', '0416-4921689', 'Av. Lara, Barquisimeto', 'M', 'irmaabascal@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C211', 'Gervasio Graciano Álvarez Manso', 'V-16559989', '0212-5797826', 'Urb. El Trigal, Valencia', 'M', 'hilarioagustin@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C212', 'Joel Isaías Peralta Díez', 'V-24524257', '0414-5344212', 'Av. Francisco de Miranda, Caracas', 'M', 'barberorafael@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C213', 'Samuel Baquero-Barragán', 'V-21933002', '0414-7834660', 'Urb. El Trigal, Valencia', 'F', 'echevarriaazahar@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C214', 'Maximino Domínguez Bernad', 'V-7632025', '0424-4098810', 'Av. Bolivar, Caracas', 'M', 'sadan@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C215', 'Carlito Miranda Cañete', 'V-6771085', '0416-3917881', 'Urb. El Trigal, Valencia', 'M', 'tmaestre@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C216', 'Américo Lobo-Luque', 'V-21555447', '0424-3866640', 'Av. Francisco de Miranda, Caracas', 'F', 'ramirocervera@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C217', 'Remedios Salgado Baños', 'V-10838985', '0416-8452884', 'Av. Bolivar, Caracas', 'M', 'reigaurelio@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C218', 'Felipa Segura Piña', 'V-24548899', '0426-5830968', 'Av. Bolivar, Caracas', 'F', 'bilbaojordana@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C219', 'Wálter Reynaldo Calzada Pascual', 'V-19157755', '0414-6753594', 'Calle 72, Maracaibo', 'F', 'queromayte@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C220', 'Maxi Sánchez Iglesia', 'V-7838444', '0424-2232509', 'Av. Las Delicias, Maracay', 'F', 'ninociriaco@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C221', 'Bienvenida Riba Casals', 'V-20681774', '0426-4712717', 'Av. Francisco de Miranda, Caracas', 'F', 'maestreheriberto@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C222', 'Tania Alonso Sanmartín', 'V-9323595', '0426-2212820', 'Av. Bolivar, Caracas', 'F', 'primitiva36@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C223', 'Yéssica Balaguer Chamorro', 'V-26154277', '0212-1098579', 'Av. Bolivar, Caracas', 'M', 'amoroseli@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C224', 'Feliciano Carreras Arévalo', 'V-22614977', '0416-4131900', 'Av. Bolivar, Caracas', 'F', 'gilsabater@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C225', 'Amanda Villalonga Aragonés', 'V-28464775', '0414-2112322', 'Calle 72, Maracaibo', 'F', 'adannorberto@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C226', 'Encarnita Molins Conde', 'V-20110970', '0412-3523906', 'Av. Lara, Barquisimeto', 'M', 'maxisalamanca@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C227', 'Alicia Jordana Mariño Casas', 'V-26836700', '0424-1788697', 'Av. Las Delicias, Maracay', 'M', 'teobaldogallardo@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C228', 'Soledad Rodriguez Arellano', 'V-9657883', '0416-3571601', 'Av. Bolivar, Caracas', 'M', 'cuetogaston@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C229', 'Eliana Contreras Casanova', 'V-30758581', '0414-9112830', 'Av. Francisco de Miranda, Caracas', 'M', 'lupitavilaplana@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C230', 'Perla Vilanova Requena', 'V-29093000', '0412-1686318', 'Av. Las Delicias, Maracay', 'F', 'ildefonsorobledo@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C231', 'Reinaldo Plana', 'V-9665623', '0416-7355573', 'Urb. El Trigal, Valencia', 'M', 'zacariasbonilla@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C232', 'Bernardita Gabaldón Narváez', 'V-26913431', '0424-3241014', 'Calle 72, Maracaibo', 'F', 'cadenasdanilo@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C233', 'Delfina Bernal', 'V-10545353', '0426-5363434', 'Av. Bolivar, Caracas', 'M', 'msantamaria@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C234', 'Alba Cuéllar', 'V-16597016', '0426-3532360', 'Av. Bolivar, Caracas', 'F', 'ocasanova@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C235', 'Renato Díez', 'V-9964013', '0426-8751956', 'Av. Bolivar, Caracas', 'M', 'maestreruben@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C236', 'Berta Andrade', 'V-13241365', '0416-5526349', 'Av. Francisco de Miranda, Caracas', 'M', 'emilianobayona@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C237', 'Jaime Suárez-Alberdi', 'V-21150415', '0416-4516138', 'Av. Lara, Barquisimeto', 'F', 'charo63@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C238', 'Gerónimo Jiménez-Alonso', 'V-5914866', '0426-4134075', 'Av. Lara, Barquisimeto', 'F', 'maria-del-carmen72@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C239', 'Artemio Pomares Caparrós', 'V-21020238', '0212-7324156', 'Av. Bolivar, Caracas', 'M', 'valerovalencia@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C240', 'Lucio del Marin', 'V-26284742', '0212-4855087', 'Urb. El Trigal, Valencia', 'M', 'benita18@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C241', 'Ariadna Anaya Busquets', 'V-22761281', '0412-6648390', 'Av. Francisco de Miranda, Caracas', 'M', 'marcosusana@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C242', 'Jose Miguel Cabello Fortuny', 'V-26298108', '0426-9166925', 'Calle 72, Maracaibo', 'F', 'prudencia56@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C243', 'Javi Cruz Salinas', 'V-19465965', '0414-4572184', 'Av. Lara, Barquisimeto', 'M', 'fidelaabril@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C244', 'Reynaldo Zabaleta Jáuregui', 'V-11643435', '0412-2875152', 'Calle 72, Maracaibo', 'F', 'amoresplinio@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C245', 'Marcelo Bayo Bou', 'V-9924967', '0424-3951017', 'Av. Bolivar, Caracas', 'F', 'aurelio83@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C246', 'Eladio Echeverría Echeverría', 'V-15164416', '0416-4295747', 'Calle 72, Maracaibo', 'F', 'emiliana82@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C247', 'Víctor Bertrán Villa', 'V-6013734', '0426-5000551', 'Av. Bolivar, Caracas', 'F', 'zacarias18@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C248', 'Rita Mora-Chamorro', 'V-19637576', '0416-8772553', 'Av. Francisco de Miranda, Caracas', 'M', 'demetrio60@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C249', 'Sandalio Vizcaíno Bravo', 'V-13948105', '0424-9825638', 'Av. Lara, Barquisimeto', 'F', 'erevilla@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C250', 'Lidia Galindo Rosselló', 'V-9543379', '0412-7974896', 'Av. Bolivar, Caracas', 'M', 'pazgala@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C251', 'Vicente Segismundo Daza Losada', 'V-26333814', '0426-9659326', 'Av. Lara, Barquisimeto', 'M', 'amadapintor@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C252', 'Mariano Herrera Boix', 'V-6482933', '0414-4368333', 'Calle 72, Maracaibo', 'F', 'uvillegas@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C253', 'Dionisio Leiva Muñoz', 'V-27965897', '0426-6832706', 'Av. Francisco de Miranda, Caracas', 'M', 'annacastello@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C254', 'Celestina Reyes', 'V-22962913', '0416-8627852', 'Calle 72, Maracaibo', 'M', 'gilabertmarcelino@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C255', 'Borja Garmendia Gonzalez', 'V-13508928', '0424-3609018', 'Calle 72, Maracaibo', 'F', 'hugo87@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C256', 'Hernando Rosado Mercader', 'V-29546906', '0424-1564945', 'Av. Francisco de Miranda, Caracas', 'F', 'zcalderon@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C257', 'Mamen Hervás Donaire', 'V-19839835', '0414-3863583', 'Av. Francisco de Miranda, Caracas', 'M', 'xavier46@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C258', 'Donato Montaña Cabello', 'V-6491342', '0426-1736647', 'Av. Las Delicias, Maracay', 'F', 'estebangil@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C259', 'Lucio Rovira', 'V-21465769', '0416-5568470', 'Av. Bolivar, Caracas', 'M', 'reymarita@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C260', 'Leandra Peñalver Elías', 'V-11319873', '0424-7292220', 'Av. Lara, Barquisimeto', 'M', 'silviagoni@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C261', 'Dorita Durán Valero', 'V-8819456', '0412-7892983', 'Av. Francisco de Miranda, Caracas', 'M', 'calixtasanz@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C262', 'Rosalina del Infante', 'V-19697248', '0412-7431264', 'Calle 72, Maracaibo', 'M', 'morenacorrea@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C263', 'Feliciana Llorens Torrents', 'V-26336434', '0426-5707485', 'Av. Las Delicias, Maracay', 'M', 'lupita77@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C264', 'Isidro Rómulo Vilalta Bonilla', 'V-11122805', '0412-1471326', 'Av. Bolivar, Caracas', 'F', 'emiliano69@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C265', 'Jonatan Sanz Iniesta', 'V-14444032', '0426-3308319', 'Av. Bolivar, Caracas', 'M', 'pastorgaliano@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C266', 'Febe Guillén Camacho', 'V-24559404', '0412-4747838', 'Av. Bolivar, Caracas', 'F', 'wsainz@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C267', 'Reyes Teo Sainz Amo', 'V-29085877', '0416-5338883', 'Urb. El Trigal, Valencia', 'M', 'falcazar@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C268', 'Juan Bautista Camino Pagès', 'V-12125954', '0414-5218207', 'Av. Las Delicias, Maracay', 'F', 'esperanza97@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C269', 'Carmen Vidal-Coloma', 'V-23142239', '0426-4545001', 'Urb. El Trigal, Valencia', 'M', 'violeta06@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C270', 'Lupe Hermenegildo Ortega Pastor', 'V-26413380', '0414-5179995', 'Urb. El Trigal, Valencia', 'F', 'renatamercader@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C271', 'Rafa Vallejo Hernández', 'V-9025952', '0424-7250537', 'Av. Francisco de Miranda, Caracas', 'M', 'pomaresvictor@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C272', 'Judith Cañete Valls', 'V-25652119', '0416-1215522', 'Av. Las Delicias, Maracay', 'M', 'anguitaperla@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C273', 'Noa Acuña Tomas', 'V-18816489', '0426-5296026', 'Av. Lara, Barquisimeto', 'M', 'wvillaverde@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C274', 'Sandalio Conde Rincón', 'V-23118782', '0424-9425952', 'Av. Francisco de Miranda, Caracas', 'F', 'liliapulido@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C275', 'Araceli del Porras', 'V-21167961', '0426-9361298', 'Av. Francisco de Miranda, Caracas', 'F', 'margarita77@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C276', 'Victoria Giménez Herrero', 'V-20987280', '0412-5797569', 'Av. Lara, Barquisimeto', 'M', 'scervantes@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C277', 'Onofre Adolfo Luque Toro', 'V-8301432', '0426-8742261', 'Av. Francisco de Miranda, Caracas', 'M', 'ncatalan@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C278', 'Fidel de Almagro', 'V-9364410', '0412-9037826', 'Calle 72, Maracaibo', 'M', 'pvazquez@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C279', 'Coral de Lladó', 'V-13984638', '0412-2989112', 'Urb. El Trigal, Valencia', 'M', 'lroyo@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C280', 'Vinicio Diéguez Bonet', 'V-28991667', '0414-5542941', 'Av. Bolivar, Caracas', 'F', 'zelias@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C281', 'Jesús Iborra Peral', 'V-25885508', '0424-1555765', 'Av. Bolivar, Caracas', 'M', 'gregorio08@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C282', 'Néstor Aramburu Catalá', 'V-9626750', '0424-3838894', 'Av. Francisco de Miranda, Caracas', 'F', 'amomiriam@example.com', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C283', 'Dorotea Royo Zaragoza', 'V-27401623', '0412-5028570', 'Av. Las Delicias, Maracay', 'F', 'coronadomarcelo@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C284', 'Marcio Menéndez Querol', 'V-8368348', '0414-7626128', 'Av. Francisco de Miranda, Caracas', 'F', 'tristansaez@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C285', 'Sandalio Godoy Peñas', 'V-5108852', '0212-9194653', 'Av. Lara, Barquisimeto', 'M', 'fabiola76@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C286', 'Segismundo Bermudez-Guijarro', 'V-28471280', '0212-7094626', 'Av. Bolivar, Caracas', 'F', 'tolosacasemiro@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C287', 'Fidela Martín Manzanares', 'V-23945574', '0426-3121193', 'Av. Las Delicias, Maracay', 'F', 'severo94@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C288', 'Ligia Amalia Espinosa Domingo', 'V-28324049', '0414-5538444', 'Urb. El Trigal, Valencia', 'F', 'baudeliogisbert@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C289', 'Poncio Segura Nogués', 'V-11080251', '0424-9353898', 'Calle 72, Maracaibo', 'M', 'escobarmanuel@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C290', 'Brígida Máxima Costa Arnaiz', 'V-16238264', '0424-2219808', 'Calle 72, Maracaibo', 'F', 'abadonofre@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C291', 'Nieves Rozas-Mulet', 'V-28491691', '0212-1761959', 'Av. Bolivar, Caracas', 'F', 'amarilis69@example.net', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C292', 'Sonia de Jordán', 'V-7590324', '0426-2935491', 'Av. Lara, Barquisimeto', 'M', 'belen33@example.com', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C293', 'Guadalupe Lamas Escribano', 'V-20814079', '0414-8651748', 'Urb. El Trigal, Valencia', 'M', 'agata04@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C294', 'Ramón del Cerdá', 'V-26675243', '0426-1517896', 'Av. Lara, Barquisimeto', 'F', 'maria-del-carmen68@example.net', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C295', 'Asunción Pareja Sobrino', 'V-19064275', '0212-4730308', 'Calle 72, Maracaibo', 'M', 'salomon74@example.org', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C296', 'Beatriz de Roda', 'V-7293658', '0416-5364713', 'Av. Las Delicias, Maracay', 'M', 'gangel@example.org', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C297', 'René Mateos Lobato', 'V-10099635', '0414-8263974', 'Av. Lara, Barquisimeto', 'F', 'hamores@example.org', 'SUC01');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C298', 'Macarena Zapata Garriga', 'V-9530408', '0424-3930121', 'Calle 72, Maracaibo', 'F', 'izaguirrechus@example.net', 'SUC03');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C299', 'Edelmira Octavia Neira Sotelo', 'V-11477151', '0212-6340360', 'Calle 72, Maracaibo', 'F', 'ignacia54@example.com', 'SUC02');
INSERT INTO CLIENTE (cod_cliente, nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES ('C300', 'Dorita Chacón Palau', 'V-14513362', '0416-3440247', 'Av. Francisco de Miranda, Caracas', 'M', 'gregorio75@example.net', 'SUC03');

-- 7. EVALUACION_SERVICIO
INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('E1', 'Malo');
INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('E2', 'Regular');
INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('E3', 'Bueno');
INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('E4', 'Muy Bueno');
INSERT INTO EVALUACION_SERVICIO (cod_evaluacion_servicio, nb_descripcion) VALUES ('E5', 'Excelente');

-- 8. RECOMIENDA
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C012', 'E1', 'P02', 'NO', '2026-01-11');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C083', 'E3', 'P02', 'SI', '2026-05-13');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C155', 'E5', 'P02', 'SI', '2025-10-08');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C244', 'E1', 'P01', 'NO', '2024-10-24');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C191', 'E5', 'P03', 'SI', '2024-08-06');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C183', 'E2', 'P03', 'NO', '2025-10-09');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C166', 'E5', 'P02', 'SI', '2026-04-07');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C024', 'E3', 'P01', 'SI', '2025-11-29');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C157', 'E1', 'P02', 'NO', '2024-12-09');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C057', 'E2', 'P02', 'NO', '2025-10-19');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C186', 'E2', 'P02', 'NO', '2025-12-16');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C249', 'E1', 'P02', 'NO', '2025-05-12');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C074', 'E1', 'P02', 'NO', '2025-02-14');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C295', 'E4', 'P01', 'SI', '2025-04-04');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C137', 'E4', 'P01', 'SI', '2026-02-15');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C154', 'E5', 'P01', 'SI', '2025-05-17');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C014', 'E2', 'P04', 'NO', '2026-06-30');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C025', 'E1', 'P03', 'NO', '2024-12-15');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C030', 'E3', 'P01', 'SI', '2025-01-01');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C017', 'E3', 'P01', 'SI', '2026-06-06');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C285', 'E1', 'P04', 'NO', '2026-05-24');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C292', 'E4', 'P01', 'SI', '2025-03-27');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C279', 'E5', 'P02', 'SI', '2026-03-07');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C260', 'E1', 'P02', 'NO', '2024-08-16');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C280', 'E5', 'P02', 'SI', '2026-03-10');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C069', 'E2', 'P03', 'NO', '2024-10-05');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C264', 'E4', 'P03', 'SI', '2025-05-03');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C008', 'E4', 'P02', 'SI', '2026-02-22');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C009', 'E3', 'P01', 'SI', '2025-05-20');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C058', 'E1', 'P02', 'NO', '2025-02-23');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C282', 'E3', 'P02', 'SI', '2025-04-14');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C214', 'E4', 'P01', 'SI', '2024-10-05');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C068', 'E1', 'P03', 'NO', '2025-08-21');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C236', 'E3', 'P03', 'SI', '2025-04-13');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C228', 'E2', 'P04', 'NO', '2025-07-21');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C099', 'E2', 'P01', 'NO', '2025-08-16');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C142', 'E5', 'P04', 'SI', '2025-01-25');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C270', 'E3', 'P04', 'SI', '2025-11-12');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C175', 'E2', 'P04', 'NO', '2025-01-08');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C077', 'E2', 'P02', 'NO', '2025-06-14');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C299', 'E4', 'P04', 'SI', '2025-09-06');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C195', 'E3', 'P01', 'SI', '2025-03-04');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C297', 'E3', 'P01', 'SI', '2024-08-15');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C061', 'E5', 'P02', 'SI', '2025-02-09');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C263', 'E2', 'P01', 'NO', '2024-07-31');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C197', 'E2', 'P04', 'NO', '2025-03-22');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C027', 'E2', 'P02', 'NO', '2025-11-09');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C084', 'E4', 'P02', 'SI', '2026-06-25');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C153', 'E4', 'P01', 'SI', '2026-01-19');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C108', 'E1', 'P03', 'NO', '2025-01-31');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C268', 'E5', 'P01', 'SI', '2026-04-15');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C079', 'E5', 'P04', 'SI', '2025-09-30');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C196', 'E3', 'P04', 'SI', '2024-09-11');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C172', 'E3', 'P03', 'SI', '2024-09-22');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C106', 'E2', 'P03', 'NO', '2025-05-30');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C122', 'E4', 'P03', 'SI', '2025-11-19');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C162', 'E5', 'P01', 'SI', '2026-03-09');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C051', 'E3', 'P03', 'SI', '2025-05-17');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C048', 'E3', 'P03', 'SI', '2026-02-28');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C223', 'E1', 'P03', 'NO', '2025-05-28');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C143', 'E2', 'P02', 'NO', '2025-05-02');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C159', 'E1', 'P01', 'NO', '2026-01-09');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C022', 'E5', 'P04', 'SI', '2025-07-08');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C185', 'E1', 'P01', 'NO', '2026-04-14');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C010', 'E1', 'P04', 'NO', '2026-03-02');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C217', 'E2', 'P03', 'NO', '2026-05-12');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C300', 'E3', 'P01', 'SI', '2025-04-25');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C102', 'E2', 'P04', 'NO', '2026-05-17');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C245', 'E2', 'P03', 'NO', '2026-04-23');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C052', 'E2', 'P04', 'NO', '2026-06-11');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C267', 'E2', 'P03', 'NO', '2026-05-30');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C023', 'E3', 'P02', 'SI', '2025-10-07');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C101', 'E2', 'P01', 'NO', '2025-08-16');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C085', 'E4', 'P04', 'SI', '2026-05-18');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C147', 'E4', 'P02', 'SI', '2025-06-26');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C284', 'E1', 'P02', 'NO', '2026-06-19');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C135', 'E1', 'P02', 'NO', '2024-10-21');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C097', 'E3', 'P03', 'SI', '2025-07-10');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C283', 'E3', 'P01', 'SI', '2026-03-20');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C002', 'E2', 'P02', 'NO', '2025-04-09');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C200', 'E1', 'P04', 'NO', '2026-04-19');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C231', 'E2', 'P04', 'NO', '2025-03-19');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C130', 'E2', 'P04', 'NO', '2024-07-11');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C243', 'E4', 'P02', 'SI', '2026-02-26');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C271', 'E4', 'P01', 'SI', '2025-05-04');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C235', 'E5', 'P03', 'SI', '2024-09-18');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C004', 'E5', 'P04', 'SI', '2026-06-08');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C215', 'E2', 'P03', 'NO', '2024-07-21');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C257', 'E5', 'P04', 'SI', '2024-09-23');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C126', 'E1', 'P02', 'NO', '2024-11-11');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C184', 'E1', 'P03', 'NO', '2026-01-09');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C001', 'E3', 'P03', 'SI', '2025-11-14');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C262', 'E1', 'P04', 'NO', '2025-07-02');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C220', 'E2', 'P04', 'NO', '2025-11-22');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C291', 'E4', 'P01', 'SI', '2025-02-14');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C103', 'E4', 'P02', 'SI', '2024-09-21');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C222', 'E5', 'P04', 'SI', '2026-03-16');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C296', 'E3', 'P02', 'SI', '2024-08-09');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C144', 'E4', 'P03', 'SI', '2025-10-20');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C148', 'E5', 'P02', 'SI', '2024-09-05');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C078', 'E3', 'P03', 'SI', '2025-06-09');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C146', 'E5', 'P04', 'SI', '2026-06-19');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C240', 'E2', 'P03', 'NO', '2025-06-26');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C204', 'E3', 'P01', 'SI', '2026-05-14');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C232', 'E5', 'P04', 'SI', '2025-10-22');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C237', 'E4', 'P04', 'SI', '2025-10-27');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C062', 'E1', 'P01', 'NO', '2025-12-20');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C226', 'E2', 'P04', 'NO', '2025-12-19');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C208', 'E1', 'P03', 'NO', '2024-09-17');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C192', 'E2', 'P01', 'NO', '2026-03-12');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C112', 'E5', 'P02', 'SI', '2025-02-19');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C189', 'E5', 'P04', 'SI', '2025-11-02');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C055', 'E5', 'P03', 'SI', '2026-03-25');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C178', 'E3', 'P02', 'SI', '2025-09-02');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C054', 'E3', 'P04', 'SI', '2026-02-27');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C253', 'E4', 'P04', 'SI', '2025-08-05');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C210', 'E3', 'P04', 'SI', '2025-05-14');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C098', 'E5', 'P01', 'SI', '2025-12-15');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C032', 'E3', 'P02', 'SI', '2025-04-08');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C275', 'E1', 'P01', 'NO', '2025-09-27');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C059', 'E2', 'P04', 'NO', '2026-01-20');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C193', 'E4', 'P02', 'SI', '2025-06-25');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C187', 'E4', 'P04', 'SI', '2025-10-10');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C219', 'E3', 'P04', 'SI', '2025-03-17');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C205', 'E5', 'P04', 'SI', '2026-02-17');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C011', 'E5', 'P03', 'SI', '2025-08-12');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C104', 'E4', 'P04', 'SI', '2025-08-08');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C180', 'E2', 'P02', 'NO', '2025-08-27');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C095', 'E5', 'P01', 'SI', '2025-08-30');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C119', 'E1', 'P04', 'NO', '2025-12-22');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C239', 'E1', 'P02', 'NO', '2026-06-11');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C209', 'E4', 'P03', 'SI', '2025-06-27');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C087', 'E4', 'P03', 'SI', '2025-02-02');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C167', 'E5', 'P04', 'SI', '2025-10-25');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C117', 'E2', 'P01', 'NO', '2024-11-08');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C045', 'E5', 'P04', 'SI', '2024-08-22');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C021', 'E4', 'P03', 'SI', '2024-07-28');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C086', 'E4', 'P04', 'SI', '2026-05-26');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C036', 'E1', 'P04', 'NO', '2025-08-29');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C238', 'E3', 'P01', 'SI', '2024-11-21');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C141', 'E2', 'P03', 'NO', '2024-12-14');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C273', 'E3', 'P01', 'SI', '2026-02-25');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C120', 'E5', 'P04', 'SI', '2025-03-11');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C151', 'E2', 'P01', 'NO', '2026-02-13');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C221', 'E3', 'P02', 'SI', '2025-07-03');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C050', 'E1', 'P03', 'NO', '2025-04-20');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C006', 'E3', 'P02', 'SI', '2025-10-25');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C225', 'E3', 'P03', 'SI', '2026-04-25');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C276', 'E5', 'P03', 'SI', '2024-11-24');
INSERT INTO RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_evaluacion) VALUES ('C111', 'E2', 'P02', 'NO', '2026-05-16');

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
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0151', 'Contrato de poliza 151 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0152', 'Contrato de poliza 152 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0153', 'Contrato de poliza 153 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0154', 'Contrato de poliza 154 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0155', 'Contrato de poliza 155 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0156', 'Contrato de poliza 156 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0157', 'Contrato de poliza 157 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0158', 'Contrato de poliza 158 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0159', 'Contrato de poliza 159 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0160', 'Contrato de poliza 160 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0161', 'Contrato de poliza 161 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0162', 'Contrato de poliza 162 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0163', 'Contrato de poliza 163 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0164', 'Contrato de poliza 164 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0165', 'Contrato de poliza 165 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0166', 'Contrato de poliza 166 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0167', 'Contrato de poliza 167 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0168', 'Contrato de poliza 168 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0169', 'Contrato de poliza 169 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0170', 'Contrato de poliza 170 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0171', 'Contrato de poliza 171 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0172', 'Contrato de poliza 172 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0173', 'Contrato de poliza 173 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0174', 'Contrato de poliza 174 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0175', 'Contrato de poliza 175 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0176', 'Contrato de poliza 176 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0177', 'Contrato de poliza 177 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0178', 'Contrato de poliza 178 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0179', 'Contrato de poliza 179 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0180', 'Contrato de poliza 180 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0181', 'Contrato de poliza 181 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0182', 'Contrato de poliza 182 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0183', 'Contrato de poliza 183 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0184', 'Contrato de poliza 184 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0185', 'Contrato de poliza 185 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0186', 'Contrato de poliza 186 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0187', 'Contrato de poliza 187 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0188', 'Contrato de poliza 188 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0189', 'Contrato de poliza 189 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0190', 'Contrato de poliza 190 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0191', 'Contrato de poliza 191 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0192', 'Contrato de poliza 192 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0193', 'Contrato de poliza 193 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0194', 'Contrato de poliza 194 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0195', 'Contrato de poliza 195 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0196', 'Contrato de poliza 196 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0197', 'Contrato de poliza 197 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0198', 'Contrato de poliza 198 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0199', 'Contrato de poliza 199 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0200', 'Contrato de poliza 200 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0201', 'Contrato de poliza 201 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0202', 'Contrato de poliza 202 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0203', 'Contrato de poliza 203 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0204', 'Contrato de poliza 204 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0205', 'Contrato de poliza 205 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0206', 'Contrato de poliza 206 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0207', 'Contrato de poliza 207 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0208', 'Contrato de poliza 208 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0209', 'Contrato de poliza 209 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0210', 'Contrato de poliza 210 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0211', 'Contrato de poliza 211 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0212', 'Contrato de poliza 212 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0213', 'Contrato de poliza 213 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0214', 'Contrato de poliza 214 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0215', 'Contrato de poliza 215 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0216', 'Contrato de poliza 216 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0217', 'Contrato de poliza 217 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0218', 'Contrato de poliza 218 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0219', 'Contrato de poliza 219 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0220', 'Contrato de poliza 220 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0221', 'Contrato de poliza 221 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0222', 'Contrato de poliza 222 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0223', 'Contrato de poliza 223 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0224', 'Contrato de poliza 224 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0225', 'Contrato de poliza 225 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0226', 'Contrato de poliza 226 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0227', 'Contrato de poliza 227 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0228', 'Contrato de poliza 228 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0229', 'Contrato de poliza 229 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0230', 'Contrato de poliza 230 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0231', 'Contrato de poliza 231 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0232', 'Contrato de poliza 232 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0233', 'Contrato de poliza 233 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0234', 'Contrato de poliza 234 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0235', 'Contrato de poliza 235 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0236', 'Contrato de poliza 236 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0237', 'Contrato de poliza 237 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0238', 'Contrato de poliza 238 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0239', 'Contrato de poliza 239 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0240', 'Contrato de poliza 240 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0241', 'Contrato de poliza 241 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0242', 'Contrato de poliza 242 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0243', 'Contrato de poliza 243 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0244', 'Contrato de poliza 244 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0245', 'Contrato de poliza 245 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0246', 'Contrato de poliza 246 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0247', 'Contrato de poliza 247 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0248', 'Contrato de poliza 248 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0249', 'Contrato de poliza 249 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0250', 'Contrato de poliza 250 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0251', 'Contrato de poliza 251 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0252', 'Contrato de poliza 252 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0253', 'Contrato de poliza 253 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0254', 'Contrato de poliza 254 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0255', 'Contrato de poliza 255 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0256', 'Contrato de poliza 256 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0257', 'Contrato de poliza 257 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0258', 'Contrato de poliza 258 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0259', 'Contrato de poliza 259 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0260', 'Contrato de poliza 260 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0261', 'Contrato de poliza 261 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0262', 'Contrato de poliza 262 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0263', 'Contrato de poliza 263 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0264', 'Contrato de poliza 264 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0265', 'Contrato de poliza 265 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0266', 'Contrato de poliza 266 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0267', 'Contrato de poliza 267 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0268', 'Contrato de poliza 268 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0269', 'Contrato de poliza 269 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0270', 'Contrato de poliza 270 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0271', 'Contrato de poliza 271 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0272', 'Contrato de poliza 272 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0273', 'Contrato de poliza 273 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0274', 'Contrato de poliza 274 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0275', 'Contrato de poliza 275 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0276', 'Contrato de poliza 276 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0277', 'Contrato de poliza 277 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0278', 'Contrato de poliza 278 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0279', 'Contrato de poliza 279 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0280', 'Contrato de poliza 280 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0281', 'Contrato de poliza 281 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0282', 'Contrato de poliza 282 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0283', 'Contrato de poliza 283 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0284', 'Contrato de poliza 284 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0285', 'Contrato de poliza 285 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0286', 'Contrato de poliza 286 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0287', 'Contrato de poliza 287 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0288', 'Contrato de poliza 288 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0289', 'Contrato de poliza 289 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0290', 'Contrato de poliza 290 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0291', 'Contrato de poliza 291 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0292', 'Contrato de poliza 292 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0293', 'Contrato de poliza 293 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0294', 'Contrato de poliza 294 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0295', 'Contrato de poliza 295 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0296', 'Contrato de poliza 296 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0297', 'Contrato de poliza 297 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0298', 'Contrato de poliza 298 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0299', 'Contrato de poliza 299 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0300', 'Contrato de poliza 300 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0301', 'Contrato de poliza 301 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0302', 'Contrato de poliza 302 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0303', 'Contrato de poliza 303 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0304', 'Contrato de poliza 304 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0305', 'Contrato de poliza 305 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0306', 'Contrato de poliza 306 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0307', 'Contrato de poliza 307 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0308', 'Contrato de poliza 308 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0309', 'Contrato de poliza 309 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0310', 'Contrato de poliza 310 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0311', 'Contrato de poliza 311 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0312', 'Contrato de poliza 312 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0313', 'Contrato de poliza 313 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0314', 'Contrato de poliza 314 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0315', 'Contrato de poliza 315 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0316', 'Contrato de poliza 316 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0317', 'Contrato de poliza 317 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0318', 'Contrato de poliza 318 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0319', 'Contrato de poliza 319 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0320', 'Contrato de poliza 320 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0321', 'Contrato de poliza 321 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0322', 'Contrato de poliza 322 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0323', 'Contrato de poliza 323 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0324', 'Contrato de poliza 324 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0325', 'Contrato de poliza 325 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0326', 'Contrato de poliza 326 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0327', 'Contrato de poliza 327 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0328', 'Contrato de poliza 328 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0329', 'Contrato de poliza 329 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0330', 'Contrato de poliza 330 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0331', 'Contrato de poliza 331 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0332', 'Contrato de poliza 332 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0333', 'Contrato de poliza 333 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0334', 'Contrato de poliza 334 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0335', 'Contrato de poliza 335 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0336', 'Contrato de poliza 336 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0337', 'Contrato de poliza 337 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0338', 'Contrato de poliza 338 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0339', 'Contrato de poliza 339 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0340', 'Contrato de poliza 340 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0341', 'Contrato de poliza 341 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0342', 'Contrato de poliza 342 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0343', 'Contrato de poliza 343 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0344', 'Contrato de poliza 344 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0345', 'Contrato de poliza 345 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0346', 'Contrato de poliza 346 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0347', 'Contrato de poliza 347 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0348', 'Contrato de poliza 348 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0349', 'Contrato de poliza 349 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0350', 'Contrato de poliza 350 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0351', 'Contrato de poliza 351 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0352', 'Contrato de poliza 352 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0353', 'Contrato de poliza 353 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0354', 'Contrato de poliza 354 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0355', 'Contrato de poliza 355 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0356', 'Contrato de poliza 356 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0357', 'Contrato de poliza 357 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0358', 'Contrato de poliza 358 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0359', 'Contrato de poliza 359 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0360', 'Contrato de poliza 360 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0361', 'Contrato de poliza 361 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0362', 'Contrato de poliza 362 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0363', 'Contrato de poliza 363 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0364', 'Contrato de poliza 364 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0365', 'Contrato de poliza 365 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0366', 'Contrato de poliza 366 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0367', 'Contrato de poliza 367 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0368', 'Contrato de poliza 368 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0369', 'Contrato de poliza 369 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0370', 'Contrato de poliza 370 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0371', 'Contrato de poliza 371 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0372', 'Contrato de poliza 372 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0373', 'Contrato de poliza 373 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0374', 'Contrato de poliza 374 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0375', 'Contrato de poliza 375 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0376', 'Contrato de poliza 376 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0377', 'Contrato de poliza 377 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0378', 'Contrato de poliza 378 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0379', 'Contrato de poliza 379 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0380', 'Contrato de poliza 380 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0381', 'Contrato de poliza 381 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0382', 'Contrato de poliza 382 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0383', 'Contrato de poliza 383 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0384', 'Contrato de poliza 384 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0385', 'Contrato de poliza 385 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0386', 'Contrato de poliza 386 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0387', 'Contrato de poliza 387 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0388', 'Contrato de poliza 388 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0389', 'Contrato de poliza 389 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0390', 'Contrato de poliza 390 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0391', 'Contrato de poliza 391 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0392', 'Contrato de poliza 392 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0393', 'Contrato de poliza 393 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0394', 'Contrato de poliza 394 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0395', 'Contrato de poliza 395 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0396', 'Contrato de poliza 396 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0397', 'Contrato de poliza 397 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0398', 'Contrato de poliza 398 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0399', 'Contrato de poliza 399 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0400', 'Contrato de poliza 400 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0401', 'Contrato de poliza 401 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0402', 'Contrato de poliza 402 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0403', 'Contrato de poliza 403 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0404', 'Contrato de poliza 404 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0405', 'Contrato de poliza 405 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0406', 'Contrato de poliza 406 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0407', 'Contrato de poliza 407 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0408', 'Contrato de poliza 408 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0409', 'Contrato de poliza 409 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0410', 'Contrato de poliza 410 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0411', 'Contrato de poliza 411 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0412', 'Contrato de poliza 412 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0413', 'Contrato de poliza 413 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0414', 'Contrato de poliza 414 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0415', 'Contrato de poliza 415 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0416', 'Contrato de poliza 416 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0417', 'Contrato de poliza 417 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0418', 'Contrato de poliza 418 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0419', 'Contrato de poliza 419 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0420', 'Contrato de poliza 420 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0421', 'Contrato de poliza 421 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0422', 'Contrato de poliza 422 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0423', 'Contrato de poliza 423 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0424', 'Contrato de poliza 424 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0425', 'Contrato de poliza 425 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0426', 'Contrato de poliza 426 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0427', 'Contrato de poliza 427 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0428', 'Contrato de poliza 428 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0429', 'Contrato de poliza 429 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0430', 'Contrato de poliza 430 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0431', 'Contrato de poliza 431 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0432', 'Contrato de poliza 432 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0433', 'Contrato de poliza 433 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0434', 'Contrato de poliza 434 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0435', 'Contrato de poliza 435 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0436', 'Contrato de poliza 436 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0437', 'Contrato de poliza 437 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0438', 'Contrato de poliza 438 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0439', 'Contrato de poliza 439 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0440', 'Contrato de poliza 440 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0441', 'Contrato de poliza 441 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0442', 'Contrato de poliza 442 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0443', 'Contrato de poliza 443 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0444', 'Contrato de poliza 444 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0445', 'Contrato de poliza 445 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0446', 'Contrato de poliza 446 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0447', 'Contrato de poliza 447 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0448', 'Contrato de poliza 448 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0449', 'Contrato de poliza 449 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0450', 'Contrato de poliza 450 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0451', 'Contrato de poliza 451 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0452', 'Contrato de poliza 452 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0453', 'Contrato de poliza 453 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0454', 'Contrato de poliza 454 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0455', 'Contrato de poliza 455 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0456', 'Contrato de poliza 456 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0457', 'Contrato de poliza 457 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0458', 'Contrato de poliza 458 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0459', 'Contrato de poliza 459 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0460', 'Contrato de poliza 460 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0461', 'Contrato de poliza 461 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0462', 'Contrato de poliza 462 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0463', 'Contrato de poliza 463 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0464', 'Contrato de poliza 464 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0465', 'Contrato de poliza 465 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0466', 'Contrato de poliza 466 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0467', 'Contrato de poliza 467 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0468', 'Contrato de poliza 468 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0469', 'Contrato de poliza 469 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0470', 'Contrato de poliza 470 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0471', 'Contrato de poliza 471 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0472', 'Contrato de poliza 472 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0473', 'Contrato de poliza 473 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0474', 'Contrato de poliza 474 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0475', 'Contrato de poliza 475 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0476', 'Contrato de poliza 476 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0477', 'Contrato de poliza 477 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0478', 'Contrato de poliza 478 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0479', 'Contrato de poliza 479 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0480', 'Contrato de poliza 480 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0481', 'Contrato de poliza 481 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0482', 'Contrato de poliza 482 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0483', 'Contrato de poliza 483 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0484', 'Contrato de poliza 484 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0485', 'Contrato de poliza 485 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0486', 'Contrato de poliza 486 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0487', 'Contrato de poliza 487 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0488', 'Contrato de poliza 488 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0489', 'Contrato de poliza 489 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0490', 'Contrato de poliza 490 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0491', 'Contrato de poliza 491 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0492', 'Contrato de poliza 492 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0493', 'Contrato de poliza 493 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0494', 'Contrato de poliza 494 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0495', 'Contrato de poliza 495 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0496', 'Contrato de poliza 496 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0497', 'Contrato de poliza 497 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0498', 'Contrato de poliza 498 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0499', 'Contrato de poliza 499 para asegurado');
INSERT INTO CONTRATO (nro_contrato, descrip_contrato) VALUES ('CT-0500', 'Contrato de poliza 500 para asegurado');

-- 10. REGISTRO_CONTRATO
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0001', 'P02', 'C026', '2023-02-02', '2024-02-02', 2099.91, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0002', 'P01', 'C041', '2024-10-10', '2025-10-10', 2264.23, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0003', 'P02', 'C079', '2024-06-16', '2025-06-16', 1274.0, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0004', 'P02', 'C062', '2025-11-05', '2026-11-05', 1104.48, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0005', 'P02', 'C152', '2024-11-11', '2025-11-11', 376.47, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0006', 'P02', 'C276', '2024-07-28', '2025-07-28', 170.82, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0007', 'P03', 'C262', '2025-10-29', '2026-10-29', 1471.56, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0008', 'P03', 'C259', '2026-02-04', '2027-02-04', 2420.3, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0009', 'P01', 'C034', '2025-01-15', '2026-01-15', 369.64, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0010', 'P04', 'C245', '2025-02-04', '2026-02-04', 1000.2, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0011', 'P01', 'C179', '2024-05-07', '2025-05-07', 206.46, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0012', 'P04', 'C039', '2024-12-05', '2025-12-05', 1922.25, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0013', 'P03', 'C022', '2024-10-11', '2025-10-11', 1172.28, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0014', 'P01', 'C065', '2026-03-16', '2027-03-16', 292.4, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0015', 'P03', 'C291', '2025-04-13', '2026-04-13', 2375.16, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0016', 'P03', 'C075', '2023-07-11', '2024-07-10', 1945.63, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0017', 'P04', 'C135', '2026-05-15', '2027-05-15', 387.94, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0018', 'P04', 'C172', '2025-03-06', '2026-03-06', 1321.11, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0019', 'P02', 'C161', '2023-10-31', '2024-10-30', 1255.78, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0020', 'P04', 'C059', '2026-08-01', '2027-08-01', 201.37, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0021', 'P03', 'C264', '2026-04-27', '2027-04-27', 1450.5, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0022', 'P02', 'C150', '2025-06-12', '2026-06-12', 1868.66, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0023', 'P03', 'C233', '2026-11-29', '2027-11-29', 1068.96, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0024', 'P02', 'C093', '2026-12-07', '2027-12-07', 738.67, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0025', 'P03', 'C096', '2025-03-20', '2026-03-20', 1541.23, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0026', 'P03', 'C025', '2024-11-07', '2025-11-07', 1411.01, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0027', 'P04', 'C100', '2026-04-07', '2027-04-07', 2043.85, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0028', 'P04', 'C179', '2023-07-29', '2024-07-28', 443.19, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0029', 'P04', 'C294', '2023-10-19', '2024-10-18', 1634.34, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0030', 'P01', 'C176', '2024-03-17', '2025-03-17', 2287.04, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0031', 'P01', 'C162', '2023-03-15', '2024-03-14', 1962.78, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0032', 'P02', 'C244', '2023-12-28', '2024-12-27', 469.56, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0033', 'P04', 'C143', '2024-01-19', '2025-01-18', 176.13, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0034', 'P04', 'C265', '2025-09-13', '2026-09-13', 273.61, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0035', 'P04', 'C063', '2026-12-30', '2027-12-30', 1523.05, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0036', 'P01', 'C127', '2025-09-05', '2026-09-05', 1459.8, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0037', 'P04', 'C104', '2023-10-12', '2024-10-11', 2259.13, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0038', 'P01', 'C128', '2025-01-01', '2026-01-01', 2383.39, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0039', 'P04', 'C290', '2024-10-15', '2025-10-15', 1223.79, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0040', 'P03', 'C113', '2024-11-24', '2025-11-24', 1174.36, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0041', 'P04', 'C225', '2025-10-12', '2026-10-12', 1857.78, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0042', 'P02', 'C105', '2025-09-23', '2026-09-23', 1432.27, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0043', 'P04', 'C279', '2025-04-12', '2026-04-12', 371.25, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0044', 'P01', 'C141', '2023-01-14', '2024-01-14', 1119.54, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0045', 'P02', 'C203', '2023-10-16', '2024-10-15', 1854.9, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0046', 'P02', 'C096', '2023-08-25', '2024-08-24', 2422.03, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0047', 'P02', 'C211', '2023-11-14', '2024-11-13', 1328.46, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0048', 'P01', 'C159', '2026-03-02', '2027-03-02', 1331.86, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0049', 'P03', 'C145', '2023-08-22', '2024-08-21', 1802.43, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0050', 'P02', 'C152', '2026-07-20', '2027-07-20', 2240.54, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0051', 'P02', 'C093', '2025-01-05', '2026-01-05', 1088.66, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0052', 'P02', 'C004', '2024-06-08', '2025-06-08', 935.35, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0053', 'P03', 'C226', '2026-11-20', '2027-11-20', 1295.68, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0054', 'P03', 'C127', '2023-04-22', '2024-04-21', 1877.26, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0055', 'P01', 'C144', '2024-02-04', '2025-02-03', 1942.38, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0056', 'P03', 'C140', '2024-04-15', '2025-04-15', 944.96, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0057', 'P03', 'C195', '2024-12-19', '2025-12-19', 1676.66, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0058', 'P04', 'C187', '2023-06-29', '2024-06-28', 1178.73, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0059', 'P02', 'C251', '2024-10-08', '2025-10-08', 1938.22, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0060', 'P01', 'C165', '2023-02-05', '2024-02-05', 2402.03, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0061', 'P03', 'C175', '2026-07-21', '2027-07-21', 2229.45, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0062', 'P04', 'C215', '2025-06-30', '2026-06-30', 2422.99, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0063', 'P02', 'C094', '2026-05-26', '2027-05-26', 991.72, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0064', 'P03', 'C244', '2025-06-16', '2026-06-16', 256.41, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0065', 'P01', 'C090', '2023-09-22', '2024-09-21', 2062.16, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0066', 'P02', 'C149', '2026-02-01', '2027-02-01', 1388.75, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0067', 'P02', 'C094', '2026-07-20', '2027-07-20', 743.92, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0068', 'P04', 'C113', '2025-01-28', '2026-01-28', 475.91, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0069', 'P02', 'C243', '2026-10-01', '2027-10-01', 834.97, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0070', 'P02', 'C067', '2023-06-10', '2024-06-09', 2360.29, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0071', 'P02', 'C281', '2025-03-02', '2026-03-02', 992.73, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0072', 'P04', 'C067', '2026-06-17', '2027-06-17', 843.84, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0073', 'P02', 'C096', '2023-06-13', '2024-06-12', 1124.37, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0074', 'P03', 'C173', '2025-03-22', '2026-03-22', 1149.92, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0075', 'P02', 'C216', '2025-05-13', '2026-05-13', 242.34, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0076', 'P03', 'C179', '2023-07-19', '2024-07-18', 619.63, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0077', 'P01', 'C063', '2024-12-31', '2025-12-31', 1206.2, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0078', 'P04', 'C150', '2023-06-20', '2024-06-19', 609.96, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0079', 'P02', 'C109', '2025-08-04', '2026-08-04', 1678.91, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0080', 'P03', 'C016', '2024-07-01', '2025-07-01', 1043.82, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0081', 'P04', 'C224', '2025-01-27', '2026-01-27', 1755.48, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0082', 'P02', 'C014', '2026-05-01', '2027-05-01', 196.2, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0083', 'P03', 'C246', '2023-01-17', '2024-01-17', 911.82, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0084', 'P03', 'C070', '2024-03-22', '2025-03-22', 1035.0, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0085', 'P01', 'C213', '2026-04-27', '2027-04-27', 193.22, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0086', 'P03', 'C037', '2024-06-21', '2025-06-21', 2349.37, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0087', 'P02', 'C117', '2024-06-19', '2025-06-19', 2232.76, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0088', 'P02', 'C038', '2023-02-04', '2024-02-04', 721.37, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0089', 'P03', 'C004', '2026-03-17', '2027-03-17', 204.43, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0090', 'P03', 'C120', '2023-09-17', '2024-09-16', 256.8, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0091', 'P04', 'C072', '2025-08-09', '2026-08-09', 162.13, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0092', 'P01', 'C243', '2026-04-08', '2027-04-08', 1498.5, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0093', 'P04', 'C179', '2025-10-18', '2026-10-18', 1490.62, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0094', 'P03', 'C033', '2023-03-25', '2024-03-24', 1350.22, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0095', 'P01', 'C293', '2025-07-16', '2026-07-16', 2061.5, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0096', 'P03', 'C188', '2023-06-22', '2024-06-21', 2048.62, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0097', 'P01', 'C105', '2024-04-19', '2025-04-19', 231.68, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0098', 'P04', 'C223', '2025-08-12', '2026-08-12', 723.85, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0099', 'P04', 'C009', '2026-04-15', '2027-04-15', 2135.31, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0100', 'P04', 'C061', '2025-10-10', '2026-10-10', 1230.42, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0101', 'P02', 'C011', '2025-12-28', '2026-12-28', 1984.66, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0102', 'P03', 'C120', '2026-12-19', '2027-12-19', 1810.19, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0103', 'P02', 'C247', '2025-05-01', '2026-05-01', 801.16, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0104', 'P01', 'C216', '2026-10-28', '2027-10-28', 1089.86, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0105', 'P04', 'C233', '2026-02-09', '2027-02-09', 2089.64, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0106', 'P01', 'C196', '2024-12-16', '2025-12-16', 257.23, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0107', 'P03', 'C005', '2023-06-02', '2024-06-01', 2182.28, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0108', 'P04', 'C295', '2023-03-19', '2024-03-18', 828.92, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0109', 'P03', 'C093', '2023-03-27', '2024-03-26', 544.76, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0110', 'P02', 'C117', '2026-04-03', '2027-04-03', 1981.17, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0111', 'P02', 'C210', '2025-07-05', '2026-07-05', 2097.36, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0112', 'P04', 'C207', '2024-12-11', '2025-12-11', 1589.33, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0113', 'P04', 'C297', '2025-04-26', '2026-04-26', 1459.19, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0114', 'P02', 'C259', '2026-07-08', '2027-07-08', 884.66, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0115', 'P01', 'C227', '2024-12-24', '2025-12-24', 987.41, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0116', 'P03', 'C063', '2023-02-21', '2024-02-21', 223.5, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0117', 'P02', 'C190', '2023-06-30', '2024-06-29', 628.02, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0118', 'P02', 'C055', '2025-09-03', '2026-09-03', 700.93, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0119', 'P02', 'C166', '2025-05-21', '2026-05-21', 1995.26, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0120', 'P04', 'C153', '2026-10-11', '2027-10-11', 2059.69, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0121', 'P03', 'C112', '2024-01-20', '2025-01-19', 166.1, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0122', 'P03', 'C168', '2023-08-02', '2024-08-01', 2385.47, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0123', 'P04', 'C061', '2026-12-17', '2027-12-17', 303.11, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0124', 'P04', 'C039', '2024-08-29', '2025-08-29', 550.38, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0125', 'P01', 'C005', '2026-02-03', '2027-02-03', 2095.56, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0126', 'P02', 'C232', '2025-08-19', '2026-08-19', 2135.87, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0127', 'P02', 'C222', '2023-08-29', '2024-08-28', 2159.21, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0128', 'P01', 'C146', '2024-09-23', '2025-09-23', 2478.89, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0129', 'P04', 'C014', '2023-06-08', '2024-06-07', 1980.03, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0130', 'P04', 'C067', '2023-04-05', '2024-04-04', 1112.29, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0131', 'P04', 'C023', '2024-09-03', '2025-09-03', 420.11, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0132', 'P04', 'C053', '2024-03-03', '2025-03-03', 2447.29, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0133', 'P03', 'C049', '2025-11-23', '2026-11-23', 1170.49, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0134', 'P01', 'C043', '2024-04-07', '2025-04-07', 2407.36, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0135', 'P02', 'C008', '2024-07-03', '2025-07-03', 171.16, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0136', 'P03', 'C075', '2024-03-07', '2025-03-07', 1787.27, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0137', 'P04', 'C139', '2025-01-03', '2026-01-03', 1552.19, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0138', 'P04', 'C075', '2024-08-06', '2025-08-06', 1282.61, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0139', 'P02', 'C257', '2024-04-27', '2025-04-27', 946.15, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0140', 'P03', 'C130', '2026-09-07', '2027-09-07', 1863.11, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0141', 'P02', 'C171', '2024-01-21', '2025-01-20', 1915.69, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0142', 'P04', 'C271', '2023-05-13', '2024-05-12', 618.39, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0143', 'P01', 'C013', '2026-04-02', '2027-04-02', 172.87, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0144', 'P03', 'C136', '2023-09-03', '2024-09-02', 2345.69, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0145', 'P03', 'C044', '2023-01-19', '2024-01-19', 736.05, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0146', 'P04', 'C203', '2024-02-19', '2025-02-18', 554.69, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0147', 'P04', 'C233', '2023-02-28', '2024-02-28', 1430.32, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0148', 'P01', 'C290', '2024-07-29', '2025-07-29', 2422.14, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0149', 'P02', 'C156', '2026-01-08', '2027-01-08', 1471.41, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0150', 'P01', 'C204', '2024-10-04', '2025-10-04', 2095.35, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0151', 'P04', 'C048', '2024-06-04', '2025-06-04', 895.59, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0152', 'P04', 'C037', '2023-12-25', '2024-12-24', 1720.8, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0153', 'P04', 'C269', '2024-04-21', '2025-04-21', 846.95, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0154', 'P01', 'C127', '2025-02-03', '2026-02-03', 199.12, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0155', 'P03', 'C300', '2023-11-13', '2024-11-12', 539.66, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0156', 'P02', 'C058', '2025-01-09', '2026-01-09', 1610.76, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0157', 'P04', 'C097', '2023-02-27', '2024-02-27', 2324.3, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0158', 'P01', 'C220', '2023-05-09', '2024-05-08', 1379.68, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0159', 'P04', 'C249', '2024-07-31', '2025-07-31', 1041.84, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0160', 'P01', 'C155', '2026-08-26', '2027-08-26', 1269.55, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0161', 'P01', 'C021', '2026-10-07', '2027-10-07', 919.28, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0162', 'P01', 'C054', '2024-06-02', '2025-06-02', 284.29, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0163', 'P02', 'C109', '2026-03-30', '2027-03-30', 1777.11, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0164', 'P03', 'C296', '2024-11-23', '2025-11-23', 2143.06, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0165', 'P01', 'C019', '2026-01-05', '2027-01-05', 2390.34, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0166', 'P02', 'C052', '2024-09-14', '2025-09-14', 2415.26, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0167', 'P04', 'C031', '2025-07-05', '2026-07-05', 1744.24, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0168', 'P02', 'C269', '2026-07-19', '2027-07-19', 1019.27, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0169', 'P02', 'C280', '2023-09-01', '2024-08-31', 1839.32, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0170', 'P04', 'C114', '2025-10-02', '2026-10-02', 999.13, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0171', 'P03', 'C058', '2023-01-08', '2024-01-08', 829.51, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0172', 'P04', 'C064', '2026-08-02', '2027-08-02', 1734.81, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0173', 'P01', 'C097', '2024-03-09', '2025-03-09', 630.3, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0174', 'P03', 'C080', '2023-12-08', '2024-12-07', 971.6, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0175', 'P04', 'C265', '2026-07-31', '2027-07-31', 1264.97, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0176', 'P03', 'C148', '2025-05-01', '2026-05-01', 1338.52, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0177', 'P04', 'C200', '2023-04-04', '2024-04-03', 1042.32, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0178', 'P01', 'C294', '2024-01-02', '2025-01-01', 1919.73, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0179', 'P04', 'C117', '2025-07-27', '2026-07-27', 1939.81, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0180', 'P01', 'C241', '2023-05-05', '2024-05-04', 1728.49, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0181', 'P02', 'C117', '2025-01-21', '2026-01-21', 967.02, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0182', 'P03', 'C279', '2025-05-19', '2026-05-19', 1493.13, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0183', 'P02', 'C164', '2024-12-26', '2025-12-26', 525.9, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0184', 'P04', 'C134', '2026-12-10', '2027-12-10', 1713.75, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0185', 'P03', 'C159', '2024-04-24', '2025-04-24', 2350.03, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0186', 'P01', 'C058', '2026-08-26', '2027-08-26', 1111.36, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0187', 'P02', 'C214', '2023-11-19', '2024-11-18', 789.0, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0188', 'P03', 'C135', '2024-03-15', '2025-03-15', 1170.64, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0189', 'P04', 'C060', '2024-08-02', '2025-08-02', 855.71, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0190', 'P02', 'C258', '2026-05-12', '2027-05-12', 885.81, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0191', 'P02', 'C048', '2026-06-12', '2027-06-12', 294.04, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0192', 'P02', 'C117', '2026-07-09', '2027-07-09', 1476.47, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0193', 'P04', 'C197', '2025-09-11', '2026-09-11', 1008.45, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0194', 'P03', 'C045', '2023-01-06', '2024-01-06', 2411.39, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0195', 'P03', 'C258', '2026-12-18', '2027-12-18', 1259.87, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0196', 'P03', 'C067', '2025-07-16', '2026-07-16', 701.14, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0197', 'P04', 'C205', '2024-10-13', '2025-10-13', 731.64, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0198', 'P01', 'C266', '2024-03-15', '2025-03-15', 1897.98, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0199', 'P02', 'C138', '2026-08-25', '2027-08-25', 649.83, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0200', 'P03', 'C034', '2026-10-30', '2027-10-30', 1794.15, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0201', 'P04', 'C136', '2026-12-22', '2027-12-22', 1089.46, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0202', 'P03', 'C227', '2025-12-05', '2026-12-05', 382.96, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0203', 'P02', 'C110', '2025-10-21', '2026-10-21', 2417.38, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0204', 'P02', 'C051', '2026-09-12', '2027-09-12', 406.57, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0205', 'P04', 'C280', '2025-01-20', '2026-01-20', 1688.42, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0206', 'P01', 'C195', '2025-04-08', '2026-04-08', 1312.32, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0207', 'P02', 'C107', '2023-01-11', '2024-01-11', 357.59, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0208', 'P01', 'C288', '2025-02-19', '2026-02-19', 1522.22, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0209', 'P01', 'C159', '2025-12-11', '2026-12-11', 2379.99, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0210', 'P01', 'C105', '2024-11-21', '2025-11-21', 1018.23, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0211', 'P01', 'C290', '2025-04-12', '2026-04-12', 872.18, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0212', 'P04', 'C103', '2025-07-16', '2026-07-16', 2189.24, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0213', 'P04', 'C189', '2023-03-15', '2024-03-14', 671.75, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0214', 'P01', 'C169', '2024-05-23', '2025-05-23', 2299.46, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0215', 'P03', 'C046', '2025-08-19', '2026-08-19', 2379.55, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0216', 'P01', 'C245', '2024-06-05', '2025-06-05', 1004.43, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0217', 'P01', 'C220', '2025-07-28', '2026-07-28', 390.7, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0218', 'P02', 'C157', '2023-09-25', '2024-09-24', 1913.8, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0219', 'P03', 'C185', '2025-08-06', '2026-08-06', 776.77, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0220', 'P01', 'C052', '2025-01-01', '2026-01-01', 216.88, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0221', 'P03', 'C194', '2023-11-11', '2024-11-10', 715.03, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0222', 'P04', 'C037', '2025-07-21', '2026-07-21', 2033.26, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0223', 'P04', 'C062', '2026-09-16', '2027-09-16', 1529.96, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0224', 'P01', 'C243', '2026-11-30', '2027-11-30', 862.23, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0225', 'P01', 'C203', '2023-01-09', '2024-01-09', 1854.03, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0226', 'P03', 'C154', '2025-08-28', '2026-08-28', 580.31, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0227', 'P01', 'C060', '2025-05-30', '2026-05-30', 273.41, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0228', 'P02', 'C023', '2026-05-03', '2027-05-03', 217.58, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0229', 'P01', 'C286', '2025-03-28', '2026-03-28', 2283.01, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0230', 'P04', 'C169', '2023-02-15', '2024-02-15', 381.5, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0231', 'P03', 'C195', '2023-12-08', '2024-12-07', 1961.53, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0232', 'P02', 'C280', '2026-09-24', '2027-09-24', 361.64, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0233', 'P04', 'C158', '2025-05-09', '2026-05-09', 957.68, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0234', 'P02', 'C073', '2026-04-07', '2027-04-07', 1833.65, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0235', 'P01', 'C069', '2024-08-05', '2025-08-05', 1978.44, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0236', 'P04', 'C097', '2023-01-14', '2024-01-14', 1424.2, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0237', 'P02', 'C239', '2023-12-03', '2024-12-02', 1304.84, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0238', 'P01', 'C204', '2024-02-01', '2025-01-31', 1877.71, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0239', 'P01', 'C046', '2023-02-16', '2024-02-16', 1676.5, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0240', 'P02', 'C257', '2026-01-27', '2027-01-27', 1552.21, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0241', 'P03', 'C179', '2023-08-21', '2024-08-20', 942.09, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0242', 'P03', 'C154', '2024-10-13', '2025-10-13', 369.83, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0243', 'P03', 'C292', '2026-01-03', '2027-01-03', 1792.64, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0244', 'P02', 'C031', '2026-06-28', '2027-06-28', 1462.14, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0245', 'P01', 'C102', '2026-07-28', '2027-07-28', 1078.25, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0246', 'P03', 'C247', '2024-05-08', '2025-05-08', 2200.74, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0247', 'P02', 'C061', '2025-04-18', '2026-04-18', 2051.23, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0248', 'P01', 'C265', '2024-05-20', '2025-05-20', 2179.56, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0249', 'P01', 'C207', '2023-09-07', '2024-09-06', 271.72, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0250', 'P02', 'C005', '2024-01-01', '2024-12-31', 747.88, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0251', 'P03', 'C269', '2023-04-20', '2024-04-19', 872.06, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0252', 'P04', 'C159', '2025-04-12', '2026-04-12', 807.05, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0253', 'P01', 'C042', '2026-01-28', '2027-01-28', 2058.18, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0254', 'P04', 'C092', '2025-03-01', '2026-03-01', 544.24, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0255', 'P01', 'C015', '2025-03-17', '2026-03-17', 945.5, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0256', 'P03', 'C060', '2026-07-28', '2027-07-28', 2148.81, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0257', 'P04', 'C231', '2023-02-05', '2024-02-05', 366.24, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0258', 'P01', 'C008', '2026-02-13', '2027-02-13', 1396.33, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0259', 'P04', 'C036', '2023-10-21', '2024-10-20', 2337.33, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0260', 'P01', 'C124', '2026-12-18', '2027-12-18', 1652.65, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0261', 'P03', 'C150', '2024-04-19', '2025-04-19', 2480.42, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0262', 'P01', 'C269', '2026-03-27', '2027-03-27', 424.3, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0263', 'P03', 'C151', '2024-11-25', '2025-11-25', 1528.77, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0264', 'P03', 'C160', '2025-08-13', '2026-08-13', 471.06, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0265', 'P04', 'C061', '2026-09-01', '2027-09-01', 1406.07, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0266', 'P02', 'C096', '2024-01-31', '2025-01-30', 274.22, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0267', 'P01', 'C257', '2026-01-16', '2027-01-16', 650.39, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0268', 'P04', 'C162', '2023-03-17', '2024-03-16', 189.85, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0269', 'P01', 'C149', '2026-07-24', '2027-07-24', 167.62, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0270', 'P04', 'C199', '2024-07-19', '2025-07-19', 688.21, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0271', 'P04', 'C007', '2025-01-07', '2026-01-07', 788.7, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0272', 'P01', 'C050', '2024-11-07', '2025-11-07', 560.37, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0273', 'P02', 'C159', '2024-09-08', '2025-09-08', 1415.42, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0274', 'P04', 'C028', '2025-12-13', '2026-12-13', 211.17, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0275', 'P01', 'C175', '2023-08-21', '2024-08-20', 2214.75, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0276', 'P04', 'C168', '2025-05-01', '2026-05-01', 606.93, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0277', 'P04', 'C056', '2024-10-05', '2025-10-05', 1982.94, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0278', 'P03', 'C261', '2024-03-02', '2025-03-02', 1957.25, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0279', 'P03', 'C156', '2023-09-13', '2024-09-12', 629.04, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0280', 'P03', 'C156', '2025-03-20', '2026-03-20', 1901.37, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0281', 'P01', 'C268', '2025-12-19', '2026-12-19', 193.82, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0282', 'P02', 'C227', '2023-10-11', '2024-10-10', 359.34, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0283', 'P01', 'C173', '2025-01-06', '2026-01-06', 1914.51, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0284', 'P04', 'C147', '2026-02-09', '2027-02-09', 1746.86, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0285', 'P02', 'C186', '2023-03-15', '2024-03-14', 747.68, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0286', 'P04', 'C269', '2026-06-23', '2027-06-23', 943.29, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0287', 'P04', 'C202', '2025-07-12', '2026-07-12', 641.02, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0288', 'P01', 'C175', '2024-03-22', '2025-03-22', 1539.77, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0289', 'P01', 'C295', '2025-02-01', '2026-02-01', 978.46, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0290', 'P01', 'C030', '2025-01-06', '2026-01-06', 1461.4, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0291', 'P03', 'C266', '2024-06-14', '2025-06-14', 237.15, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0292', 'P01', 'C171', '2025-07-08', '2026-07-08', 2365.32, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0293', 'P03', 'C125', '2024-08-22', '2025-08-22', 642.07, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0294', 'P04', 'C055', '2025-06-26', '2026-06-26', 2122.73, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0295', 'P03', 'C120', '2025-10-26', '2026-10-26', 2125.15, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0296', 'P01', 'C084', '2024-04-03', '2025-04-03', 1278.92, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0297', 'P04', 'C224', '2026-08-13', '2027-08-13', 734.36, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0298', 'P03', 'C265', '2025-12-19', '2026-12-19', 604.87, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0299', 'P04', 'C259', '2023-09-12', '2024-09-11', 847.69, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0300', 'P04', 'C284', '2023-06-28', '2024-06-27', 2235.14, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0301', 'P02', 'C294', '2024-11-13', '2025-11-13', 1814.09, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0302', 'P03', 'C147', '2024-08-28', '2025-08-28', 992.34, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0303', 'P03', 'C203', '2026-02-22', '2027-02-22', 1548.43, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0304', 'P04', 'C093', '2024-11-11', '2025-11-11', 2408.99, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0305', 'P04', 'C205', '2025-07-31', '2026-07-31', 1126.87, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0306', 'P03', 'C257', '2023-06-21', '2024-06-20', 1220.54, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0307', 'P04', 'C164', '2026-03-04', '2027-03-04', 2480.28, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0308', 'P04', 'C064', '2023-01-14', '2024-01-14', 853.89, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0309', 'P01', 'C200', '2026-09-25', '2027-09-25', 901.44, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0310', 'P02', 'C270', '2026-09-09', '2027-09-09', 465.77, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0311', 'P03', 'C232', '2023-09-24', '2024-09-23', 589.89, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0312', 'P02', 'C155', '2026-01-08', '2027-01-08', 1641.86, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0313', 'P01', 'C090', '2025-06-03', '2026-06-03', 1894.37, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0314', 'P02', 'C011', '2024-09-03', '2025-09-03', 415.17, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0315', 'P01', 'C241', '2023-04-12', '2024-04-11', 1638.82, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0316', 'P04', 'C102', '2025-11-12', '2026-11-12', 695.74, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0317', 'P02', 'C067', '2024-12-09', '2025-12-09', 1635.93, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0318', 'P04', 'C064', '2025-04-14', '2026-04-14', 2185.79, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0319', 'P02', 'C242', '2024-03-23', '2025-03-23', 1233.96, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0320', 'P01', 'C096', '2026-04-26', '2027-04-26', 1963.64, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0321', 'P04', 'C245', '2025-11-09', '2026-11-09', 1373.07, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0322', 'P03', 'C272', '2025-02-05', '2026-02-05', 2155.41, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0323', 'P01', 'C232', '2023-08-29', '2024-08-28', 929.21, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0324', 'P04', 'C195', '2025-03-03', '2026-03-03', 520.31, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0325', 'P04', 'C290', '2023-07-29', '2024-07-28', 738.05, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0326', 'P04', 'C248', '2026-09-13', '2027-09-13', 296.24, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0327', 'P03', 'C044', '2025-09-04', '2026-09-04', 1837.18, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0328', 'P03', 'C289', '2026-06-21', '2027-06-21', 1457.51, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0329', 'P03', 'C019', '2023-07-29', '2024-07-28', 1792.42, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0330', 'P03', 'C281', '2026-12-19', '2027-12-19', 310.1, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0331', 'P01', 'C104', '2025-02-12', '2026-02-12', 1490.37, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0332', 'P02', 'C051', '2025-03-04', '2026-03-04', 1080.42, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0333', 'P01', 'C232', '2023-01-03', '2024-01-03', 1816.64, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0334', 'P02', 'C178', '2023-08-24', '2024-08-23', 2331.33, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0335', 'P04', 'C245', '2024-06-03', '2025-06-03', 1504.95, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0336', 'P02', 'C027', '2023-01-24', '2024-01-24', 308.96, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0337', 'P04', 'C256', '2026-05-14', '2027-05-14', 992.95, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0338', 'P04', 'C048', '2024-10-30', '2025-10-30', 1047.05, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0339', 'P02', 'C065', '2025-05-05', '2026-05-05', 2398.61, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0340', 'P01', 'C238', '2024-11-03', '2025-11-03', 725.68, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0341', 'P02', 'C056', '2025-07-27', '2026-07-27', 2181.84, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0342', 'P01', 'C157', '2025-08-16', '2026-08-16', 1774.07, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0343', 'P01', 'C187', '2024-07-03', '2025-07-03', 645.79, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0344', 'P03', 'C246', '2023-08-11', '2024-08-10', 867.8, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0345', 'P02', 'C024', '2024-12-19', '2025-12-19', 167.98, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0346', 'P03', 'C198', '2024-03-10', '2025-03-10', 1267.6, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0347', 'P04', 'C043', '2024-05-31', '2025-05-31', 2446.23, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0348', 'P04', 'C062', '2024-04-03', '2025-04-03', 1751.67, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0349', 'P02', 'C033', '2025-03-24', '2026-03-24', 838.28, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0350', 'P01', 'C247', '2025-05-19', '2026-05-19', 1894.76, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0351', 'P01', 'C146', '2024-08-13', '2025-08-13', 486.53, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0352', 'P02', 'C099', '2026-03-17', '2027-03-17', 1275.08, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0353', 'P03', 'C005', '2024-12-20', '2025-12-20', 1492.77, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0354', 'P04', 'C111', '2026-09-11', '2027-09-11', 972.27, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0355', 'P02', 'C005', '2024-08-02', '2025-08-02', 1420.72, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0356', 'P03', 'C190', '2026-01-10', '2027-01-10', 1661.62, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0357', 'P04', 'C017', '2023-06-10', '2024-06-09', 1752.26, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0358', 'P01', 'C053', '2026-03-20', '2027-03-20', 1623.65, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0359', 'P02', 'C271', '2026-12-11', '2027-12-11', 829.09, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0360', 'P01', 'C099', '2025-06-05', '2026-06-05', 1926.15, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0361', 'P01', 'C205', '2026-09-25', '2027-09-25', 819.27, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0362', 'P03', 'C070', '2023-09-15', '2024-09-14', 1167.76, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0363', 'P01', 'C263', '2024-01-18', '2025-01-17', 2139.89, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0364', 'P01', 'C020', '2026-12-14', '2027-12-14', 1457.24, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0365', 'P03', 'C008', '2026-04-12', '2027-04-12', 1850.09, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0366', 'P03', 'C121', '2024-07-04', '2025-07-04', 1369.0, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0367', 'P04', 'C094', '2026-11-17', '2027-11-17', 1093.62, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0368', 'P03', 'C167', '2024-12-18', '2025-12-18', 1511.15, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0369', 'P04', 'C012', '2024-06-17', '2025-06-17', 2481.66, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0370', 'P02', 'C075', '2023-06-07', '2024-06-06', 1190.15, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0371', 'P02', 'C095', '2023-10-09', '2024-10-08', 1020.39, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0372', 'P03', 'C178', '2025-10-15', '2026-10-15', 792.4, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0373', 'P04', 'C134', '2023-05-05', '2024-05-04', 2109.7, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0374', 'P02', 'C132', '2024-01-10', '2025-01-09', 1531.78, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0375', 'P02', 'C132', '2024-04-25', '2025-04-25', 810.36, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0376', 'P01', 'C270', '2026-08-24', '2027-08-24', 1978.17, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0377', 'P02', 'C037', '2024-10-05', '2025-10-05', 1012.51, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0378', 'P04', 'C062', '2023-12-12', '2024-12-11', 279.16, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0379', 'P01', 'C065', '2024-02-22', '2025-02-21', 1442.94, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0380', 'P01', 'C054', '2025-01-05', '2026-01-05', 2212.92, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0381', 'P03', 'C040', '2025-09-21', '2026-09-21', 335.8, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0382', 'P04', 'C100', '2024-10-19', '2025-10-19', 713.26, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0383', 'P01', 'C007', '2025-08-09', '2026-08-09', 1029.47, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0384', 'P01', 'C172', '2025-12-03', '2026-12-03', 2405.99, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0385', 'P03', 'C047', '2026-08-13', '2027-08-13', 1336.07, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0386', 'P03', 'C102', '2024-12-04', '2025-12-04', 663.7, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0387', 'P03', 'C034', '2025-04-12', '2026-04-12', 2223.22, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0388', 'P04', 'C134', '2023-01-22', '2024-01-22', 2255.48, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0389', 'P03', 'C031', '2026-08-11', '2027-08-11', 1619.34, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0390', 'P03', 'C117', '2023-12-30', '2024-12-29', 2105.9, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0391', 'P02', 'C291', '2024-09-03', '2025-09-03', 2307.3, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0392', 'P04', 'C033', '2025-06-19', '2026-06-19', 2222.92, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0393', 'P01', 'C032', '2023-06-27', '2024-06-26', 2028.55, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0394', 'P02', 'C208', '2023-11-22', '2024-11-21', 795.14, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0395', 'P01', 'C185', '2024-04-30', '2025-04-30', 1823.64, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0396', 'P04', 'C040', '2024-04-10', '2025-04-10', 1341.07, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0397', 'P02', 'C157', '2026-10-14', '2027-10-14', 1478.27, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0398', 'P01', 'C030', '2026-09-05', '2027-09-05', 964.26, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0399', 'P04', 'C137', '2026-12-05', '2027-12-05', 2191.96, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0400', 'P03', 'C036', '2025-11-25', '2026-11-25', 1290.63, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0401', 'P02', 'C199', '2024-01-03', '2025-01-02', 1383.12, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0402', 'P03', 'C103', '2023-07-02', '2024-07-01', 2356.69, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0403', 'P03', 'C039', '2023-06-27', '2024-06-26', 1683.62, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0404', 'P04', 'C256', '2025-10-22', '2026-10-22', 852.24, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0405', 'P02', 'C021', '2025-03-28', '2026-03-28', 385.45, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0406', 'P01', 'C132', '2023-07-19', '2024-07-18', 781.4, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0407', 'P01', 'C269', '2024-07-19', '2025-07-19', 1249.01, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0408', 'P02', 'C145', '2024-02-01', '2025-01-31', 2206.39, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0409', 'P02', 'C041', '2023-09-12', '2024-09-11', 1618.34, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0410', 'P04', 'C137', '2023-10-21', '2024-10-20', 177.1, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0411', 'P04', 'C056', '2026-06-29', '2027-06-29', 369.11, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0412', 'P01', 'C272', '2024-06-22', '2025-06-22', 806.45, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0413', 'P03', 'C082', '2025-06-12', '2026-06-12', 1311.96, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0414', 'P04', 'C265', '2025-12-06', '2026-12-06', 1255.93, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0415', 'P04', 'C297', '2026-03-02', '2027-03-02', 1173.78, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0416', 'P02', 'C125', '2025-07-01', '2026-07-01', 1220.26, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0417', 'P01', 'C131', '2023-03-10', '2024-03-09', 792.88, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0418', 'P03', 'C143', '2026-06-04', '2027-06-04', 1153.14, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0419', 'P02', 'C119', '2025-01-20', '2026-01-20', 349.33, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0420', 'P03', 'C173', '2024-10-05', '2025-10-05', 1351.13, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0421', 'P01', 'C263', '2025-07-24', '2026-07-24', 1659.63, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0422', 'P04', 'C115', '2026-10-06', '2027-10-06', 1529.7, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0423', 'P04', 'C295', '2026-04-19', '2027-04-19', 516.1, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0424', 'P02', 'C154', '2025-07-02', '2026-07-02', 1064.74, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0425', 'P03', 'C110', '2023-08-23', '2024-08-22', 2494.92, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0426', 'P03', 'C028', '2025-09-06', '2026-09-06', 610.2, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0427', 'P04', 'C013', '2025-01-08', '2026-01-08', 1910.04, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0428', 'P03', 'C013', '2023-12-05', '2024-12-04', 1701.34, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0429', 'P03', 'C021', '2023-04-23', '2024-04-22', 1527.6, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0430', 'P04', 'C021', '2024-02-20', '2025-02-19', 2097.64, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0431', 'P03', 'C235', '2023-01-24', '2024-01-24', 573.37, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0432', 'P03', 'C017', '2024-08-15', '2025-08-15', 2312.25, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0433', 'P01', 'C019', '2025-02-02', '2026-02-02', 1958.31, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0434', 'P01', 'C223', '2023-11-20', '2024-11-19', 2072.58, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0435', 'P02', 'C099', '2026-01-26', '2027-01-26', 2223.79, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0436', 'P02', 'C161', '2023-10-29', '2024-10-28', 1486.7, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0437', 'P03', 'C134', '2025-04-13', '2026-04-13', 1660.48, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0438', 'P01', 'C062', '2026-07-18', '2027-07-18', 463.19, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0439', 'P01', 'C266', '2025-04-29', '2026-04-29', 886.91, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0440', 'P01', 'C036', '2026-12-10', '2027-12-10', 672.56, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0441', 'P01', 'C157', '2024-03-24', '2025-03-24', 751.85, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0442', 'P01', 'C181', '2025-11-17', '2026-11-17', 1403.13, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0443', 'P02', 'C085', '2025-10-25', '2026-10-25', 2159.12, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0444', 'P01', 'C122', '2023-03-20', '2024-03-19', 783.2, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0445', 'P04', 'C179', '2024-04-19', '2025-04-19', 1664.41, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0446', 'P02', 'C068', '2025-09-28', '2026-09-28', 1310.23, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0447', 'P04', 'C241', '2023-01-24', '2024-01-24', 736.16, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0448', 'P01', 'C234', '2023-01-19', '2024-01-19', 2422.67, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0449', 'P01', 'C220', '2026-02-28', '2027-02-28', 2388.67, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0450', 'P03', 'C164', '2025-10-10', '2026-10-10', 1964.07, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0451', 'P02', 'C142', '2025-12-18', '2026-12-18', 2094.91, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0452', 'P04', 'C115', '2024-09-04', '2025-09-04', 483.61, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0453', 'P01', 'C264', '2024-07-29', '2025-07-29', 1933.4, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0454', 'P02', 'C091', '2026-01-22', '2027-01-22', 1859.06, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0455', 'P04', 'C118', '2023-10-19', '2024-10-18', 339.27, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0456', 'P03', 'C168', '2023-02-02', '2024-02-02', 698.54, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0457', 'P04', 'C103', '2026-07-19', '2027-07-19', 467.36, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0458', 'P03', 'C051', '2026-04-24', '2027-04-24', 499.18, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0459', 'P03', 'C240', '2026-02-19', '2027-02-19', 2118.43, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0460', 'P03', 'C206', '2024-08-16', '2025-08-16', 1107.81, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0461', 'P01', 'C038', '2024-11-09', '2025-11-09', 1614.57, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0462', 'P02', 'C140', '2025-05-27', '2026-05-27', 821.09, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0463', 'P03', 'C184', '2024-07-11', '2025-07-11', 559.35, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0464', 'P04', 'C030', '2023-03-26', '2024-03-25', 466.05, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0465', 'P01', 'C201', '2026-03-02', '2027-03-02', 2294.76, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0466', 'P03', 'C103', '2024-02-23', '2025-02-22', 837.38, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0467', 'P03', 'C082', '2024-02-01', '2025-01-31', 247.56, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0468', 'P02', 'C196', '2023-10-15', '2024-10-14', 2031.42, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0469', 'P03', 'C221', '2026-07-30', '2027-07-30', 2002.14, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0470', 'P04', 'C078', '2025-02-03', '2026-02-03', 1745.96, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0471', 'P04', 'C023', '2026-05-13', '2027-05-13', 1835.47, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0472', 'P01', 'C173', '2026-08-28', '2027-08-28', 1635.53, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0473', 'P02', 'C085', '2024-05-10', '2025-05-10', 448.26, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0474', 'P02', 'C107', '2026-06-14', '2027-06-14', 697.83, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0475', 'P03', 'C298', '2023-07-26', '2024-07-25', 1124.5, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0476', 'P04', 'C041', '2025-11-07', '2026-11-07', 2209.61, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0477', 'P01', 'C068', '2026-07-17', '2027-07-17', 653.78, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0478', 'P01', 'C266', '2026-05-21', '2027-05-21', 1081.6, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0479', 'P02', 'C215', '2026-09-20', '2027-09-20', 2213.72, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0480', 'P01', 'C092', '2023-02-09', '2024-02-09', 231.63, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0481', 'P03', 'C224', '2023-04-19', '2024-04-18', 1899.89, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0482', 'P02', 'C166', '2025-07-06', '2026-07-06', 904.3, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0483', 'P01', 'C029', '2024-06-15', '2025-06-15', 281.91, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0484', 'P03', 'C056', '2025-10-11', '2026-10-11', 649.91, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0485', 'P01', 'C020', '2025-12-09', '2026-12-09', 1373.39, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0486', 'P02', 'C274', '2023-09-28', '2024-09-27', 921.91, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0487', 'P04', 'C111', '2024-08-29', '2025-08-29', 562.14, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0488', 'P03', 'C247', '2026-07-29', '2027-07-29', 2023.69, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0489', 'P04', 'C034', '2026-02-02', '2027-02-02', 2271.75, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0490', 'P04', 'C210', '2023-09-22', '2024-09-21', 1679.97, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0491', 'P02', 'C284', '2023-02-07', '2024-02-07', 2488.98, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0492', 'P02', 'C255', '2025-07-13', '2026-07-13', 1267.32, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0493', 'P03', 'C086', '2026-11-20', '2027-11-20', 939.58, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0494', 'P04', 'C076', '2024-02-06', '2025-02-05', 1156.67, 'activo');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0495', 'P02', 'C286', '2023-08-30', '2024-08-29', 2197.14, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0496', 'P02', 'C003', '2024-11-29', '2025-11-29', 1381.66, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0497', 'P01', 'C055', '2025-11-18', '2026-11-18', 2283.98, 'suspendido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0498', 'P03', 'C058', '2025-09-26', '2026-09-26', 1219.78, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0499', 'P04', 'C005', '2025-12-20', '2026-12-20', 1739.48, 'vencido');
INSERT INTO REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, estado_contrato) VALUES ('CT-0500', 'P04', 'C058', '2024-09-30', '2025-09-30', 1595.61, 'activo');

-- 11. SINIESTRO
INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('SIN-01', 'Choque vehicular');
INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('SIN-02', 'Robo de vehiculo');
INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('SIN-03', 'Emergencia medica general');
INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('SIN-04', 'Incendio estructural leve');
INSERT INTO SINIESTRO (nro_siniestro, descripcion_siniestro) VALUES ('SIN-05', 'Dano por agua en vivienda');

-- 12. REGISTRO_SINIESTRO
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0417', '2023-09-06', '2023-09-14', 'SI', 0.0, 574.51);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0358', '2026-04-22', '2026-05-10', 'SI', 0.0, 511.99);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0261', '2024-05-09', '2024-06-01', 'SI', 0.0, 3230.56);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0001', '2023-11-13', '2023-11-18', 'NO', 1579.64, 1579.64);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0207', '2023-05-11', '2023-05-31', 'NO', 4653.14, 4653.14);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0107', '2024-01-14', '2024-02-07', 'SI', 0.0, 4418.22);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0435', '2026-11-10', '2026-11-12', 'NO', 4945.82, 4945.82);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0235', '2024-09-10', '2024-09-20', 'SI', 0.0, 4697.77);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0088', '2023-03-20', '2023-04-12', 'SI', 0.0, 1173.36);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0361', '2027-02-17', '2027-02-24', 'SI', 0.0, 2683.39);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0468', '2024-04-23', '2024-05-15', 'SI', 0.0, 3116.93);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0268', '2023-12-05', '2023-12-14', 'SI', 0.0, 2327.83);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0118', '2026-03-03', '2026-03-16', 'NO', 1698.46, 1698.46);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0297', '2026-12-13', '2026-12-26', 'SI', 0.0, 4598.51);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0489', '2026-11-05', '2026-11-23', 'NO', 2548.94, 2548.94);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0109', '2023-07-16', '2023-08-02', 'NO', 137.82, 137.82);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0190', '2026-06-09', '2026-06-22', 'NO', 2918.38, 2918.38);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0069', '2027-02-12', '2027-03-02', 'NO', 1745.23, 1745.23);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0248', '2024-08-13', '2024-08-22', 'SI', 0.0, 3659.86);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0422', '2027-07-18', '2027-07-22', 'SI', 0.0, 3102.14);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0095', '2026-03-26', '2026-04-14', 'SI', 0.0, 1205.6);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0333', '2023-05-25', '2023-06-07', 'SI', 0.0, 1509.56);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0174', '2024-09-11', '2024-10-06', 'SI', 0.0, 1526.66);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0040', '2025-08-14', '2025-08-24', 'NO', 3598.53, 3598.53);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0106', '2025-02-22', '2025-03-14', 'NO', 2539.59, 2539.59);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0253', '2026-11-24', '2026-12-14', 'NO', 307.38, 307.38);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0311', '2024-02-16', '2024-03-15', 'NO', 4320.92, 4320.92);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0247', '2025-09-19', '2025-10-09', 'SI', 0.0, 4909.08);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0474', '2027-03-16', '2027-04-02', 'SI', 0.0, 1682.37);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0055', '2024-09-01', '2024-09-14', 'NO', 3868.51, 3868.51);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0346', '2024-08-25', '2024-09-01', 'SI', 0.0, 2719.4);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0050', '2027-03-11', '2027-03-26', 'NO', 2225.16, 2225.16);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0463', '2024-09-02', '2024-09-22', 'SI', 0.0, 782.84);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0459', '2026-04-22', '2026-04-24', 'SI', 0.0, 1795.1);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0187', '2024-07-31', '2024-08-27', 'SI', 0.0, 3189.52);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0110', '2026-10-03', '2026-10-26', 'SI', 0.0, 662.42);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0438', '2026-10-18', '2026-11-05', 'SI', 0.0, 4064.81);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0180', '2024-01-22', '2024-02-12', 'SI', 0.0, 823.06);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0191', '2026-08-04', '2026-08-27', 'NO', 4408.55, 4408.55);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0028', '2023-10-10', '2023-10-13', 'SI', 0.0, 2529.65);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0100', '2025-12-07', '2025-12-14', 'NO', 921.41, 921.41);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0313', '2025-07-29', '2025-08-02', 'NO', 4825.24, 4825.24);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0407', '2025-03-05', '2025-03-15', 'NO', 4879.0, 4879.0);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0359', '2027-02-25', '2027-03-14', 'NO', 855.24, 855.24);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0481', '2024-01-12', '2024-02-06', 'SI', 0.0, 1627.51);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0194', '2023-02-18', '2023-03-05', 'SI', 0.0, 4094.73);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0302', '2025-04-26', '2025-04-29', 'NO', 1458.73, 1458.73);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0043', '2025-07-06', '2025-07-21', 'NO', 2139.66, 2139.66);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0077', '2025-10-10', '2025-10-15', 'SI', 0.0, 4735.07);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0316', '2026-04-13', '2026-05-05', 'SI', 0.0, 3449.22);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0096', '2023-11-08', '2023-12-06', 'SI', 0.0, 1740.04);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0495', '2024-04-15', '2024-05-05', 'NO', 954.63, 954.63);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0271', '2025-03-15', '2025-04-08', 'NO', 4973.81, 4973.81);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0293', '2024-10-05', '2024-10-08', 'NO', 2359.59, 2359.59);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0243', '2026-04-14', '2026-05-02', 'NO', 1014.88, 1014.88);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0398', '2027-05-26', '2027-05-30', 'SI', 0.0, 551.42);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0383', '2026-01-05', '2026-02-03', 'NO', 295.19, 295.19);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0105', '2026-12-01', '2026-12-30', 'SI', 0.0, 2625.75);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0484', '2026-01-22', '2026-02-06', 'SI', 0.0, 324.47);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0465', '2026-04-14', '2026-05-10', 'SI', 0.0, 3989.08);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0152', '2024-01-30', '2024-02-13', 'SI', 0.0, 2705.94);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0283', '2025-07-14', '2025-08-10', 'SI', 0.0, 762.72);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0164', '2025-05-05', '2025-05-07', 'NO', 3821.04, 3821.04);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0491', '2023-11-08', '2023-12-02', 'SI', 0.0, 3081.45);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0227', '2026-03-24', '2026-04-23', 'NO', 2700.77, 2700.77);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0034', '2026-02-01', '2026-02-21', 'SI', 0.0, 765.76);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0288', '2024-07-03', '2024-07-30', 'NO', 2287.79, 2287.79);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0246', '2024-07-08', '2024-08-03', 'NO', 1488.89, 1488.89);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0282', '2024-06-04', '2024-06-15', 'NO', 1174.5, 1174.5);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0012', '2025-02-09', '2025-03-05', 'SI', 0.0, 717.55);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0409', '2024-01-31', '2024-02-14', 'SI', 0.0, 2154.6);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0170', '2025-10-18', '2025-11-11', 'SI', 0.0, 3730.41);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0212', '2026-03-12', '2026-03-18', 'SI', 0.0, 4607.65);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0027', '2026-08-14', '2026-09-04', 'NO', 1406.35, 1406.35);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0113', '2025-12-10', '2025-12-27', 'SI', 0.0, 330.43);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0181', '2025-09-19', '2025-10-10', 'SI', 0.0, 2038.17);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0047', '2024-04-09', '2024-05-09', 'NO', 3804.48, 3804.48);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0205', '2025-10-14', '2025-10-23', 'NO', 213.51, 213.51);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0240', '2026-11-01', '2026-11-13', 'SI', 0.0, 4494.8);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0101', '2026-10-24', '2026-11-05', 'SI', 0.0, 4299.33);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0323', '2024-02-27', '2024-03-01', 'NO', 4763.41, 4763.41);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0470', '2025-08-29', '2025-09-20', 'NO', 1447.73, 1447.73);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0192', '2026-09-12', '2026-10-07', 'NO', 2942.09, 2942.09);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0433', '2025-08-26', '2025-09-24', 'SI', 0.0, 1488.67);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0173', '2024-04-07', '2024-04-09', 'SI', 0.0, 826.78);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0486', '2024-03-29', '2024-04-13', 'SI', 0.0, 3494.79);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0184', '2027-07-26', '2027-08-03', 'SI', 0.0, 874.23);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0154', '2025-06-27', '2025-07-19', 'SI', 0.0, 774.87);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0075', '2025-06-07', '2025-06-27', 'SI', 0.0, 2614.21);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0065', '2024-02-28', '2024-03-27', 'NO', 242.38, 242.38);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0498', '2026-05-11', '2026-05-22', 'SI', 0.0, 1424.4);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0466', '2024-09-12', '2024-10-06', 'NO', 4242.06, 4242.06);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0335', '2024-09-13', '2024-10-13', 'NO', 4717.96, 4717.96);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0140', '2027-06-01', '2027-06-17', 'NO', 2366.44, 2366.44);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0478', '2026-06-11', '2026-07-05', 'NO', 2697.94, 2697.94);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0056', '2024-05-17', '2024-06-04', 'NO', 1168.34, 1168.34);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0356', '2026-09-14', '2026-10-02', 'NO', 2373.57, 2373.57);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0295', '2026-07-18', '2026-07-29', 'NO', 301.66, 301.66);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0111', '2025-08-22', '2025-09-08', 'NO', 4270.78, 4270.78);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0203', '2025-12-06', '2025-12-21', 'SI', 0.0, 3401.73);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0475', '2024-03-11', '2024-03-29', 'SI', 0.0, 4839.73);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0467', '2024-05-27', '2024-06-20', 'SI', 0.0, 1274.14);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0023', '2027-05-23', '2027-05-29', 'SI', 0.0, 3878.54);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0461', '2025-03-20', '2025-04-17', 'SI', 0.0, 4862.73);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0252', '2025-05-25', '2025-06-01', 'SI', 0.0, 1861.48);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0117', '2023-11-14', '2023-11-26', 'NO', 1288.76, 1288.76);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0021', '2026-07-14', '2026-07-22', 'NO', 3209.82, 3209.82);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0344', '2024-05-29', '2024-06-01', 'SI', 0.0, 3028.12);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0238', '2024-04-11', '2024-04-28', 'NO', 436.66, 436.66);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0198', '2024-05-14', '2024-06-03', 'NO', 2447.54, 2447.54);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0397', '2027-04-21', '2027-05-02', 'SI', 0.0, 1624.31);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0133', '2026-01-16', '2026-01-27', 'SI', 0.0, 2512.64);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0442', '2026-09-09', '2026-10-04', 'NO', 4819.31, 4819.31);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0048', '2026-09-29', '2026-10-16', 'SI', 0.0, 2694.67);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0328', '2027-04-02', '2027-04-11', 'NO', 3480.62, 3480.62);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0366', '2024-12-16', '2025-01-09', 'SI', 0.0, 974.51);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0444', '2024-01-14', '2024-01-17', 'SI', 0.0, 983.75);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0115', '2025-04-20', '2025-05-09', 'NO', 323.04, 323.04);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0010', '2025-10-17', '2025-10-24', 'NO', 3504.55, 3504.55);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0308', '2023-07-29', '2023-08-17', 'SI', 0.0, 1551.25);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0357', '2023-07-20', '2023-08-01', 'SI', 0.0, 2579.74);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0082', '2026-07-30', '2026-08-11', 'NO', 2337.15, 2337.15);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0352', '2026-07-16', '2026-08-06', 'SI', 0.0, 4945.6);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0391', '2024-12-17', '2025-01-15', 'SI', 0.0, 3833.26);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0147', '2023-09-29', '2023-10-26', 'SI', 0.0, 4338.07);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0123', '2027-04-30', '2027-05-09', 'NO', 4479.92, 4479.92);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0427', '2025-08-14', '2025-08-28', 'NO', 2890.29, 2890.29);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0159', '2024-11-30', '2024-12-30', 'NO', 1215.29, 1215.29);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0084', '2024-05-18', '2024-06-12', 'NO', 349.75, 349.75);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0440', '2027-09-01', '2027-09-24', 'SI', 0.0, 2030.27);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0222', '2025-10-04', '2025-10-28', 'NO', 1810.19, 1810.19);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0497', '2026-08-24', '2026-09-02', 'SI', 0.0, 504.55);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0156', '2025-10-21', '2025-10-27', 'SI', 0.0, 4849.23);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0225', '2023-10-01', '2023-10-23', 'SI', 0.0, 3281.7);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0137', '2025-10-04', '2025-10-22', 'NO', 3223.13, 3223.13);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0064', '2026-04-01', '2026-04-30', 'NO', 4660.64, 4660.64);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-04', 'CT-0428', '2024-09-10', '2024-10-10', 'SI', 0.0, 1292.87);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0033', '2024-10-28', '2024-11-07', 'SI', 0.0, 1169.11);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0161', '2027-06-19', '2027-06-21', 'NO', 1987.14, 1987.14);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0131', '2025-01-29', '2025-02-23', 'NO', 1550.24, 1550.24);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0322', '2025-08-28', '2025-08-30', 'SI', 0.0, 2818.27);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-01', 'CT-0421', '2026-04-07', '2026-04-22', 'SI', 0.0, 1233.85);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0373', '2024-01-02', '2024-01-11', 'NO', 4387.36, 4387.36);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0098', '2026-01-14', '2026-01-25', 'SI', 0.0, 1541.38);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-05', 'CT-0092', '2026-09-06', '2026-09-21', 'SI', 0.0, 1276.84);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0015', '2025-07-25', '2025-08-06', 'SI', 0.0, 4268.49);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0160', '2027-05-19', '2027-06-15', 'NO', 1882.76, 1882.76);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0451', '2026-04-06', '2026-04-22', 'NO', 3383.69, 3383.69);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-03', 'CT-0300', '2023-12-17', '2023-12-26', 'SI', 0.0, 2767.23);
INSERT INTO REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, fecha_siniestro, fecha_respuesta, id_rechazo, monto_reconocido, monto_solicitado) VALUES ('SIN-02', 'CT-0267', '2026-02-08', '2026-03-10', 'NO', 1228.98, 1228.98);

-- 13. METAS
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (1, 2019, 'P01', 37, 11, 70439.51, '2019-01-01', '2019-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (2, 2019, 'P02', 28, 18, 76869.16, '2019-01-01', '2019-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (3, 2019, 'P03', 16, 14, 51138.42, '2019-01-01', '2019-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (4, 2019, 'P04', 25, 18, 71836.24, '2019-01-01', '2019-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (5, 2020, 'P01', 26, 19, 54185.6, '2020-01-01', '2020-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (6, 2020, 'P02', 18, 9, 66375.53, '2020-01-01', '2020-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (7, 2020, 'P03', 21, 9, 67947.51, '2020-01-01', '2020-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (8, 2020, 'P04', 33, 11, 57041.14, '2020-01-01', '2020-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (9, 2021, 'P01', 28, 11, 63213.64, '2021-01-01', '2021-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (10, 2021, 'P02', 35, 17, 39862.92, '2021-01-01', '2021-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (11, 2021, 'P03', 29, 8, 50372.46, '2021-01-01', '2021-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (12, 2021, 'P04', 35, 20, 70218.05, '2021-01-01', '2021-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (13, 2022, 'P01', 22, 11, 51272.76, '2022-01-01', '2022-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (14, 2022, 'P02', 32, 14, 77505.6, '2022-01-01', '2022-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (15, 2022, 'P03', 39, 19, 58546.69, '2022-01-01', '2022-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (16, 2022, 'P04', 22, 11, 40965.43, '2022-01-01', '2022-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (17, 2023, 'P01', 31, 19, 78248.67, '2023-01-01', '2023-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (18, 2023, 'P02', 40, 14, 52165.21, '2023-01-01', '2023-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (19, 2023, 'P03', 29, 15, 42967.53, '2023-01-01', '2023-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (20, 2023, 'P04', 35, 9, 77936.65, '2023-01-01', '2023-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (21, 2024, 'P01', 19, 9, 31231.85, '2024-01-01', '2024-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (22, 2024, 'P02', 24, 14, 57664.56, '2024-01-01', '2024-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (23, 2024, 'P03', 28, 10, 57585.7, '2024-01-01', '2024-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (24, 2024, 'P04', 31, 20, 74365.22, '2024-01-01', '2024-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (25, 2025, 'P01', 30, 17, 40639.97, '2025-01-01', '2025-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (26, 2025, 'P02', 20, 12, 37610.69, '2025-01-01', '2025-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (27, 2025, 'P03', 35, 18, 67937.52, '2025-01-01', '2025-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (28, 2025, 'P04', 27, 16, 34489.26, '2025-01-01', '2025-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (29, 2026, 'P01', 19, 10, 31204.24, '2026-01-01', '2026-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (30, 2026, 'P02', 34, 18, 40727.26, '2026-01-01', '2026-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (31, 2026, 'P03', 33, 12, 51629.21, '2026-01-01', '2026-12-31');
INSERT INTO METAS (cod_meta, annio, cod_producto, meta_asegurados, meta_renovacion, meta_ingreso, fecha_inicio, fecha_fin) VALUES (32, 2026, 'P04', 34, 18, 35681.87, '2026-01-01', '2026-12-31');

-- =========================================================================
-- FASE C: MODELO DIMENSIONAL (DATA WAREHOUSE)
-- =========================================================================
-- CreaciÃ³n y selecciÃ³n del esquema del Data Warehouse
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
    COD_CLIENTE VARCHAR(10) UNIQUE NOT NULL, -- Clave Natural con restricciÃ³n UNIQUE para Carga Incremental
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
    COD_PRODUCTO VARCHAR(10) UNIQUE NOT NULL, -- Clave Natural con restricciÃ³n UNIQUE para Carga Incremental
    NB_PRODUCTO VARCHAR(100),
    DESCRIP_PRODUCTO TEXT,
    COD_TIPO_PRODUCTO VARCHAR(10),
    NB_TIPO_PRODUCTO VARCHAR(100),
    CALIFICACION INTEGER
);

-- DIM_CONTRATO
CREATE TABLE DIM_CONTRATO (
    SK_DIM_CONTRATO SERIAL PRIMARY KEY,
    NRO_CONTRATO VARCHAR(20) UNIQUE NOT NULL, -- Clave Natural con restricciÃ³n UNIQUE para Carga Incremental
    DESCRIP_CONTRATO TEXT
);

-- DIM_SUCURSAL
CREATE TABLE DIM_SUCURSAL (
    SK_DIM_SUCURSAL SERIAL PRIMARY KEY,
    COD_SUCURSAL VARCHAR(10) UNIQUE NOT NULL, -- Clave Natural con restricciÃ³n UNIQUE para Carga Incremental
    NB_SUCURSAL VARCHAR(100),
    COD_CIUDAD VARCHAR(10),
    NB_CIUDAD VARCHAR(100),
    COD_PAIS VARCHAR(10),
    NB_PAIS VARCHAR(100)
);

-- DIM_ESTADO_CONTRATO
CREATE TABLE DIM_ESTADO_CONTRATO (
    SK_DIM_ESTADO SERIAL PRIMARY KEY,
    COD_ESTADO CHAR(2) UNIQUE, -- Clave Natural con restricciÃ³n UNIQUE para Carga Incremental
    DESCRIP_ESTADO VARCHAR(50)
);

-- DIM_EVALUACION_SERVICIO
CREATE TABLE DIM_EVALUACION_SERVICIO (
    SK_DIM_EVALUACION SERIAL PRIMARY KEY,
    COD_EVALUACION VARCHAR(10) UNIQUE NOT NULL, -- Clave Natural con restricciÃ³n UNIQUE para Carga Incremental
    NB_DESCRIP VARCHAR(50)
);

-- DIM_SINIESTRO
CREATE TABLE DIM_SINIESTRO (
    SK_DIM_SINIESTRO SERIAL PRIMARY KEY,
    NRO_SINIESTRO VARCHAR(20) UNIQUE NOT NULL, -- Clave Natural con restricciÃ³n UNIQUE para Carga Incremental
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
    SK_DIM_SUCURSAL INTEGER REFERENCES DIM_SUCURSAL(SK_DIM_SUCURSAL),
    MONTO REAL,
    CANTIDAD INTEGER,
    CANTIDAD_CLIENTE INTEGER,
    CANTIDAD_PRODUCTO INTEGER,
    CANTIDAD_CONTRATO INTEGER,
    PRIMARY KEY (SK_DIM_TIEMPO_FECHA_INICIO, SK_DIM_CLIENTE, SK_DIM_CONTRATO, SK_DIM_PRODUCTO)
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
    ID_RECHAZO CHAR(2),
    PRIMARY KEY (SK_FECHA_SINIESTRO, SK_DIM_CLIENTE, SK_DIM_CONTRATO, SK_DIM_SINIESTRO)
);

-- FACT_EVALUACION_SERVICIO
CREATE TABLE FACT_EVALUACION_SERVICIO (
    SK_DIM_CLIENTE INTEGER REFERENCES DIM_CLIENTE(SK_DIM_CLIENTE),
    SK_DIM_PRODUCTO INTEGER REFERENCES DIM_PRODUCTO(SK_DIM_PRODUCTO),
    SK_DIM_EVALUACION_SERVICIO INTEGER REFERENCES DIM_EVALUACION_SERVICIO(SK_DIM_EVALUACION),
    SK_DIM_TIEMPO_FECHA_EVALUACION INTEGER REFERENCES DIM_TIEMPO(SK_DIM_TIEMPO),
    CANTIDAD INTEGER,
    RECOMIENDA_AMIGO REAL,
    PRIMARY KEY (SK_DIM_CLIENTE, SK_DIM_PRODUCTO, SK_DIM_EVALUACION_SERVICIO, SK_DIM_TIEMPO_FECHA_EVALUACION)
);

-- FACT_METAS
CREATE TABLE FACT_METAS (
    SK_DIM_FECHA_INICIO_META INTEGER REFERENCES DIM_TIEMPO(SK_DIM_TIEMPO),
    SK_DIM_FECHA_FIN_META INTEGER REFERENCES DIM_TIEMPO(SK_DIM_TIEMPO),
    SK_DIM_PRODUCTO INTEGER REFERENCES DIM_PRODUCTO(SK_DIM_PRODUCTO),
    MONTO_META_INGRESO REAL,
    META_RENOVACION INTEGER,
    META_ASEGURADOS INTEGER,
    PRIMARY KEY (SK_DIM_FECHA_INICIO_META, SK_DIM_PRODUCTO)
);
-- =========================================================================
-- FASE D: POBLADO DE LA DIMENSIÃ“N TIEMPO
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
    -- BUG 6 FIX: Unificado a 'Trim. ' para coincidir con schemaDW.sql
    'Trim. ' || extract(quarter from fecha), CASE WHEN extract(month from fecha) <= 6 THEN 'Semestre 1' ELSE 'Semestre 2' END, fecha
FROM generate_series('2015-01-01'::date, '2030-12-31'::date, '1 day'::interval) as fecha;

-- =========================================================================
-- FASE E: CREACIÃ“N DEL PROCEDIMIENTO ALMACENADO (ETL)
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

    -- >>> DIMENSIÃ“N NUEVA AGREGADA <<<
    INSERT INTO "SEGURO_DW_G27797047".DIM_ESTADO_CONTRATO (COD_ESTADO, DESCRIP_ESTADO) VALUES
        ('AC', 'Activo'),
        ('VE', 'Vencido'),
        ('SU', 'Suspendido')
    ON CONFLICT (COD_ESTADO) DO UPDATE SET DESCRIP_ESTADO = EXCLUDED.DESCRIP_ESTADO;

    -- ==========================================
    -- 2. CARGA DE TABLAS DE HECHOS (RELOAD)
    -- ==========================================
    
    -- FACT_REGISTRO_CONTRATO (ACTUALIZADO CON LAS 11 COLUMNAS NUEVAS)
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

    -- FACT_REGISTRO_SINIESTRO
    TRUNCATE TABLE "SEGURO_DW_G27797047".FACT_REGISTRO_SINIESTRO;
    INSERT INTO "SEGURO_DW_G27797047".FACT_REGISTRO_SINIESTRO (
        SK_FECHA_SINIESTRO, SK_FECHA_RESPUESTA, SK_DIM_CLIENTE, SK_DIM_CONTRATO, 
        SK_DIM_SUCURSAL, SK_DIM_PRODUCTO, SK_DIM_SINIESTRO, CANTIDAD, 
        MONTO_RECONOCIDO, MONTO_SOLICITADO, ID_RECHAZO
    )
    SELECT 
        to_char(rs.fecha_siniestro, 'YYYYMMDD')::integer, 
        COALESCE(to_char(rs.fecha_respuesta, 'YYYYMMDD')::integer, NULL),
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

    -- FACT_EVALUACION_SERVICIO (CARGA INCREMENTAL - UPSERT)
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
    JOIN "SEGURO_DW_G27797047".DIM_EVALUACION_SERVICIO de ON r.cod_evaluacion_servicio = de.COD_EVALUACION
    ON CONFLICT (SK_DIM_CLIENTE, SK_DIM_PRODUCTO, SK_DIM_EVALUACION_SERVICIO, SK_DIM_TIEMPO_FECHA_EVALUACION)
    DO UPDATE SET RECOMIENDA_AMIGO = EXCLUDED.RECOMIENDA_AMIGO;

    -- FACT_METAS
    TRUNCATE TABLE "SEGURO_DW_G27797047".FACT_METAS;
    INSERT INTO "SEGURO_DW_G27797047".FACT_METAS (
        SK_DIM_FECHA_INICIO_META, SK_DIM_FECHA_FIN_META,
        SK_DIM_PRODUCTO,
        MONTO_META_INGRESO, META_RENOVACION, META_ASEGURADOS
    )
    SELECT
        to_char(m.fecha_inicio, 'YYYYMMDD')::integer,
        to_char(m.fecha_fin, 'YYYYMMDD')::integer,
        dp.SK_DIM_PRODUCTO,
        m.meta_ingreso, m.meta_renovacion, m.meta_asegurados
    FROM "SEGURO_G27797047".METAS m
    JOIN "SEGURO_DW_G27797047".DIM_PRODUCTO dp ON m.cod_producto = dp.COD_PRODUCTO;

END;
$$;
-- =========================================================================
-- FASE F: EJECUCIÃ“N INICIAL DEL ETL
-- =========================================================================
CALL actualizar_datawarehouse();
