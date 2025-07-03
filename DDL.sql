CREATE SCHEMA IF NOT EXISTS "usuarios";

CREATE TABLE usuarios.usuario (
    cedula   VARCHAR(20)  PRIMARY KEY,
    nombre   VARCHAR(50)  NOT NULL,
    permisos TEXT[]       DEFAULT ARRAY['user'],
    password VARCHAR(100) NOT NULL,
    calle    VARCHAR(20)  NOT NULL,
    carrera  VARCHAR(20)  NOT NULL,
    estado   BOOLEAN      DEFAULT TRUE,
    correo   VARCHAR(50)  UNIQUE NOT NULL
);

CREATE TABLE usuarios.telefonos (
    cedula INTEGER NOT NULL,
    telefono INTEGER NOT NULL,
    PRIMARY KEY (cedula, telefono),
    FOREIGN KEY (cedula) REFERENCES usuarios.usuario(cedula) ON DELETE CASCADE
);

CREATE SCHEMA IF NOT EXISTS "farmacias";

CREATE SCHEMA IF NOT EXISTS "dep_cardio";

CREATE SCHEMA IF NOT EXISTS "dep_derma";


SELECT * FROM usuarios.telefonos

INSERT INTO 