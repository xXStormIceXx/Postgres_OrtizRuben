-- CONSULTAS SOBRE UNA TABLA
-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
SELECT codigo_oficina, ciudad 
FROM oficinas;

-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
SELECT ciudad, telefono 
FROM oficinas 
WHERE pais = 'España';

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
SELECT e.nombre, e.apellido1, e.apellido2, e.email
FROM empleados e
JOIN empleados j ON e.codigo_jefe = j.codigo_empleado
WHERE j.codigo_empleado = 7;

-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
SELECT p.nombre_puesto, e.nombre, e.apellido1, e.apellido2, e.email
FROM empleados e
JOIN puestos p ON e.codigo_puesto = p.codigo_puesto
WHERE e.es_jefe = true;

-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
SELECT e.nombre, e.apellido1, e.apellido2, p.nombre_puesto
FROM empleados e
JOIN puestos p ON e.codigo_puesto = p.codigo_puesto
WHERE p.nombre_puesto != 'Representante de ventas';

-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
SELECT nombre_cliente
FROM clientes
WHERE pais = 'España';

-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
SELECT DISTINCT estado
FROM pedidos;

-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
-- • Utilizando la función YEAR de MySQL.
-- • Utilizando la función DATE_FORMAT de MySQL.
-- • Sin utilizar ninguna de las funciones anteriores.
SELECT DISTINCT codigo_cliente
FROM pagos
WHERE EXTRACT(YEAR FROM fecha_pago) = 2008;

-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedidos
WHERE fecha_entrega > fecha_esperada;

-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
-- • Utilizando la función ADDDATE de MySQL.
-- • Utilizando la función DATEDIFF de MySQL.
-- • ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedidos
WHERE AGE(fecha_esperada, fecha_entrega) >= INTERVAL '2 days';

-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
SELECT codigo_pedido, codigo_cliente, estado, fecha_pedido
FROM pedidos
WHERE estado = 'Rechazado' AND EXTRACT(YEAR FROM fecha_pedido) = 2009;

-- 12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.
SELECT codigo_pedido, codigo_cliente, fecha_entrega
FROM pedidos
WHERE EXTRACT(MONTH FROM fecha_entrega) = 1;

-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.
SELECT codigo_pago, codigo_cliente, monto_pago
FROM pagos
WHERE metodo_pago = 'Paypal' AND EXTRACT(YEAR FROM fecha_pago) = 2008
ORDER BY monto_pago DESC;

-- 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.
SELECT DISTINCT metodo_pago
FROM pagos;

-- 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.
SELECT nombre_producto, precio_venta, stock
FROM productos
WHERE gama = 'Ornamentales' AND stock > 100
ORDER BY precio_venta DESC;

-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.
SELECT c.nombre_cliente, c.apellido_cliente
FROM clientes c
JOIN empleados e ON c.codigo_representante = e.codigo_empleado
WHERE c.ciudad = 'Madrid' AND e.codigo_empleado IN (11, 30);

--Consultas multitabla (Composición interna)
--Resuelva todas las consultas utilizando la sintaxis de SQL1 y SQL2. Las consultas con sintaxis de SQL2 se deben resolver con INNER JOIN y NATURAL JOIN.
--1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.
SELECT c.nombre_cliente, e.nombre, e.apellido1 
FROM cliente c 
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

--2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT c.nombre_cliente, e.nombre, e.apellido1 
FROM cliente c 
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente;

--3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT c.nombre_cliente, e.nombre, e.apellido1 
FROM cliente c 
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

--4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad 
FROM cliente c 
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente;

--5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad 
FROM cliente c 
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

--6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
SELECT o.linea_direccion1, o.linea_direccion2, o.ciudad, o.pais, o.codigo_postal 
FROM oficina o 
INNER JOIN cliente c ON o.codigo_oficina = c.codigo_empleado_rep_ventas
WHERE c.ciudad = 'Fuenlabrada';

--7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad 
FROM cliente c 
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

--8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
SELECT e1.nombre AS empleado, e2.nombre AS jefe 
FROM empleado e1 
INNER JOIN empleado e2 ON e1.codigo_jefe = e2.codigo_empleado;

--9. Devuelve un listado que muestre el nombre de cada empleados, el nombre de su jefe y el nombre del jefe de sus jefe.
SELECT e1.nombre AS empleado, e2.nombre AS jefe, e3.nombre AS jefe_del_jefe 
FROM empleado e1 
INNER JOIN empleado e2 ON e1.codigo_jefe = e2.codigo_empleado
INNER JOIN empleado e3 ON e2.codigo_jefe = e3.codigo_empleado;

--10. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
SELECT c.nombre_cliente 
FROM cliente c 
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_entrega > p.fecha_esperada;

-- 11. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
SELECT c.nombre_cliente, gp.gama 
FROM cliente c 
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
INNER JOIN producto prod ON dp.codigo_producto = prod.codigo_producto
INNER JOIN gama_producto gp ON prod.gama = gp.gama;

--Consultas multitabla (Composición externa) Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, NATURAL 
--LEFT JOIN y NATURAL RIGHT JOIN.

--1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
SELECT c.nombre_cliente 
FROM cliente c 
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

--2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.
SELECT c.nombre_cliente 
FROM cliente c 
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

--3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.
SELECT c.nombre_cliente 
FROM cliente c 
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pedido pd ON c.codigo_cliente = pd.codigo_cliente
WHERE p.codigo_cliente IS NULL AND pd.codigo_cliente IS NULL;

--4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.
SELECT e.nombre 
FROM empleado e 
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE e.codigo_oficina IS NULL;

--5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.
SELECT e.nombre 
FROM empleado e 
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL;

-- 6. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.
SELECT e.nombre, o.ciudad 
FROM empleado e 
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL;

-- 7. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.
SELECT e.nombre 
FROM empleado e 
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE e.codigo_oficina IS NULL OR c.codigo_cliente IS NULL;

--8. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT p.codigo_producto, p.nombre 
FROM producto p 
LEFT JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;

--9. Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.
SELECT p.nombre, p.descripcion, p.imagen 
FROM producto p 
LEFT JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;

--10. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
SELECT o.codigo_oficina, o.ciudad 
FROM oficina o 
LEFT JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
LEFT JOIN producto prod ON dp.codigo_producto = prod.codigo_producto
WHERE prod.gama = 'Frutales' AND e.codigo_empleado IS NULL;

-- 11. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
SELECT c.nombre_cliente 
FROM cliente c 
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pago pg ON c.codigo_cliente = pg.codigo_cliente
WHERE p.codigo_cliente IS NOT NULL AND pg.codigo_cliente IS NULL;

--12. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.
SELECT e1.nombre AS empleado, e2.nombre AS jefe 
FROM empleado e1 
LEFT JOIN cliente c ON e1.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN empleado e2 ON e1.codigo_jefe = e2.codigo_empleado
WHERE c.codigo_cliente IS NULL;

