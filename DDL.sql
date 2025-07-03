-- ==========================
-- ESQUEMA: usuarios
-- ==========================

CREATE SCHEMA usuarios;

CREATE TABLE usuarios.Usuarios (
    cedula TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    permiso TEXT DEFAULT 'user',
    password TEXT NOT NULL,
    calle TEXT NOT NULL,
    carrera TEXT NOT NULL,
    estado BOOLEAN DEFAULT TRUE,
    correo TEXT NOT NULL UNIQUE,
    id_admin TEXT NOT NULL
);

CREATE TABLE usuarios.Telefonos (
    cedula TEXT NOT NULL,
    num_telefono TEXT NOT NULL,
    PRIMARY KEY (cedula, num_telefono),
    FOREIGN KEY (cedula) REFERENCES usuarios.Usuarios(cedula)
);

-- ==========================
-- ESQUEMA: pacientes
-- ==========================

CREATE SCHEMA pacientes;

CREATE TABLE pacientes.Pacientes (
    cedula TEXT PRIMARY KEY REFERENCES usuarios.Usuarios(cedula),
    fecha_nac DATE NOT NULL
);

CREATE TABLE pacientes.Historia_clinica (
    id_historial TEXT PRIMARY KEY,
    fecha_inicio DATE NOT NULL,
    cedula TEXT NOT NULL,
    FOREIGN KEY (cedula) REFERENCES pacientes.Pacientes(cedula)
);

CREATE TABLE pacientes.Registro (
    id_registro TEXT PRIMARY KEY,
    id_historial TEXT NOT NULL,
    fecha DATE NOT NULL,
    descripcion TEXT NOT NULL,
    FOREIGN KEY (id_historial) REFERENCES pacientes.Historia_clinica(id_historial)
);
-- ==========================
-- ESQUEMA: farmacias
-- ==========================

CREATE SCHEMA IF NOT EXISTS farmacias;

CREATE TABLE farmacias.Farmacias (
    id_farmacia TEXT PRIMARY KEY,
    telefono TEXT NOT NULL,
    nombre TEXT NOT NULL,
    calle TEXT NOT NULL,
    carrera TEXT NOT NULL
);

CREATE TABLE farmacias.Medicamentos (
    id_medicamento TEXT PRIMARY KEY,
    precio NUMERIC NOT NULL,
    presentacion TEXT NOT NULL,
    concentracion TEXT,
    nombre_med TEXT
);

CREATE TABLE farmacias.Farmacias_Medicamentos (
    id_farmacia TEXT NOT NULL,
    id_medicamento TEXT NOT NULL,
    lote TEXT NOT NULL,
    stock INT NOT NULL,
    PRIMARY KEY (id_farmacia, id_medicamento, lote),
    FOREIGN KEY (id_farmacia) REFERENCES farmacias.Farmacias(id_farmacia),
    FOREIGN KEY (id_medicamento) REFERENCES farmacias.Medicamentos(id_medicamento)
);

CREATE TABLE farmacias.Adquiere (
    id_compra TEXT PRIMARY KEY,
    cedula TEXT REFERENCES pacientes.Pacientes (cedula),
    id_medicamento TEXT REFERENCES farmacias.Medicamentos(id_medicamento),
    id_farmacia TEXT REFERENCES farmacias.Farmacias(id_farmacia),
    hora TIME NOT NULL,
    precio_total NUMERIC NOT NULL,
    cantidad INT NOT NULL
);

-- ==========================
-- ESQUEMA: empleados
-- ==========================
CREATE SCHEMA IF NOT EXISTS empleados;

CREATE TABLE empleados.Empleados (
    id_empleado TEXT PRIMARY KEY,
    fecha_ingreso DATE NOT NULL,
    salario NUMERIC NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    cedula TEXT NOT NULL,
    FOREIGN KEY (cedula) REFERENCES usuarios.Usuarios(cedula)
);

CREATE TABLE empleados.Medicos (
    id_empleado TEXT PRIMARY KEY,
    especialidad TEXT NOT NULL,
    registro_medico TEXT NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados.Empleados(id_empleado)
);

