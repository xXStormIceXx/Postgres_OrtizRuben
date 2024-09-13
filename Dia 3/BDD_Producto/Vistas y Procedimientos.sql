
--VISTAS

-- 1. Vista: Listado de Oficinas y Ciudades

CREATE VIEW vista_oficinas_ciudades AS
SELECT codigo_oficina, ciudad
FROM oficina;

SELECT * FROM vista_oficinas_ciudades;

-- 2. Vista: Oficinas en España

CREATE VIEW vista_oficinas_espana AS
SELECT ciudad, telefono
FROM oficina
WHERE pais = 'España';

SELECT * FROM vista_oficinas_espana;

-- 3. Vista: Empleados con jefe específico

CREATE VIEW vista_empleados_jefe AS
SELECT nombre, apellido1, apellido2, email
FROM empleado
WHERE codigo_jefe = 7;

SELECT * FROM vista_empleados_jefe;

-- 4. Vista: Jefe de la empresa

CREATE VIEW vista_jefe_empresa AS
SELECT nombre, apellido1, apellido2, email, puesto
FROM empleado
WHERE codigo_jefe IS NULL;

SELECT * FROM vista_jefe_empresa;

-- 5. Vista: Clientes Españoles

CREATE VIEW vista_clientes_espanoles AS
SELECT nombre_cliente
FROM cliente
WHERE pais = 'España';

SELECT * FROM vista_clientes_espanoles;

-- 6. Vista: Estados de Pedidos

CREATE VIEW vista_estados_pedidos AS
SELECT DISTINCT estado
FROM pedido;

SELECT * FROM vista_estados_pedidos;

-- 7. Vista: Pagos en 2008

CREATE VIEW vista_pagos_2008 AS
SELECT DISTINCT codigo_cliente
FROM pago
WHERE EXTRACT(YEAR FROM fecha_pago) = 2008;

SELECT * FROM vista_pagos_2008;

-- 8. Vista: Pedidos no entregados a tiempo

CREATE VIEW vista_pedidos_no_a_tiempo AS
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega > fecha_esperada;

SELECT * FROM vista_pedidos_no_a_tiempo;

-- 9. Vista: Pedidos entregados antes de lo esperado

CREATE VIEW vista_pedidos_entregados_antes AS
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega <= fecha_esperada - INTERVAL '2 day';

SELECT * FROM vista_pedidos_entregados_antes;

-- 10. Vista: Clientes sin pagos

CREATE VIEW vista_clientes_sin_pagos AS
SELECT nombre_cliente
FROM cliente
WHERE codigo_cliente NOT IN (SELECT codigo_cliente FROM pago);

SELECT * FROM vista_clientes_sin_pagos;

-- PROCEDIMIENTOS

-- 1. Procedimiento para insertar una nueva oficina

CREATE OR REPLACE PROCEDURE insertar_oficina(
    p_codigo_oficina VARCHAR(10),
    p_ciudad VARCHAR(30),
    p_pais VARCHAR(50),
    p_region VARCHAR(50),
    p_codigo_postal VARCHAR(10),
    p_telefono VARCHAR(20),
    p_linea_direccion1 VARCHAR(50),
    p_linea_direccion2 VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO oficina(codigo_oficina, ciudad, pais, region, codigo_postal, telefono, linea_direccion1, linea_direccion2)
    VALUES (p_codigo_oficina, p_ciudad, p_pais, p_region, p_codigo_postal, p_telefono, p_linea_direccion1, p_linea_direccion2);
END;
$$;

-- 2. Procedimiento para actualizar un empleado

CREATE OR REPLACE PROCEDURE actualizar_empleado(
    p_codigo_empleado INT,
    p_nombre VARCHAR(50),
    p_apellido1 VARCHAR(50),
    p_apellido2 VARCHAR(50),
    p_email VARCHAR(100),
    p_puesto VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE empleado
    SET nombre = p_nombre, apellido1 = p_apellido1, apellido2 = p_apellido2, email = p_email, puesto = p_puesto
    WHERE codigo_empleado = p_codigo_empleado;
END;
$$;

-- 3. Procedimiento para eliminar un cliente

CREATE OR REPLACE PROCEDURE eliminar_cliente(p_codigo_cliente INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM cliente WHERE codigo_cliente = p_codigo_cliente;
END;
$$;

-- 4. Procedimiento para insertar un nuevo pedido

CREATE OR REPLACE PROCEDURE insertar_pedido(
    p_codigo_pedido INT,
    p_fecha_pedido DATE,
    p_fecha_esperada DATE,
    p_estado VARCHAR(15),
    p_codigo_cliente INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO pedido(codigo_pedido, fecha_pedido, fecha_esperada, estado, codigo_cliente)
    VALUES (p_codigo_pedido, p_fecha_pedido, p_fecha_esperada, p_estado, p_codigo_cliente);
END;
$$;

-- 5. Procedimiento para buscar productos de una gama específica

CREATE OR REPLACE PROCEDURE buscar_productos_gama(p_gama VARCHAR(50))
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT codigo_producto, nombre, precio_venta
    FROM producto
    WHERE gama = p_gama;
END;
$$;

-- 6. Procedimiento para actualizar el límite de crédito de un cliente

CREATE OR REPLACE PROCEDURE actualizar_limite_credito(
    p_codigo_cliente INT,
    p_limite_credito DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE cliente
    SET limite_credito = p_limite_credito
    WHERE codigo_cliente = p_codigo_cliente;
END;
$$;

-- 7. Procedimiento para eliminar un empleado

CREATE OR REPLACE PROCEDURE eliminar_empleado(p_codigo_empleado INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM empleado WHERE codigo_empleado = p_codigo_empleado;
END;
$$;

-- 8. Procedimiento para buscar clientes por país

CREATE OR REPLACE PROCEDURE buscar_clientes_pais(p_pais VARCHAR(50))
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT nombre_cliente, ciudad, telefono
    FROM cliente
    WHERE pais = p_pais;
END;
$$;

-- 9. Procedimiento para insertar un nuevo producto

CREATE OR REPLACE PROCEDURE insertar_producto(
    p_codigo_producto VARCHAR(15),
    p_nombre VARCHAR(70),
    p_gama VARCHAR(50),
    p_cantidad_en_stock SMALLINT,
    p_precio_venta DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO producto(codigo_producto, nombre, gama, cantidad_en_stock, precio_venta)
    VALUES (p_codigo_producto, p_nombre, p_gama, p_cantidad_en_stock, p_precio_venta);
END;
$$;

-- 10. Procedimiento para eliminar un pedido

CREATE OR REPLACE PROCEDURE eliminar_pedido(p_codigo_pedido INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM pedido WHERE codigo_pedido = p_codigo_pedido;
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
   
-- REALIZADO POR RUBEN DARIO ORTIZ ORTEGA
