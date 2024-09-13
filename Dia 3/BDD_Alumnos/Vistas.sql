-- VISTAS

-- 1. Vista de Alumnas Matriculadas en el Grado en Ingeniería Informática

CREATE VIEW vista_alumnas_informatica AS
SELECT a.nombre, a.apellido1, a.apellido2, a.nif
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id = am.id_alumno
JOIN asignatura asig ON am.id_asignatura = asig.id
JOIN grado g ON asig.id_grado = g.id
WHERE a.sexo = 'M' AND g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

SELECT * FROM vista_alumnas_informatica;

-- 2. Vista de Asignaturas en el Grado en Ingeniería Informática

CREATE VIEW vista_asignaturas_informatica AS
SELECT asig.nombre
FROM asignatura asig
JOIN grado g ON asig.id_grado = g.id
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

SELECT * FROM vista_asignaturas_informatica;

-- 3. Vista de Profesores con sus Departamentos

CREATE VIEW vista_profesores_departamento AS
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento
FROM profesor p
LEFT JOIN departamento d ON p.id_departamento = d.id;

SELECT * FROM vista_profesores_departamento;

-- 4. Vista de Asignaturas con Año de Inicio y Fin de Alumno con NIF Específico

CREATE VIEW vista_asignaturas_alumno_nif AS
SELECT asig.nombre, ce.anyo_inicio, ce.anyo_fin
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id = am.id_alumno
JOIN asignatura asig ON am.id_asignatura = asig.id
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
WHERE a.nif = '26902806M';

SELECT * FROM vista_asignaturas_alumno_nif;

-- 5. Vista de Departamentos con Profesores

CREATE VIEW vista_departamentos_con_profesores AS
SELECT d.nombre AS departamento, COUNT(p.id_profesor) AS numero_profesores
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
GROUP BY d.nombre;

SELECT * FROM vista_departamentos_con_profesores;

-- 6. Vista de Grados con Asignaturas

CREATE VIEW vista_grados_con_asignaturas AS
SELECT g.nombre AS grado, COUNT(asig.id) AS numero_asignaturas
FROM grado g
LEFT JOIN asignatura asig ON g.id = asig.id_grado
GROUP BY g.nombre;

SELECT * FROM vista_grados_con_asignaturas;

-- 7. Vista de Créditos por Tipo de Asignatura en Cada Grado

CREATE VIEW vista_creditos_por_tipo AS
SELECT g.nombre AS grado, asig.tipo AS tipo_asignatura, SUM(asig.creditos) AS total_creditos
FROM grado g
JOIN asignatura asig ON g.id = asig.id_grado
GROUP BY g.nombre, asig.tipo;

SELECT * FROM vista_creditos_por_tipo;

-- 8. Vista de Alumnos Matriculados por Año Escolar

CREATE VIEW vista_alumnos_por_curso AS
SELECT ce.anyo_inicio, COUNT(DISTINCT am.id_alumno) AS numero_alumnos_matriculados
FROM curso_escolar ce
JOIN alumno_se_matricula_asignatura am ON ce.id = am.id_curso_escolar
GROUP BY ce.anyo_inicio;

SELECT * FROM vista_alumnos_por_curso;

-- 9. Vista de Profesores y Número de Asignaturas

CREATE VIEW vista_profesores_asignaturas AS
SELECT p.id_profesor, p.nombre, p.apellido1, p.apellido2, COUNT(asig.id) AS numero_asignaturas
FROM profesor p
LEFT JOIN asignatura asig ON p.id_profesor = asig.id_profesor
GROUP BY p.id_profesor, p.nombre, p.apellido1, p.apellido2;

SELECT * FROM vista_profesores_asignaturas;

-- 10. Vista de Alumnos que Nacieron en 1999

CREATE VIEW vista_alumnos_nacidos_1999 AS
SELECT *
FROM alumno
WHERE EXTRACT(YEAR FROM fecha_nacimiento) = 1999;

