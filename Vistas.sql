  ----- PACIENTES -----

-- Vista con la información básica de los pacientes.
CREATE OR REPLACE VIEW vista_info_paciente AS
SELECT 
    u.cedula,
    u.nombre,
    u.correo,
    u.estado,
    p.fecha_nac
FROM usuarios.Usuarios u
JOIN pacientes.Pacientes p ON u.cedula = p.cedula;

-- Vista de historial clínico por paciente
CREATE MATERIALIZED VIEW vista_historial_paciente AS
SELECT 
    h.cedula,
    h.id_historial,
    h.fecha_inicio,
    r.id_registro,
    r.fecha,
    r.descripcion
FROM pacientes.Historia_clinica h
LEFT JOIN pacientes.Registro r ON h.id_historial = r.id_historial;
 -- REFRESH MATERIALIZED VIEW vista_historial_paciente;

-- Tabla temporal de prescripciones (Cardiología + Neurología)
-- y agrega un campo para identificar el departamento.

CREATE OR REPLACE VIEW vista_prescripciones_paciente AS
SELECT 
    id_prescripcion,
    id_cita,
    id_agenda,
    id_medico,
    id_paciente,
    instrucciones,
    dosis,
    'Cardiologia' AS departamento
FROM dep_Cardiologia.Prescripciones
UNION
SELECT 
    id_prescripcion,
    id_cita,
    id_agenda,
    id_medico,
    id_paciente,
    instrucciones,
    dosis,
    'Neurologia' AS departamento
FROM dep_Neurologia.Prescripciones;

  ----- MEDICOS -----
-- Vista con el resumen de agendas de los médicos. (los horarios no cambian constantemente)
CREATE MATERIALIZED VIEW vista_agendas_medico AS
SELECT 
    'Cardiologia' AS departamento,
    id_agenda,
    fecha,
    hora_inicio,
    hora_fin,
    estado,
    id_empleado
FROM dep_Cardiologia.Agendas
UNION
SELECT 
    'Neurologia',
    id_agenda,
    fecha,
    hora_inicio,
    hora_fin,
    estado,
    id_empleado
FROM dep_Neurologia.Agendas;
-- REFRESH MATERIALIZED VIEW vista_agendas_medico;

-- Vista de citas medicas completas con información del paciente y médico. (Cambia constantemente)
CREATE OR REPLACE VIEW vista_citas_medico AS
SELECT 
    c.id_cita,
    c.departamento,
    c.fecha,
    c.hora_inicio,
    c.hora_fin,
    c.id_medico,
    c.id_paciente,
    p.nombre AS nombre_paciente
FROM dep_Cardiologia.Citas c
JOIN usuarios.Usuarios p ON p.cedula = c.id_paciente
UNION
SELECT 
    c.id_cita,
    c.departamento,
    c.fecha,
    c.hora_inicio,
    c.hora_fin,
    c.id_medico,
    c.id_paciente,
    p.nombre
FROM dep_Neurologia.Citas c
JOIN usuarios.Usuarios p ON p.cedula = c.id_paciente;

  ---- ----- FARMACEUTICOS -----
-- Vista materializada de stock por farmacia (No toca revisar stock constantemente)
CREATE MATERIALIZED VIEW vista_stock_farmacia AS
SELECT 
    f.id_farmacia,
    f.nombre AS nombre_farmacia,
    m.id_medicamento,
    m.nombre_med,
    fm.lote,
    fm.stock
FROM farmacias.Farmacias f
JOIN farmacias.Farmacias_Medicamentos fm ON f.id_farmacia = fm.id_farmacia
JOIN farmacias.Medicamentos m ON fm.id_medicamento = m.id_medicamento;
-- REFRESH MATERIALIZED VIEW vista_stock_farmacia;

-- Tabla temporal de compras realizadas por pacientes (Se usa en sesiones para filtrar por fecha o paciente)
CREATE TEMP TABLE temp_compras_sesion AS
SELECT 
    a.id_compra,
    a.cedula,
    u.nombre AS nombre_paciente,
    a.id_medicamento,
    m.nombre_med,
    a.cantidad,
    a.precio_total,
    a.fecha,
    a.hora,
    f.nombre AS farmacia
FROM farmacias.Adquiere a
JOIN farmacias.Medicamentos m ON m.id_medicamento = a.id_medicamento
JOIN farmacias.Farmacias f ON f.id_farmacia = a.id_farmacia
JOIN usuarios.Usuarios u ON u.cedula = a.cedula;