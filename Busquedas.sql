USE sys

--1
SELECT
    cat.nombre AS nombre_categoria,
    MONTHNAME(ped.fecha_pedido) AS nombre_mes,
    SUM(det.cantidad * det.precio_unit) AS monto_total_ventas,
    SUM(det.cantidad) AS cantidad_total_vendida
FROM
    PEDIDO ped
    JOIN DETALLE_PEDIDO det ON ped.id_pedido = det.id_pedido
    JOIN PRODUCTO prod ON det.id_producto = prod.id_producto
    JOIN CATEGORIA cat ON prod.id_categoria = cat.id_categoria
GROUP BY
    cat.nombre,
    MONTH(ped.fecha_pedido),
    MONTHNAME(ped.fecha_pedido)
ORDER BY
    cat.nombre,
    MONTH(ped.fecha_pedido);

--2
SELECT nombre, email
FROM CLIENTE
WHERE id_cliente NOT IN (
    SELECT DISTINCT p.id_cliente
    FROM PEDIDO p
    JOIN DETALLE_PEDIDO dp ON p.id_pedido = dp.id_pedido
    JOIN PRODUCTO pr ON dp.id_producto = pr.id_producto
    JOIN CATEGORIA c ON pr.id_categoria = c.id_categoria
    WHERE c.nombre = 'Electrónica'
);

--3
SELECT pr.nombre AS producto,
       (pr.precio - MIN(dp.precio_unit)) AS variacion_precio
FROM PRODUCTO pr
JOIN DETALLE_PEDIDO dp ON pr.id_producto = dp.id_producto
GROUP BY pr.id_producto, pr.nombre, pr.precio
ORDER BY variacion_precio DESC
LIMIT 1;

--4
SELECT 
    c.nombre AS cliente,
    ROUND(SUM(dp.cantidad * dp.precio_unit), 2) AS total_gastado
FROM CLIENTE c
JOIN PEDIDO p ON c.id_cliente = p.id_cliente
JOIN DETALLE_PEDIDO dp ON p.id_pedido = dp.id_pedido
GROUP BY c.id_cliente, c.nombre
ORDER BY total_gastado DESC;


--5
SELECT id_cliente, fecha_pedido, COUNT(*) AS cantidad_pedidos
FROM PEDIDO
GROUP BY id_cliente, fecha_pedido
HAVING COUNT(*) > 1
ORDER BY id_cliente, fecha_pedido;

--6
SELECT DISTINCT pr.nombre AS producto
FROM PRODUCTO pr
JOIN DETALLE_PEDIDO dp ON pr.id_producto = dp.id_producto
JOIN PEDIDO p ON dp.id_pedido = p.id_pedido
WHERE pr.stock = 0
  AND p.estado = 'PENDIENTE';

--7
SELECT c.nombre AS categoria, AVG(pr.precio) AS precio_promedio
FROM PRODUCTO pr
JOIN CATEGORIA c ON pr.id_categoria = c.id_categoria
GROUP BY c.id_categoria, c.nombre
HAVING AVG(pr.precio) > (
    SELECT AVG(precio) FROM PRODUCTO
);

--8
SELECT id_producto, precio_anterior, precio_nuevo
FROM HISTORICO_PRECIOS
WHERE fecha_cambio >= CURDATE() - INTERVAL 30 DAY;

--9
SELECT p.id_pedido, pr.nombre, dp.cantidad
FROM CLIENTE c
JOIN PEDIDO p ON c.id_cliente = p.id_cliente
JOIN DETALLE_PEDIDO dp ON p.id_pedido = dp.id_pedido
JOIN PRODUCTO pr ON dp.id_producto = pr.id_producto
GROUP BY p.id_pedido, pr.nombre, dp.cantidad, c.id_cliente
HAVING SUM(dp.cantidad * dp.precio_unit) > 3000;

--10
SELECT 
    p.id_cliente,
    pe.id_pedido,
    MIN(pe.fecha_pedido) AS fecha_primer_pedido,
    SUM(dp.cantidad * dp.precio_unit) AS monto_total
FROM PEDIDO pe
JOIN DETALLE_PEDIDO dp ON pe.id_pedido = dp.id_pedido
JOIN (
    SELECT id_cliente, MIN(fecha_pedido) AS fecha_primer_pedido
    FROM PEDIDO
    GROUP BY id_cliente
) AS p ON p.id_cliente = pe.id_cliente AND p.fecha_primer_pedido = pe.fecha_pedido
GROUP BY p.id_cliente, pe.id_pedido;

--11
SELECT 
    p.nombre,
    COUNT(hp.id_producto) AS cantidad_cambios
FROM HISTORICO_PRECIOS hp
JOIN PRODUCTO p ON hp.id_producto = p.id_producto
GROUP BY p.nombre
HAVING COUNT(hp.id_producto) > 1
ORDER BY cantidad_cambios DESC;

--12
SELECT 
    c.nombre,
    c.fecha_registro
FROM CLIENTE c
WHERE c.fecha_registro < (
    SELECT MIN(fecha_pedido) 
    FROM PEDIDO
);

--13
SELECT 
    p.nombre
FROM PRODUCTO p
JOIN DETALLE_PEDIDO dp ON p.id_producto = dp.id_producto
GROUP BY p.id_producto, p.nombre
HAVING COUNT(DISTINCT dp.id_pedido) = (
    SELECT COUNT(DISTINCT id_pedido)
    FROM PEDIDO
);

