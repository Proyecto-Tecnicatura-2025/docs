CREATE TABLE Cliente (
    id_cliente INT UNSIGNED PRIMARY KEY,
    id_wallet INT UNSIGNED,
    correo VARCHAR(150) NOT NULL,
    es_miembro BOOLEAN NOT NULL DEFAULT FALSE,
    nick VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_wallet) REFERENCES Wallet(id_wallet)
);

CREATE TABLE Publicador (
    id_publicador INT UNSIGNED PRIMARY KEY,
    id_wallet INT UNSIGNED,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    aprobado DATETIME NULL,
    reputacion INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_wallet) REFERENCES Wallet(id_wallet)
);

CREATE TABLE Juego (
    id_juego INT UNSIGNED PRIMARY KEY,
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
    FOREIGN KEY (id_publicador) REFERENCES Publicador(id_publicador)
);

CREATE TABLE Publica (
    id_juego INT UNSIGNED,
    id_clave INT UNSIGNED,
    fecha DATE NOT NULL,
    PRIMARY KEY (id_juego, id_clave),
    FOREIGN KEY (id_juego) REFERENCES Juego(id_juego),
    FOREIGN KEY (id_clave) REFERENCES Clave(id_clave)
);

CREATE TABLE Clave (
    id_clave INT UNSIGNED PRIMARY KEY,
    valor VARCHAR(100) UNIQUE NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE Compra (
    id_compra INT UNSIGNED PRIMARY KEY,
    id_clave INT UNSIGNED NOT NULL,
    id_cliente INT UNSIGNED NOT NULL,
    id_transaccion INT UNSIGNED NOT NULL,
    fecha DATETIME NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    estado ENUM(
        'oculta',
        'revelada',
        'reventa'
    ) NOT NULL DEFAULT 'oculta',
    FOREIGN KEY (id_clave) REFERENCES Clave(id_clave),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_transaccion) REFERENCES Transaccion(id_transaccion)
);

CREATE TABLE Reventa (
    id_compra INT UNSIGNED,
    id_cliente INT UNSIGNED,
    fecha_reventa DATETIME NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_compra, id_cliente),
    FOREIGN KEY (id_compra) REFERENCES Compra(id_compra),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Resena (
    id_resena INT UNSIGNED PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    id_juego INT UNSIGNED NOT NULL,
    fecha DATETIME NOT NULL,
    cuerpo TEXT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_juego) REFERENCES Juego(id_juego)
);

CREATE TABLE Reporta_res (
    id_cliente INT UNSIGNED,
    id_resena INT UNSIGNED,
    fecha DATETIME NOT NULL,
    PRIMARY KEY (id_cliente, id_resena),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_resena) REFERENCES Resena(id_resena)
);

CREATE TABLE Reporta_pub (
    id_juego INT UNSIGNED,
    id_cliente INT UNSIGNED,
    motivo ENUM(
        'explotacion infantil',
        'contenido para adultos',
        'difamatorio',
        'danino',
        'violacion de la ley',
        'fraude'
    ) NOT NULL,
    detalle TEXT,
    fecha DATETIME NOT NULL,
    PRIMARY KEY (id_juego, id_cliente),
    FOREIGN KEY (id_juego) REFERENCES Juego(id_juego),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Reporta_com (
    id_compra INT UNSIGNED,
    id_cliente INT UNSIGNED,
    motivo ENUM(
        'clave no valida',
        'clave de juego diferente',
        'clave no soportada en plataforma que decia que si'
    ) NOT NULL,
    detalle TEXT,
    fecha DATETIME NOT NULL,
    PRIMARY KEY (id_compra, id_cliente),
    FOREIGN KEY (id_compra) REFERENCES Compra(id_compra),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Favorito (
    id_cliente INT UNSIGNED,
    id_juego INT UNSIGNED,
    PRIMARY KEY (id_cliente, id_juego),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_juego) REFERENCES Juego(id_juego)
);

CREATE TABLE Upovote (
    id_cliente INT UNSIGNED,
    id_juego INT UNSIGNED,
    es_positivo BOOLEAN NOT NULL,
    PRIMARY KEY (id_cliente, id_juego),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_juego) REFERENCES Juego(id_juego)
);

CREATE TABLE Wallet (
    id_wallet INT UNSIGNED PRIMARY KEY,
    monto_total DECIMAL(10,2) NOT NULL DEFAULT 0.00
);

CREATE TABLE Transaccion (
    id_transaccion INT UNSIGNED PRIMARY KEY,
    id_wallet_origen INT UNSIGNED,
    id_wallet_destino INT UNSIGNED,
    fecha DATETIME NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    referencia VARCHAR(255),
    FOREIGN KEY (id_wallet_origen) REFERENCES Wallet(id_wallet),
    FOREIGN KEY (id_wallet_destino) REFERENCES Wallet(id_wallet)
);

CREATE TABLE Movimiento (
    id_movimiento INT UNSIGNED PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    id_wallet INT UNSIGNED NOT NULL,
    positivo_negativo BOOLEAN NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    concepto VARCHAR(255),
    fecha DATETIME NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_wallet) REFERENCES Wallet(id_wallet)
);

CREATE TABLE Oferta (
    id_oferta INT UNSIGNED PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    tipo ENUM(
        'porcentual',
        'monto'
    ) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    cupon VARCHAR(50) DEFAULT NULL
);

CREATE TABLE Genera (
    id_juego INT UNSIGNED,
    id_oferta INT UNSIGNED,
    PRIMARY KEY (id_juego, id_oferta),
    FOREIGN KEY (id_juego) REFERENCES Juego(id_juego),
    FOREIGN KEY (id_oferta) REFERENCES Oferta(id_oferta)
);

CREATE TABLE Asociada (
    id_oferta INT UNSIGNED,
    id_publicidad INT UNSIGNED,
    PRIMARY KEY (id_oferta, id_publicidad),
    FOREIGN KEY (id_oferta) REFERENCES Oferta(id_oferta),
    FOREIGN KEY (id_publicidad) REFERENCES Publicidad(id_publicidad)
);

CREATE TABLE Referencia (
    id_juego INT UNSIGNED,
    id_publicidad INT UNSIGNED,
    PRIMARY KEY (id_juego, id_publicidad),
    FOREIGN KEY (id_juego) REFERENCES Juego(id_juego),
    FOREIGN KEY (id_publicidad) REFERENCES Publicidad(id_publicidad)
);

CREATE TABLE Publicidad (
    id_publicidad INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    redireccionamiento VARCHAR(255) NOT NULL,
    url_media VARCHAR(255),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE Media (
    id_media INT UNSIGNED PRIMARY KEY,
    id_juego INT UNSIGNED NOT NULL,
    url VARCHAR(255) NOT NULL,
    ubicacion VARCHAR(50) NOT NULL,
    orden INT UNSIGNED DEFAULT NULL,
    FOREIGN KEY (id_juego) REFERENCES Juego(id_juego)
);
