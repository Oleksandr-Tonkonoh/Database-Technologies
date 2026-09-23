SELECT o.order_id, c.customer_name, o.sales 
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
WHERE o.sales > 500;