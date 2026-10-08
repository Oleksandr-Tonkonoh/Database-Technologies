CREATE INDEX idx_orders_customer_id
ON orders USING HASH (customer_id);

SELECT * 
FROM orders 
WHERE customer_id = 'C001';


CREATE INDEX idx_orders_order_date 
ON orders(order_date);

SELECT 
DATE_TRUNC('month', order_date) AS month,
SUM(sales) AS sum
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);


CREATE INDEX idx_orders_region_category
ON orders(customer_id, order_date);


SELECT * 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.region = 'West' AND
o.order_date > '2024-01-01';


EXPLAIN ANALYZE
SELECT * FROM 
orders 
WHERE customer_id = 'C001'