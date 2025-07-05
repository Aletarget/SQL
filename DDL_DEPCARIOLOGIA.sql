CREATE DATABASE gestion_depCardio;
	-- ==========================
	-- ESQUEMA: departamento
	-- ==========================
	
	CREATE SCHEMA dep_Cardiologia;
	
	CREATE TABLE dep_Cardiologia.Cardiologos(
		id_empleado TEXT NOT NULL PRIMARY KEY -- PRIMARY KEY REFERENCES empleados.Medicos(id_empleado)
	);
	
	CREATE TABLE dep_Cardiologia.Agendas (
	    id_agenda TEXT PRIMARY KEY,
	    estado BOOL NOT NULL,
	    hora_inicio TIME NOT NULL,
	    hora_fin TIME NOT NULL ,
	    fecha DATE NOT NULL,
	    id_empleado TEXT NOT NULL,
	    FOREIGN KEY (id_empleado) REFERENCES dep_Cardiologia.Cardiologos(id_empleado)
	);
	
	CREATE TABLE dep_Cardiologia.Consultas (
	    id_empleado TEXT NOT NULL,
	    id_agenda TEXT NOT NULL,
	    PRIMARY KEY (id_empleado, id_agenda),
	    -- FOREIGN KEY (id_empleado) REFERENCES empleados.Administrativos(id_empleado),
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
		-- FOREIGN KEY (id_admin) REFERENCES empleados.Administrativos(id_empleado),
	    FOREIGN KEY (id_medico) REFERENCES dep_Cardiologia.Cardiologos(id_empleado)
	    -- FOREIGN KEY (id_paciente) REFERENCES pacientes.Pacientes(cedula)
	);
	
	CREATE TABLE dep_Cardiologia.Prescripciones (
	    id_prescripcion TEXT PRIMARY KEY,
	    instrucciones TEXT NOT NULL,
	    dosis TEXT NOT NULL,
	    id_cita TEXT NOT NULL,
	    id_agenda TEXT NOT NULL,
	    id_medico TEXT NOT NULL,
	    id_paciente TEXT NOT NULL,
		FOREIGN KEY (id_agenda) REFERENCES dep_Cardiologia.Agendas(id_agenda),
	    FOREIGN KEY (id_medico) REFERENCES dep_Cardiologia.Cardiologos(id_empleado)
	    -- FOREIGN KEY (id_paciente) REFERENCES pacientes.Pacientes(cedula)
	);
	
	CREATE TABLE dep_Cardiologia.Prescripciones_Medicamentos (
	    id_prescripcion TEXT REFERENCES dep_Cardiologia.Prescripciones(id_prescripcion),
	    id_medicamento TEXT NOT NULL, -- REFERENCES farmacias.Medicamentos(id_medicamento),
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
	    -- FOREIGN KEY (id_medico) REFERENCES empleados.Medicos(id_empleado),
	    FOREIGN KEY (id_agenda) REFERENCES dep_Cardiologia.Agendas(id_agenda)
	    -- FOREIGN KEY (id_historial) REFERENCES pacientes.Historia_clinica(id_historial)
	);

-- Cardiologos
INSERT INTO dep_Cardiologia.Cardiologos VALUES
('2003'), ('2004'), ('2005'), ('2001'), ('2002');

-- Agendas
INSERT INTO dep_Cardiologia.Agendas VALUES
('AG001', TRUE, '08:00', '12:00', '2024-07-04', '2003'),
('AG002', FALSE, '10:00', '14:00', '2024-07-05', '2004'),
('AG003', TRUE, '14:00', '18:00', '2024-07-06', '2005'),
('AG004', TRUE, '08:00', '12:00', '2024-07-07', '2001'),
('AG005', TRUE, '09:00', '11:00', '2024-07-08', '2002');

-- Consultas
INSERT INTO dep_Cardiologia.Consultas VALUES
('2003', 'AG001'),
('2004', 'AG002'),
('2005', 'AG003'),
('2001', 'AG004'),
('2002', 'AG005');

-- Citas
INSERT INTO dep_Cardiologia.Citas VALUES
('C001', 'Cardiología', 'A', '101', '2024-07-04', '08:00', '09:00', 'Dr. A', '2001', '2003', 'AG001', '1001'),
('C002', 'Cardiología', 'B', '102', '2024-07-05', '10:00', '11:00', 'Dr. B', '2002', '2004', 'AG002', '1002'),
('C003', 'Cardiología', 'C', '103', '2024-07-06', '14:00', '15:00', 'Dr. C', '2001', '2005', 'AG003', '1003'),
('C004', 'Cardiología', 'D', '104', '2024-07-07', '08:00', '09:00', 'Dr. D', '2002', '2001', 'AG004', '1004'),
('C005', 'Cardiología', 'E', '105', '2024-07-08', '09:00', '10:00', 'Dr. E', '2001', '2002', 'AG005', '1005');

-- Prescripciones
INSERT INTO dep_Cardiologia.Prescripciones VALUES
('P001', 'Tomar en ayunas', '1 diaria', 'C001', 'AG001', '2003', '1001'),
('P002', 'Después de comer', '2 diarias', 'C002', 'AG002', '2004', '1002'),
('P003', 'Cada 8 horas', '3 diarias', 'C003', 'AG003', '2005', '1003'),
('P004', 'Antes de dormir', '1 diaria', 'C004', 'AG004', '2001', '1004'),
('P005', 'Mañana y noche', '2 diarias', 'C005', 'AG005', '2002', '1005');

-- Prescripciones_Medicamentos
INSERT INTO dep_Cardiologia.Prescripciones_Medicamentos VALUES
('P001', 'M001'),
('P002', 'M002'),
('P003', 'M003'),
('P004', 'M004'),
('P005', 'M005');

-- Actualiza
INSERT INTO dep_Cardiologia.Actualiza VALUES
('C001', '2003', 'AG001', 'HC001', '2024-07-04', 'Mejoría notable', '08:30'),
('C002', '2004', 'AG002', 'HC002', '2024-07-05', 'Presión controlada', '10:30'),
('C003', '2005', 'AG003', 'HC003', '2024-07-06', 'Seguimiento indicado', '14:30'),
('C004', '2001', 'AG004', 'HC004', '2024-07-07', 'Ningún cambio', '08:30'),
('C005', '2002', 'AG005', 'HC005', '2024-07-08', 'Revisión pendiente', '09:30');

