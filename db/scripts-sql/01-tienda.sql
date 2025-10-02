USE keymasters;

CREATE TABLE wallet(
    id_wallet INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    monto_total DECIMAL(10,2) NOT NULL DEFAULT 0.00
);

CREATE TABLE cliente(
    id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_wallet INT UNSIGNED,
    correo VARCHAR(150) NOT NULL,
    es_miembro BOOLEAN NOT NULL DEFAULT FALSE,
    nick VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_wallet) REFERENCES wallet(id_wallet)
);

CREATE TABLE publicador(
    id_publicador INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_wallet INT UNSIGNED,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    aprobado DATETIME NULL,
    reputacion INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_wallet) REFERENCES wallet(id_wallet)
);

CREATE TABLE juego(
    id_juego INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_publicador INT UNSIGNED NOT NULL,
    genero VARCHAR(50) NOT NULL,
    idioma VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    plataforma VARCHAR(50) NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    distribuidor VARCHAR(100),
    requisitos_sistema TEXT,
    caractersisticas TEXT,
    fecha_lanzamiento DATE,
    FOREIGN KEY (id_publicador) REFERENCES publicador(id_publicador)
);

CREATE TABLE clave(
    id_clave INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    valor VARCHAR(100) UNIQUE NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE publica(
    id_juego INT UNSIGNED,
    id_clave INT UNSIGNED,
    fecha DATE NOT NULL,
    PRIMARY KEY (id_juego, id_clave),
    FOREIGN KEY (id_juego) REFERENCES juego(id_juego),
    FOREIGN KEY (id_clave) REFERENCES clave(id_clave)
);

CREATE TABLE transaccion(
    id_transaccion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_wallet_origen INT UNSIGNED,
    id_wallet_destino INT UNSIGNED,
    fecha DATETIME NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    referencia VARCHAR(255),
    FOREIGN KEY (id_wallet_origen) REFERENCES wallet(id_wallet),
    FOREIGN KEY (id_wallet_destino) REFERENCES wallet(id_wallet)
);

CREATE TABLE compra(
    id_compra INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_clave INT UNSIGNED NOT NULL,
    id_cliente INT UNSIGNED NOT NULL,
    id_transaccion INT UNSIGNED NOT NULL,
    fecha DATETIME NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    estado VARCHAR(100) NOT NULL DEFAULT 'oculta'
    CONSTRAINT chk_estado_compra CHECK (estado IN ('oculta', 'revendida', 'revelada')),
    FOREIGN KEY (id_clave) REFERENCES clave(id_clave),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_transaccion) REFERENCES transaccion(id_transaccion)
);

CREATE TABLE reventa(
    id_compra INT UNSIGNED,
    id_cliente INT UNSIGNED,
    fecha_reventa DATETIME NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_compra, id_cliente),
    FOREIGN KEY (id_compra) REFERENCES compra(id_compra),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE resena(
    id_resena INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    id_juego INT UNSIGNED NOT NULL,
    fecha DATETIME NOT NULL,
    cuerpo TEXT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_juego) REFERENCES juego(id_juego)
);

CREATE TABLE motivo_reporte(
    id_motivo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(150) NOT NULL,
    valido_en VARCHAR(100),
    CONSTRAINT chk_motivo_reporte_valido_en CHECK (valido_en IN ('resena', 'compra', 'publicacion'))
);

CREATE TABLE reporta_res(
    id_cliente INT UNSIGNED,
    id_resena INT UNSIGNED,
    id_motivo INT UNSIGNED,
    fecha DATETIME NOT NULL,
    PRIMARY KEY (id_cliente, id_resena),
    FOREIGN KEY (id_motivo) REFERENCES motivo_reporte(id_motivo),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_resena) REFERENCES resena(id_resena)
);

CREATE TABLE reporta_pub(
    id_juego INT UNSIGNED,
    id_cliente INT UNSIGNED,
    id_motivo INT UNSIGNED,
    detalle TEXT,
    fecha DATETIME NOT NULL,
    PRIMARY KEY (id_juego, id_cliente),
    FOREIGN KEY (id_motivo) REFERENCES motivo_reporte(id_motivo),
    FOREIGN KEY (id_juego) REFERENCES juego(id_juego),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE reporta_com(
    id_compra INT UNSIGNED,
    id_cliente INT UNSIGNED,
    id_motivo INT UNSIGNED,
    detalle TEXT,
    fecha DATETIME NOT NULL,
    PRIMARY KEY (id_compra, id_cliente),
    FOREIGN KEY (id_motivo) REFERENCES motivo_reporte(id_motivo),
    FOREIGN KEY (id_compra) REFERENCES compra(id_compra),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE favorito(
    id_cliente INT UNSIGNED,
    id_juego INT UNSIGNED,
    PRIMARY KEY (id_cliente, id_juego),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_juego) REFERENCES juego(id_juego)
);

CREATE TABLE upovote(
    id_cliente INT UNSIGNED,
    id_juego INT UNSIGNED,
    es_positivo BOOLEAN NOT NULL,
    PRIMARY KEY (id_cliente, id_juego),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_juego) REFERENCES juego(id_juego)
);

CREATE TABLE movimiento(
    id_movimiento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    id_wallet INT UNSIGNED NOT NULL,
    positivo_negativo BOOLEAN NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    concepto VARCHAR(255),
    fecha DATETIME NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_wallet) REFERENCES wallet(id_wallet)
);

CREATE TABLE oferta(
    id_oferta INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    tipo VARCHAR(1),
    valor DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    cupon VARCHAR(50) DEFAULT NULL,
    CONSTRAINT chk_oferta_tipo CHECK (tipo IN ('p', 'm'))
);

CREATE TABLE genera(
    id_juego INT UNSIGNED,
    id_oferta INT UNSIGNED,
    PRIMARY KEY (id_juego, id_oferta),
    FOREIGN KEY (id_juego) REFERENCES juego(id_juego),
    FOREIGN KEY (id_oferta) REFERENCES oferta(id_oferta)
);

CREATE TABLE publicidad(
    id_publicidad INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    redireccionamiento VARCHAR(255) NOT NULL,
    url_media VARCHAR(255),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE referencia(
    id_juego INT UNSIGNED,
    id_publicidad INT UNSIGNED,
    PRIMARY KEY (id_juego, id_publicidad),
    FOREIGN KEY (id_juego) REFERENCES juego(id_juego),
    FOREIGN KEY (id_publicidad) REFERENCES publicidad(id_publicidad)
);

CREATE TABLE asociada(
    id_oferta INT UNSIGNED,
    id_publicidad INT UNSIGNED,
    PRIMARY KEY (id_oferta, id_publicidad),
    FOREIGN KEY (id_oferta) REFERENCES oferta(id_oferta),
    FOREIGN KEY (id_publicidad) REFERENCES publicidad(id_publicidad)
);

CREATE TABLE media(
    id_media INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_juego INT UNSIGNED NOT NULL,
    url VARCHAR(255) NOT NULL,
    ubicacion VARCHAR(50) NOT NULL,
    orden INT UNSIGNED DEFAULT NULL,
    FOREIGN KEY (id_juego) REFERENCES juego(id_juego)
);
