SELECT c.region, 
       COALESCE(SUM(o.sales), 0) AS total_sales, 
       ROUND(COALESCE(AVG(o.discount), 0), 2) AS avg_discount, 
       COUNT(o.order_id) AS orders_count
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;