--14
SELECT email, COUNT(*) AS cantidad
FROM CLIENTE
GROUP BY email
HAVING COUNT(*) > 1;

--15
SELECT c.nombre AS entidad,c.fecha_registro AS fecha_movimiento,'Cliente registrado' AS tipo_movimiento
FROM CLIENTE c
UNION ALL
SELECT p.nombre AS entidad, h.fecha_cambio AS fecha_movimiento, 'Cambio de precio' AS tipo_movimiento
FROM HISTORICO_PRECIOS h
JOIN PRODUCTO p ON h.id_producto = p.id_producto
ORDER BY fecha_movimiento;

--16
SELECT nombre
FROM PRODUCTO
WHERE id_producto NOT IN (
    SELECT DISTINCT id_producto 
    FROM DETALLE_PEDIDO
);

--17
SELECT 
    p.nombre AS producto,
    SUM(dp.cantidad * (dp.precio_unit * 0.2)) AS margen_neto_total
FROM DETALLE_PEDIDO dp
JOIN PRODUCTO p ON dp.id_producto = p.id_producto
GROUP BY p.nombre
ORDER BY margen_neto_total DESC;

--18
SELECT 
    pr.id_producto, 
    pr.nombre, 
    dp.id_pedido, 
    p.fecha_pedido, 
    dp.cantidad
FROM PRODUCTO AS pr
JOIN DETALLE_PEDIDO AS dp 
    ON pr.id_producto = dp.id_producto
JOIN PEDIDO AS p 
    ON dp.id_pedido = p.id_pedido
WHERE p.fecha_pedido = (
    SELECT MAX(ped.fecha_pedido)
    FROM DETALLE_PEDIDO AS det
    JOIN PEDIDO AS ped 
        ON det.id_pedido = ped.id_pedido
    WHERE det.id_producto = pr.id_producto
);

--19
SELECT 
    p.nombre AS nombre_producto,
    dp.id_pedido,
    dp.precio_unit AS precio_en_pedido,
    p.precio AS precio_actual
FROM DETALLE_PEDIDO dp
JOIN PRODUCTO p ON dp.id_producto = p.id_producto
WHERE dp.precio_unit <> p.precio;

--20
SELECT nombre, precio, stock
FROM PRODUCTO
WHERE precio > (SELECT AVG(precio) FROM PRODUCTO)
  AND stock > (SELECT AVG(stock) FROM PRODUCTO)
ORDER BY precio DESC, stock DESC;


--21
SELECT 
    id_pedido,
    fecha_evento,
    accion
FROM AUDITORIA_PEDIDOS
WHERE usuario_bd = 'SYSTEM';

--22
SELECT 
    usuario_bd, 
    COUNT(accion) AS total_acciones
FROM 
    AUDITORIA_PEDIDOS
GROUP BY 
    usuario_bd
HAVING 
    COUNT(accion) > 10;

--23

UPDATE PRODUCTO
SET precio = precio * 1.05
WHERE id_categoria = 3;


INSERT INTO HISTORICO_PRECIOS (id_producto, precio_anterior, precio_nuevo, fecha_cambio)
SELECT 
    id_producto,
    precio / 1.05 AS precio_anterior,
    precio AS precio_nuevo,
    NOW() AS fecha_cambio
FROM PRODUCTO
WHERE id_categoria = 3;

--24
DELETE FROM CLIENTE
WHERE id_cliente NOT IN (
    SELECT id_cliente
    FROM PEDIDO
);

--25
INSERT INTO PRODUCTO (nombre, id_categoria, precio, stock)
SELECT 
    CONCAT('OFERTA_', nombre) AS nombre,
    id_categoria,
    precio,
    stock
FROM PRODUCTO
WHERE id_categoria = 2;

--26
SELECT 
    id_pedido, 
    COUNT(*) AS total_acciones
FROM 
    AUDITORIA_PEDIDOS
GROUP BY 
    id_pedido
ORDER BY 
    total_acciones DESC
LIMIT 5;

--27
SELECT 
    p.nombre
FROM 
    PRODUCTO p
WHERE 
    p.precio = (
        SELECT MAX(p2.precio)
        FROM PRODUCTO p2
        WHERE p2.id_categoria = p.id_categoria
    );

--28
SELECT 
    c.nombre AS nombre_cliente,
    p.fecha_pedido,
    p.estado
FROM 
    CLIENTE c
LEFT JOIN PEDIDO p
    ON p.id_pedido = (
        SELECT id_pedido
        FROM PEDIDO p2
        WHERE p2.id_cliente = c.id_cliente
        ORDER BY fecha_pedido DESC
        LIMIT 1
    );

--29
SELECT 
    p.nombre,
    p.stock - IF(pd.total_vendido IS NULL, 0, pd.total_vendido) AS stock_restante
FROM 
    PRODUCTO p
LEFT JOIN (
    SELECT 
        id_producto, 
        SUM(cantidad) AS total_vendido
    FROM DETALLE_PEDIDO
    GROUP BY id_producto
) pd ON pd.id_producto = p.id_producto;

--30
SELECT
    (SELECT COUNT(*) FROM CLIENTE) AS total_clientes,
    (SELECT COUNT(*) FROM PEDIDO) AS total_pedidos,
    (SELECT COUNT(*) FROM PEDIDO) / (SELECT COUNT(*) FROM CLIENTE) AS pedidos_por_cliente;