SELECT * FROM vista_alumnos_nacidos_1999;

-- ################### Procedimientos ###################

-- 1. Procedimiento para Crear un Alumno

CREATE OR REPLACE PROCEDURE crear_alumno(
    nif_param VARCHAR, nombre_param VARCHAR, apellido1_param VARCHAR, apellido2_param VARCHAR,
    ciudad_param VARCHAR, direccion_param VARCHAR, telefono_param VARCHAR, 
    fecha_nacimiento_param DATE, sexo_param sexo)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO alumno (nif, nombre, apellido1, apellido2, ciudad, direccion, telefono, fecha_nacimiento, sexo)
    VALUES (nif_param, nombre_param, apellido1_param, apellido2_param, ciudad_param, direccion_param, telefono_param, fecha_nacimiento_param, sexo_param);
END;
$$;

-- 2. Procedimiento para Actualizar el Teléfono de un Alumno

CREATE OR REPLACE PROCEDURE actualizar_telefono_alumno(
    id_alumno INT, nuevo_telefono VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE alumno
    SET telefono = nuevo_telefono
    WHERE id = id_alumno;
END;
$$;

-- 3. Procedimiento para Eliminar un Profesor

CREATE OR REPLACE PROCEDURE eliminar_profesor(id_profesor_param INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM profesor WHERE id_profesor = id_profesor_param;
END;
$$;

-- 4. Procedimiento para Buscar Alumno por NIF

CREATE OR REPLACE PROCEDURE buscar_alumno_por_nif(nif_param VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT * FROM alumno WHERE nif = nif_param;
END;
$$;

-- 5. Procedimiento para Crear una Asignatura

CREATE OR REPLACE PROCEDURE crear_asignatura(
    nombre_param VARCHAR, creditos_param FLOAT, tipo_param tipo_asignatura4, 
    curso_param SMALLINT, cuatrimestre_param SMALLINT, id_profesor_param INT, id_grado_param INT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO asignatura (nombre, creditos, tipo, curso, cuatrimestre, id_profesor, id_grado)
    VALUES (nombre_param, creditos_param, tipo_param, curso_param, cuatrimestre_param, id_profesor_param, id_grado_param);
END;
$$;

-- 6. Procedimiento para Actualizar el Departamento de un Profesor

CREATE OR REPLACE PROCEDURE actualizar_departamento_profesor(
    id_profesor_param INT, id_departamento_nuevo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE profesor
    SET id_departamento = id_departamento_nuevo
    WHERE id_profesor = id_profesor_param;
END;
$$;

-- 7. Procedimiento para Eliminar una Asignatura

CREATE OR REPLACE PROCEDURE eliminar_asignatura(id_asignatura_param INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM asignatura WHERE id = id_asignatura_param;
END;
$$;

-- 8. Procedimiento para Buscar Profesores sin Departamento

CREATE OR REPLACE PROCEDURE buscar_profesores_sin_departamento()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT * FROM profesor WHERE id_departamento IS NULL;
END;
$$;

-- 9. Procedimiento para Crear un Departamento

CREATE OR REPLACE PROCEDURE crear_departamento(nombre_param VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO departamento (nombre)
    VALUES (nombre_param);
END;
$$;

-- 10. Procedimiento para Actualizar el Nombre de una Asignatura

CREATE OR REPLACE PROCEDURE actualizar_nombre_asignatura(id_asignatura_param INT, nuevo_nombre VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE asignatura
    SET nombre = nuevo_nombre
    WHERE id = id_asignatura_param;
END;
$$;

-- Verificar la lista de Todos los Procedimientos

SELECT
    proname AS name, n.nspname AS schema_name,
    CASE
        WHEN p.prokind = 'p' THEN 'PROCEDURE'
        ELSE 'FUNCTION'
    END AS type
FROM
    pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE
    p.prokind = 'p'  -- 'p' para procedimientos, 'f' para funciones
ORDER BY
    schema_name,name;