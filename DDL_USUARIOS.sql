CREATE DATABASE gestion_usuarios;
-- ==========================
-- ESQUEMA: usuarios
-- ==========================
	
	CREATE SCHEMA usuarios;
	
	CREATE TABLE usuarios.Usuarios (
	    cedula TEXT PRIMARY KEY,
	    nombre TEXT NOT NULL,
	    permisos TEXT DEFAULT 'user',
	    password TEXT NOT NULL,
	    calle TEXT NOT NULL,
	    carrera TEXT NOT NULL,
	    estado BOOLEAN DEFAULT TRUE,
	    correo TEXT NOT NULL UNIQUE,
		fecha_expedicion TEXT NOT NULL,
	    id_admin TEXT NULL 
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
	    id_historial UUID PRIMARY KEY,
	    fecha_inicio DATE NOT NULL,
	    cedula TEXT NOT NULL,
	    FOREIGN KEY (cedula) REFERENCES pacientes.Pacientes(cedula)
	);
	
	CREATE TABLE pacientes.Registro (
	    id_registro UUID PRIMARY KEY,
	    id_historial UUID NOT NULL,
	    fecha DATE NOT NULL,
	    descripcion TEXT NOT NULL,
	    FOREIGN KEY (id_historial) REFERENCES pacientes.Historia_clinica(id_historial)
	);

	-- ==========================
	-- ESQUEMA: empleados
	-- ==========================
	CREATE SCHEMA IF NOT EXISTS empleados;
	
	CREATE TABLE empleados.Empleados (
	    id_empleado UUID PRIMARY KEY,
	    fecha_ingreso DATE NOT NULL,
	    salario NUMERIC NOT NULL,
	    hora_inicio TIME NOT NULL,
	    hora_fin TIME NOT NULL,
	    cedula TEXT NOT NULL,
	    FOREIGN KEY (cedula) REFERENCES usuarios.Usuarios(cedula)
	);
	
	CREATE TABLE empleados.Medicos (
	    id_empleado UUID PRIMARY KEY,
	    departamento TEXT NOT NULL,
	    registro_medico TEXT NOT NULL,
	    FOREIGN KEY (id_empleado) REFERENCES empleados.Empleados(id_empleado)
	);
	
	CREATE TABLE empleados.Administrativos (
	    id_empleado UUID PRIMARY KEY,
	    cargo_admin TEXT NOT NULL,
	    FOREIGN KEY (id_empleado) REFERENCES empleados.Empleados(id_empleado)
	);

	

-- usuarios.Usuarios
INSERT INTO usuarios.Usuarios VALUES
('1001', 'Ana López', 'admin', 'clave1', 'Calle 1', 'Carrera 10', TRUE, 'ana@mail.com', '2001'),
('1002', 'Carlos Ruiz', 'user', 'clave2', 'Calle 2', 'Carrera 11', TRUE, 'carlos@mail.com', '2001'),
('1003', 'Elena Soto', 'user', 'clave3', 'Calle 3', 'Carrera 12', TRUE, 'elena@mail.com', '2002'),
('1004', 'Luis Gómez', 'user', 'clave4', 'Calle 4', 'Carrera 13', TRUE, 'luis@mail.com', '2002'),
('1005', 'Marta Rivas', 'admin', 'clave5', 'Calle 5', 'Carrera 14', TRUE, 'marta@mail.com', '2001');

-- usuarios.Telefonos
INSERT INTO usuarios.Telefonos VALUES
('1001', '3001234567'),
('1002', '3002345678'),
('1003', '3003456789'),
('1004', '3004567890'),
('1005', '3005678901');

-- pacientes.Pacientes
INSERT INTO pacientes.Pacientes VALUES
('1001', '1990-01-01'),
('1002', '1985-06-15'),
('1003', '2000-02-20'),
('1004', '1995-08-30'),
('1005', '1988-11-11');

-- pacientes.Historia_clinica
INSERT INTO pacientes.Historia_clinica VALUES
('HC001', '2020-01-01', '1001'),
('HC002', '2021-03-15', '1002'),
('HC003', '2021-07-10', '1003'),
('HC004', '2022-01-05', '1004'),
('HC005', '2023-06-25', '1005');

-- pacientes.Registro
INSERT INTO pacientes.Registro VALUES
('R001', 'HC001', '2023-01-01', 'Chequeo general'),
('R002', 'HC002', '2023-02-01', 'Examen de sangre'),
('R003', 'HC003', '2023-03-01', 'Dolor en el pecho'),
('R004', 'HC004', '2023-04-01', 'Presión alta'),
('R005', 'HC005', '2023-05-01', 'Revisión de rutina');

-- empleados.Empleados
INSERT INTO empleados.Empleados VALUES
('2001', '2018-01-01', 5000000, '08:00', '16:00', '1001'),
('2002', '2020-01-01', 4000000, '09:00', '17:00', '1005'),
('2003', '2021-01-01', 4500000, '10:00', '18:00', '1003'),
('2004', '2022-01-01', 4200000, '08:00', '14:00', '1002'),
('2005', '2023-01-01', 4300000, '12:00', '20:00', '1004');

-- empleados.Medicos
INSERT INTO empleados.Medicos VALUES
('2003', 'Cardiología', 'RM1234'),
('2004', 'Neurología', 'RM1235'),
('2005', 'Pediatría', 'RM1236');

-- empleados.Administrativos
INSERT INTO empleados.Administrativos VALUES
('2001', 'Gerente'),
('2002', 'Coordinador');

-- ==========================
-- ALTER TABLE
-- AÑADIR REFERENCIA HACIA USUARIOS
-- ==========================
ALTER TABLE usuarios.Usuarios ADD FOREIGN KEY (id_admin) REFERENCES empleados.administrativos(id_empleado);