CREATE SCHEMA IF NOT EXISTS farmacias;

	CREATE TABLE farmacias.Farmacias (
	    id_farmacia TEXT PRIMARY KEY,
	    telefono TEXT NOT NULL,
	    nombre TEXT NOT NULL,
	    calle TEXT NOT NULL,
	    carrera TEXT NOT NULL
	);
	CREATE TABLE farmacias.Farmaceuticos(
		cedula TEXT NOT NULL PRIMARY KEY,-- REFERENCES usuarios.usuarios(cedula),
		licencia TEXT NOT NULL UNIQUE,
		id_farmacia TEXT REFERENCES farmacias.Farmacias(id_farmacia)
	);
	
	
	CREATE TABLE farmacias.Medicamentos (
	    id_medicamento TEXT PRIMARY KEY,
	    precio NUMERIC NOT NULL,
	    presentacion TEXT NOT NULL,
	    concentracion TEXT NOT NULL,
	    nombre_med TEXT NOT NULL
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
	    cedula TEXT NOT NULL, -- REFERENCES pacientes.Pacientes(cedula),
	    id_medicamento TEXT REFERENCES farmacias.Medicamentos(id_medicamento),
	    id_farmacia TEXT REFERENCES farmacias.Farmacias(id_farmacia),
	    hora TIME NOT NULL,
	    precio_total NUMERIC NOT NULL,
	    cantidad INT NOT NULL
	);

-- Farmacias
INSERT INTO farmacias.Farmacias VALUES
('F001', '3123456789', 'Farmacia Central', 'Calle 10', 'Carrera 50'),
('F002', '3134567890', 'Farmacia Norte', 'Calle 11', 'Carrera 51'),
('F003', '3145678901', 'Farmacia Sur', 'Calle 12', 'Carrera 52'),
('F004', '3156789012', 'Farmacia Este', 'Calle 13', 'Carrera 53'),
('F005', '3167890123', 'Farmacia Oeste', 'Calle 14', 'Carrera 54');

-- Farmaceuticos
INSERT INTO farmacias.Farmaceuticos VALUES
('9001', 'LIC123', 'F001'),
('9002', 'LIC124', 'F002'),
('9003', 'LIC125', 'F003'),
('9004', 'LIC126', 'F004'),
('9005', 'LIC127', 'F005');

-- Medicamentos
INSERT INTO farmacias.Medicamentos VALUES
('M001', 10000, 'Tableta', '500mg', 'Paracetamol'),
('M002', 12000, 'Jarabe', '5mg/ml', 'Ibuprofeno'),
('M003', 15000, 'Tableta', '250mg', 'Amoxicilina'),
('M004', 20000, 'Inyectable', '100mg', 'Diclofenaco'),
('M005', 8000, 'Tableta', '50mg', 'Loratadina');

-- Farmacias_Medicamentos
INSERT INTO farmacias.Farmacias_Medicamentos VALUES
('F001', 'M001', 'L001', 100),
('F002', 'M002', 'L002', 80),
('F003', 'M003', 'L003', 50),
('F004', 'M004', 'L004', 70),
('F005', 'M005', 'L005', 60);

-- Adquiere
INSERT INTO farmacias.Adquiere VALUES
('A001', '1001', 'M001', 'F001', '10:00', 10000, 1),
('A002', '1002', 'M002', 'F002', '11:00', 24000, 2),
('A003', '1003', 'M003', 'F003', '12:00', 15000, 1),
('A004', '1004', 'M004', 'F004', '13:00', 40000, 2),
('A005', '1005', 'M005', 'F005', '14:00', 16000, 2);

