CREATE EXTENSION dblink;

-- Conexión a usuarios (en AWS)
SELECT dblink_connect('con_usuarios', 'host=gestionusuarios.clg24aui6ob8.us-east-2.rds.amazonaws.com user=postgres password=postgres dbname=gestion_usuarios');

-- Conexión a farmacias
SELECT dblink_connect('con_farmacias', 'host=localhost port=5433 user=postgres password=postgres dbname=gestion_farmacias');


-- ==============
-- CONSULTAS
-- ==============

-- 1. Obtener los nombres de los pacientes que han asistido a citas en el departamento
-- de cardiología y que además han adquirido medicamentos en alguna farmacia.
SELECT c.id_paciente, u.nombre
FROM dep_Cardiologia.Citas c
JOIN (
SELECT cedula, nombre FROM dblink('con_usuarios',
'SELECT cedula, nombre FROM usuarios.Usuarios'
) AS t(cedula TEXT, nombre TEXT)
) u ON u.cedula = c.id_paciente
JOIN (
SELECT cedula FROM dblink('con_farmacias',
'SELECT cedula FROM farmacias.Adquiere'
) AS t(cedula TEXT)
) a ON a.cedula = c.id_paciente;


-- 2. Listar los medicamentos que fueron prescritos en cardiología a pacientes que 
-- posteriormente los adquirieron en alguna farmacia, mostrando el nombre del medicamento 
-- y el paciente correspondiente.
SELECT pm.id_medicamento, m.nombre_med, p.id_paciente
FROM dep_Cardiologia.Prescripciones p
JOIN dep_Cardiologia.Prescripciones_Medicamentos pm ON p.id_prescripcion = pm.id_prescripcion
JOIN (
SELECT id_medicamento, nombre_med FROM dblink('con_farmacias',
'SELECT id_medicamento, nombre_med FROM farmacias.Medicamentos'
) AS t(id_medicamento TEXT, nombre_med TEXT)
) m ON m.id_medicamento = pm.id_medicamento
JOIN (
SELECT id_medicamento, cedula FROM dblink('con_farmacias',
'SELECT id_medicamento, cedula FROM farmacias.Adquiere'
) AS t(id_medicamento TEXT, cedula TEXT)
) a ON a.id_medicamento = pm.id_medicamento AND a.cedula = p.id_paciente;


-- 3. Obtener el nombre, correo y especialidad de todos los médicos que han atendido citas 
-- en el departamento de cardiología, accediendo a la información personal desde la base de 
-- usuarios y la especialidad desde la tabla de médicos.
SELECT u.nombre, u.correo, m.especialidad
FROM dep_Cardiologia.Citas c
JOIN (
SELECT id_empleado, cedula FROM dblink('con_usuarios',
'SELECT id_empleado, cedula FROM empleados.Empleados'
) AS t(id_empleado TEXT, cedula TEXT)
) e ON e.id_empleado = c.id_medico
JOIN (
SELECT cedula, nombre, correo FROM dblink('con_usuarios',
'SELECT cedula, nombre, correo FROM usuarios.Usuarios'
) AS t(cedula TEXT, nombre TEXT, correo TEXT)
) u ON u.cedula = e.cedula
JOIN (
SELECT id_empleado, especialidad FROM dblink('con_usuarios',
'SELECT id_empleado, especialidad FROM empleados.Medicos'
) AS t(id_empleado TEXT, especialidad TEXT)
) m ON m.id_empleado = c.id_medico;


-- 4. Listar las farmacias que actualmente tienen en stock alguno de los medicamentos que han 
-- sido prescritos en el departamento de cardiología.
SELECT DISTINCT f.nombre, f.telefono, f.calle, f.carrera
FROM dep_Cardiologia.Prescripciones_Medicamentos pm
JOIN (
SELECT id_medicamento, id_farmacia FROM dblink('con_farmacias',
'SELECT id_medicamento, id_farmacia FROM farmacias.Farmacias_Medicamentos WHERE stock > 0'
) AS t(id_medicamento TEXT, id_farmacia TEXT)
) fm ON fm.id_medicamento = pm.id_medicamento
JOIN (
SELECT id_farmacia, nombre, telefono, calle, carrera FROM dblink('con_farmacias',
'SELECT id_farmacia, nombre, telefono, calle, carrera FROM farmacias.Farmacias'
) AS t(id_farmacia TEXT, nombre TEXT, telefono TEXT, calle TEXT, carrera TEXT)
) f ON f.id_farmacia = fm.id_farmacia;



-- 5. Mostrar el nombre de cada paciente, el medicamento que se le prescribió y la farmacia 
-- donde lo adquirió, enlazando la información de prescripción con la compra real del medicamento.
SELECT u.nombre, m.nombre_med, f.nombre AS farmacia
FROM dep_Cardiologia.Prescripciones p
JOIN dep_Cardiologia.Prescripciones_Medicamentos pm ON pm.id_prescripcion = p.id_prescripcion
JOIN (
SELECT id_medicamento, nombre_med FROM dblink('con_farmacias',
'SELECT id_medicamento, nombre_med FROM farmacias.Medicamentos'
) AS t(id_medicamento TEXT, nombre_med TEXT)
) m ON m.id_medicamento = pm.id_medicamento
JOIN (
SELECT cedula, id_medicamento, id_farmacia FROM dblink('con_farmacias',
'SELECT cedula, id_medicamento, id_farmacia FROM farmacias.Adquiere'
) AS t(cedula TEXT, id_medicamento TEXT, id_farmacia TEXT)
) a ON a.id_medicamento = pm.id_medicamento AND a.cedula = p.id_paciente
JOIN (
SELECT id_farmacia, nombre FROM dblink('con_farmacias',
'SELECT id_farmacia, nombre FROM farmacias.Farmacias'
) AS t(id_farmacia TEXT, nombre TEXT)
) f ON f.id_farmacia = a.id_farmacia
JOIN (
SELECT cedula, nombre FROM dblink('con_usuarios',
'SELECT cedula, nombre FROM usuarios.Usuarios'
) AS t(cedula TEXT, nombre TEXT)
) u ON u.cedula = p.id_paciente;


-- 6 Obtener la última actualización realizada en la historia clínica de cada 
-- paciente, incluyendo la fecha y la descripción de dicha actualización.

SELECT a.id_historial, a.fecha_actualizacion, a.descripcion
FROM dep_Cardiologia.Actualiza a
WHERE a.fecha_actualizacion = (
SELECT MAX(fecha_actualizacion)
FROM dep_Cardiologia.Actualiza
WHERE id_historial = a.id_historial
);

-- 7. Calcular el total de dinero gastado por cada paciente que recibió prescripciones
-- en el departamento de cardiología y luego adquirió los medicamentos en farmacias.


SELECT u.nombre, SUM(a.precio_total) AS total_gastado
FROM dep_Cardiologia.Prescripciones p
JOIN (
SELECT id_medicamento, cedula, precio_total FROM dblink('con_farmacias',
'SELECT id_medicamento, cedula, precio_total FROM farmacias.Adquiere'
) AS t(id_medicamento TEXT, cedula TEXT, precio_total NUMERIC)
) a ON a.cedula = p.id_paciente
JOIN (
SELECT cedula, nombre FROM dblink('con_usuarios',
'SELECT cedula, nombre FROM usuarios.Usuarios'
) AS t(cedula TEXT, nombre TEXT)
) u ON u.cedula = p.id_paciente
GROUP BY u.nombre;

