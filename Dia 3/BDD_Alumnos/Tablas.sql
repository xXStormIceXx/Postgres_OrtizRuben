-- Crear tipos ENUM
CREATE TYPE sexo AS ENUM ('H', 'M');
CREATE TYPE tipo_asignatura4 AS ENUM ('básica', 'obligatoria', 'optativa');


-- Crear tabla departamento
CREATE TABLE departamento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Crear tabla alumno
CREATE TABLE alumno (
    id SERIAL PRIMARY KEY,
    nif VARCHAR(9),
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9),
    fecha_nacimiento DATE NOT NULL,
    sexo sexo NOT NULL
);

-- Crear tabla profesor
CREATE TABLE profesor (
    id_profesor SERIAL PRIMARY KEY,
    nif varchar(25),
    nombre varchar(25) NOT NULL,
    apellido1 varchar(50) NOT NULL,
    apellido2 varchar(50),
    ciudad varchar(25) NOT NULL,
    direccion varchar(50) NOT null    ,
    telefono varchar(9),
    fecha_nacimiento date NOT NULL,
    sexo sexo  NOT NULL,
    id_departamento INT NOT NULL,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

-- Crear tabla grado
CREATE TABLE grado (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Crear tabla curso escolar
CREATE TABLE curso_escolar (
    id SERIAL PRIMARY KEY,
    anyo_inicio INTEGER NOT NULL,
    anyo_fin INTEGER NOT NULL
);

-- Crear tabla asignatura
CREATE TABLE asignatura (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos FLOAT NOT NULL,
    tipo tipo_asignatura4 NOT NULL,
    curso SMALLINT NOT NULL,
    cuatrimestre SMALLINT NOT NULL,
    id_profesor INT,
    id_grado INT NOT NULL,
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_grado) REFERENCES grado(id)
);

-- Crear tabla alumno se matricula asignatura
CREATE TABLE alumno_se_matricula_asignatura (
    id_alumno INT NOT NULL,
    id_asignatura INT NOT NULL,
    id_curso_escolar INT NOT NULL,
    PRIMARY KEY (id_alumno, id_asignatura, id_curso_escolar),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id),
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id)
);

SELECT tablename  FROM pg_catalog.pg_tables where schemaname = 'public';