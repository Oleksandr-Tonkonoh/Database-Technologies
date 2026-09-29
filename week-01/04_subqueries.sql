CREATE DATABASE datacraftinglab_db;


CREATE TABLE flourmills_sales (
    sales_id INT PRIMARY KEY,
    sale_date DATE,
    region VARCHAR(100),
    state VARCHAR(100),
    product_category VARCHAR(100),
    product_name VARCHAR(150),
    customer_type VARCHAR(100),
    customer_id INT,
    quantity_sold INT,
    unit_price DECIMAL(10, 2),
    discount_rate INT,
    payment_method VARCHAR(100),
    sales_rep VARCHAR(150),
    warehouse VARCHAR(100),
    delivery_status VARCHAR(100),
    order_channel VARCHAR(100),
    batch_number INT,
    production_date DATE,
    total_amount DECIMAL(10, 2)
);


SELECT *
FROM flourmills_sales;


SELECT product_name, total_amount
FROM flourmills_sales
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales
);


SELECT *
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
) 
ORDER BY sales_id;


SELECT product_name, total_amount, (
    SELECT AVG(total_amount)
    FROM flourmills_sales
) as avg_amount
FROM flourmills_sales;


SELECT product_name, total_amount, total_amount / (
    SELECT SUM(total_amount)
    FROM flourmills_sales
) as amount_share
FROM flourmills_sales;


SELECT * FROM (
    SELECT EXTRACT(MONTH FROM sale_date) AS month,
           SUM(total_amount) AS monthly_sales
    FROM flourmills_sales
    GROUP BY EXTRACT(MONTH FROM sale_date)
) as subquery
ORDER BY monthly_sales DESC;


SELECT product_category, total_sales
FROM (
    SELECT product_category, SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
) AS subquery
WHERE total_sales > 50000000
ORDER BY total_sales DESC;


SELECT product_name, product_category, total_amount
FROM flourmills_sales f1
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales f2
    WHERE f1.product_category = f2.product_category
);


SELECT f1.product_name, f1.region, f1.total_amount, (
    SELECT MIN(f2.total_amount)
    FROM flourmills_sales f2
    WHERE f1.region = f2.region
) AS region_min_amount
FROM flourmills_sales f1;


SELECT * 
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1 
    FROM flourmills_sales f2 
    WHERE f1.product_name = f2.product_name
    GROUP BY f2.product_name
    HAVING COUNT(DISTINCT EXTRACT(MONTH FROM f2.sale_date)) > 1
);


SELECT *
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f1.product_category = f2.product_category 
    AND f2.total_amount > 200000   
);


SELECT DISTINCT product_category
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1 
    FROM flourmills_sales f2
    WHERE f1.product_category = f2.product_category
    GROUP BY f2.product_category
    HAVING COUNT(DISTINCT region) > 3
);


SELECT * 
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f1.region = f2.region
    AND EXTRACT(YEAR FROM sale_date) = 2024
);


SELECT DISTINCT product_category
FROM flourmills_sales f1
WHERE NOT EXISTS (
    SELECT 1 
    FROM flourmills_sales f2
    WHERE f1.product_category = f2.product_category
    AND f2.total_amount > 500000
);


SELECT DISTINCT region 
FROM flourmills_sales f1
WHERE NOT EXISTS (
    SELECT 1 
    FROM flourmills_sales f2
    WHERE f1.region = f2.region
    AND f2.product_category = 'Flour'
);