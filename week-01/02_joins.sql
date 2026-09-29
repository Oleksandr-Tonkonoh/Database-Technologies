SELECT o.order_id, c.customer_name, o.sales 
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
WHERE o.sales > 500;


SELECT o.order_id, c.customer_name, p.category, o.sales
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;


SELECT c.customer_name, o.order_id, o.sales 
FROM customers c 
FULL JOIN orders o ON c.customer_id = o.customer_id;