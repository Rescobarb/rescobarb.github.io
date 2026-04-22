USE sys

SELECT * 
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees) AND hire_date < '2021-01-01';

SELECT *
FROM products AS p
WHERE p.price < (SELECT AVG(p2.price) FROM products AS p2 WHERE p2.category = p.category);

SELECT p.category, SUM(s.quantity*p.price) AS total
FROM sales s 
JOIN products p ON s.product_id = p.id 
GROUP BY p.category

SELECT e.id, e.name, SUM(s.quantity) as total_vendido
FROM employees e
JOIN sales s ON s.employee_id = e.id
GROUP BY e.id, e.name
ORDER BY total_vendido DESC 
LIMIT 1;

SELECT e.id, e.name, SUM(s.quantity) as total_vendido
FROM employees e
JOIN sales s ON s.employee_id = e.id
GROUP BY e.id, e.name
ORDER BY total_vendido DESC 
LIMIT 1;

SELECT p.id, p.name, p.category, p.price
FROM sales s
JOIN employees e ON s.employee_id = e.id 
JOIN products p ON s.product_id = p.id 
WHERE e.name like 'Emma Jonhson'; -- Emma Jonhson no existe en la base de datos

SELECT *
FROM sales
WHERE sale_date > (SELECT FROM_UNIXTIME(AVG(UNIX_TIMESTAMP(SALE_DATE)))FROM sales);

SELECT DISTINCT e.name , e.salary AS total_salarios
FROM employees e
ORDER BY total_salarios DESC
lIMIT 1 OFFSET 1;

SELECT e.name, SUM(quantity) AS total_ventas
FROM sales
JOIN employees e
ON employee_id = e.id
GROUP BY employee_id
ORDER BY total_ventas DESC
LIMIT 5;

SELECT s.* , e.name AS empleado
FROM sales s
JOIN employees e
ON employee_id = e.id
ORDER BY s.sale_date DESC
LIMIT 1;

SELECT e.name, SUM(quantity) AS total_ventas
FROM sales
JOIN employees e
ON employee_id = e.id
GROUP BY employee_id
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales