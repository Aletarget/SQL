-- Crear roles
CREATE ROLE admin_global LOGIN PASSWORD 'admin123';
CREATE ROLE paciente LOGIN PASSWORD 'paciente123';
CREATE ROLE medico LOGIN PASSWORD 'medico123';
CREATE ROLE admin_clinico LOGIN PASSWORD 'adminclinico123';
CREATE ROLE farmaceutico LOGIN PASSWORD 'farmaceutico123';
CREATE ROLE admin_farm LOGIN PASSWORD 'adminfarm123';

-- Esquema: usuarios
GRANT CONNECT ON DATABASE gestion_hospitalaria TO paciente, medico, admin_clinico, admin_global;
GRANT USAGE ON SCHEMA usuarios TO paciente, medico, admin_clinico, admin_global;
GRANT SELECT, UPDATE ON usuarios.Usuarios TO paciente; -- solo su propio registro
GRANT SELECT ON usuarios.Usuarios TO medico, admin_clinico, admin_global;
GRANT INSERT, UPDATE, DELETE ON usuarios.Usuarios TO admin_clinico, admin_global;

-- Esquema: pacientes
GRANT USAGE ON SCHEMA pacientes TO paciente, medico, admin_clinico, admin_global;
GRANT SELECT ON pacientes.Pacientes TO paciente, medico, admin_clinico, admin_global;
GRANT INSERT, UPDATE ON pacientes.Historia_clinica TO medico;
GRANT SELECT ON pacientes.Historia_clinica TO medico, paciente;
GRANT INSERT ON pacientes.Registro TO medico;
GRANT SELECT ON pacientes.Registro TO medico, paciente;

-- Esquema: empleados
GRANT USAGE ON SCHEMA empleados TO medico, admin_clinico, admin_global;
GRANT SELECT ON empleados.Empleados TO medico, admin_clinico, admin_global;
GRANT INSERT, UPDATE, DELETE ON empleados.Empleados TO admin_clinico, admin_global;

-- Esquema: farmacias
GRANT USAGE ON SCHEMA farmacias TO paciente, farmaceutico, admin_farm, admin_global;
GRANT SELECT ON farmacias.Medicamentos TO paciente, farmaceutico, admin_farm;
GRANT SELECT, INSERT, UPDATE ON farmacias.Adquiere TO farmaceutico, admin_farm;
GRANT INSERT, UPDATE, DELETE ON farmacias.Farmacias_Medicamentos TO admin_farm;
GRANT INSERT, DELETE ON farmacias.Farmaceuticos TO admin_farm;

-- Esquemas: dep_Cardiologia, dep_Neurologia
GRANT USAGE ON SCHEMA dep_Cardiologia TO medico, admin_clinico, admin_global;
GRANT USAGE ON SCHEMA dep_Neurologia TO medico, admin_clinico, admin_global;

GRANT SELECT, INSERT, UPDATE ON dep_Cardiologia.Citas TO medico, admin_clinico;
GRANT SELECT, INSERT ON dep_Cardiologia.Prescripciones TO medico;
GRANT SELECT ON dep_Cardiologia.Prescripciones TO paciente;
GRANT INSERT ON dep_Cardiologia.Actualiza TO medico;

GRANT SELECT, INSERT, UPDATE ON dep_Neurologia.Citas TO medico, admin_clinico;
GRANT INSERT ON dep_Neurologia.Prescripciones TO medico;
GRANT SELECT ON dep_Neurologia.Prescripciones TO paciente;
GRANT INSERT ON dep_Neurologia.Actualiza TO medico;
