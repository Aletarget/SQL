CREATE EXTENSION dblink SCHEMA dep_cardiologia;


-- DEBEN HACER UN SET DE DONDE SE VA A EJECUTAR EL DBLINK PORQUE SI NO LES VA A MARCAR ERROR
SET search_path TO dep_cardiologia;

SELECT dblink_connect(
	'conexionUsuarios',
	'host=localhost port=5432 dbname=gestion_usuarios user=postgres password=postgres' 
);

SELECT * FROM dblink(
	'conexionUsuarios',
	'SELECT cedula FROM usuarios.usuarios WHERE cedula = ''1019984322'' '
)AS t(cedula TEXT);

SELECT * FROM dep_cardiologia.citas dpcardio 
JOIN dep_cardiologia.cardiologos cardio ON cardio.id_empleado = dpcardio.id_medico
WHERE dpcardio.id_paciente = (SELECT * FROM dblink(
	'conexionUsuarios',
	'SELECT cedula FROM usuarios.usuarios WHERE cedula = ''1019984322'' '
)AS t(cedula TEXT));