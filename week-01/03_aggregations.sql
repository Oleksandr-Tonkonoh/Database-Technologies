SELECT c.region, COALESCE(SUM(o.sales), 0) AS total_sales
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;


SELECT p.product_name, COALESCE(SUM(o.sales), 0) AS total_sales
FROM products p 
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;


SELECT c.region, COALESCE(SUM(o.sales), 0) AS total_sales
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;


SELECT c.customer_name, COUNT(o.order_id) AS orders_count
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.customer_name;


SELECT p.category, AVG(o.discount) AS avg_discount 
FROM products p 
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category


SELECT c.customer_name, SUM(o.sales) AS total_sales 
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.sales) > 2000;


SELECT c.region, 
       COALESCE(SUM(o.sales), 0) AS total_sales, 
       ROUND(COALESCE(AVG(o.discount), 0), 2) AS avg_discount, 
       COUNT(o.order_id) AS orders_count
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;


SELECT c.region, SUM(CASE WHEN o.sales > 1000 THEN 1 ELSE 0 END) AS high_value,
                 SUM(CASE WHEN o.sales <= 1000 THEN 1 ELSE 0 END) AS low_value
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;


SELECT c.customer_name, COALESCE(SUM(o.sales), 0) AS total_sales, 
                        ROUND(COALESCE(AVG(o.discount), 0), 2) AS avg_discount,
                        COUNT(o.order_id) AS orders_count,
                        CASE 
                            WHEN SUM(o.sales) > 2500 THEN 'VIP'
                            ELSE 'REGULAR' 
                        END AS customer_type
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_sales DESC;