CREATE TABLE empleados.Administrativos (
    id_empleado TEXT PRIMARY KEY,
    cargo_admin TEXT NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados.Empleados(id_empleado)
);

-- ==========================
-- ESQUEMA: departamento
-- ==========================

CREATE SCHEMA dep_Cardiologia;

CREATE TABLE dep_Cardiologia.Cardiologos(
	id_empleado TEXT PRIMARY KEY REFERENCES empleados.Medicos(id_empleado)
);

CREATE TABLE dep_Cardiologia.Agendas (
    id_agenda TEXT PRIMARY KEY,
    estado BOOL NOT NULL,
    hora_inicio TIME,
    hora_fin TIME,
    fecha DATE,
    id_empleado TEXT,
    FOREIGN KEY (id_empleado) REFERENCES dep_Cardiologia.Cardiologos(id_empleado)
);

CREATE TABLE dep_Cardiologia.Consultas (
    id_empleado TEXT NOT NULL,
    id_agenda TEXT NOT NULL,
    PRIMARY KEY (id_empleado, id_agenda),
    FOREIGN KEY (id_empleado) REFERENCES empleados.Administrativos(id_empleado),
    FOREIGN KEY (id_agenda) REFERENCES dep_Cardiologia.Agendas(id_agenda)
);

CREATE TABLE dep_Cardiologia.Citas (
    id_cita TEXT PRIMARY KEY,
    departamento TEXT NOT NULL,
    edificio TEXT NOT NULL,
    cod_consultorio TEXT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    nom_med TEXT NOT NULL,
    id_admin TEXT NOT NULL,
    id_medico TEXT NOT NULL,
    id_agenda TEXT NOT NULL,
    id_paciente TEXT NOT NULL,
    FOREIGN KEY (id_agenda) REFERENCES dep_Cardiologia.Agendas(id_agenda),
	FOREIGN KEY (id_admin) REFERENCES empleados.Administrativos(id_empleado),
    FOREIGN KEY (id_medico) REFERENCES dep_Cardiologia.Cardiologos(id_empleado),
    FOREIGN KEY (id_paciente) REFERENCES pacientes.Pacientes(cedula)
);

CREATE TABLE dep_Cardiologia.Prescripciones (
    id_prescripcion TEXT PRIMARY KEY,
    instrucciones TEXT NOT NULL,
    dosis TEXT NOT NULL,
    id_cita TEXT,
    id_agenda TEXT,
    id_medico TEXT,
    id_paciente TEXT,
	FOREIGN KEY (id_agenda) REFERENCES dep_Cardiologia.Agendas(id_agenda),
    FOREIGN KEY (id_medico) REFERENCES dep_Cardiologia.Cardiologos(id_empleado),
    FOREIGN KEY (id_paciente) REFERENCES pacientes.Pacientes(cedula)
);

CREATE TABLE dep_Cardiologia.Prescripciones_Medicamentos (
    id_prescripcion TEXT REFERENCES dep_Cardiologia.Prescripciones(id_prescripcion),
    id_medicamento TEXT REFERENCES farmacias.Medicamentos(id_medicamento),
    PRIMARY KEY (id_prescripcion,id_medicamento)
);

CREATE TABLE dep_Cardiologia.Actualiza (
    id_cita TEXT NOT NULL,
    id_medico TEXT NOT NULL,
    id_agenda TEXT NOT NULL,
    id_historial TEXT NOT NULL,
    fecha_actualizacion DATE NOT NULL,
    descripcion TEXT NOT NULL,
    hora TIME NOT NULL,
    FOREIGN KEY (id_cita) REFERENCES dep_Cardiologia.Citas(id_cita),
    FOREIGN KEY (id_medico) REFERENCES empleados.Medicos(id_empleado),
    FOREIGN KEY (id_agenda) REFERENCES dep_Cardiologia.Agendas(id_agenda),
    FOREIGN KEY (id_historial) REFERENCES pacientes.Historia_clinica(id_historial)
);

-- ==========================
-- ALTER TABLE
-- AÑADIR REFERENCIA HACIA USUARIOS
-- ==========================
ALTER TABLE usuarios.Usuarios ADD FOREIGN KEY (id_admin) REFERENCES empleados.administrativos(id_empleado);
