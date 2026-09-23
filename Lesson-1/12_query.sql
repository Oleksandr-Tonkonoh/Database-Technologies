SELECT c.region, SUM(CASE WHEN o.sales > 1000 THEN 1 ELSE 0 END) AS high_value,
                 SUM(CASE WHEN o.sales <= 1000 THEN 1 ELSE 0 END) AS low_value
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;