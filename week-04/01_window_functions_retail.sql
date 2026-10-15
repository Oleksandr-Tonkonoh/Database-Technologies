-- Active: 1790175058178@@127.0.0.1@5432@retail
CREATE DATABASE retail;


CREATE TABLE retail_sales (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(50),
    description TEXT,
    quantity INT,
    invoice_date TIMESTAMP,
    unit_price NUMERIC(10, 2),
    customer_id INT,
    country VARCHAR(100)
);


SELECT *
FROM retail_sales;


SELECT customer_id, 
       invoice_no, 
       invoice_date, 
       quantity,
       unit_price,
       quantity * unit_price AS revenue,
       SUM(quantity * unit_price) 
       OVER(
            PARTITION BY customer_id 
            ORDER BY invoice_date
            ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
        ) AS revenue_last_14_days
FROM retail_sales
WHERE customer_id IS NOT NULL
ORDER BY customer_id, invoice_date;


SELECT stock_code,
       country,
       invoice_date,
       quantity,
       ROUND(AVG(quantity) OVER(
        PARTITION BY stock_code, country
        ORDER BY invoice_date
        RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
       ), 2) AS avg_quantity_7_days
FROM retail_sales
WHERE quantity > 1
ORDER BY stock_code, country, invoice_date;


WITH customer_next_invoice AS( 
    SELECT DISTINCT customer_id,
       invoice_no,
       invoice_date,
       LEAD(invoice_date, 1) OVER(
            PARTITION BY customer_id
            ORDER BY invoice_date
       ) AS next_invoice_date
    FROM retail_sales)

SELECT customer_id,
       invoice_no,
       invoice_date,
       next_invoice_date,
       EXTRACT(DAY FROM (next_invoice_date - invoice_date)) AS days_to_next_invoice
FROM customer_next_invoice
WHERE next_invoice_date IS NOT NULL
ORDER BY days_to_next_invoice DESC;


WITH product_previous_price AS (
    SELECT stock_code,
           invoice_date,
           invoice_no,
           unit_price AS current_price,
           LAG(unit_price) OVER(
            PARTITION BY stock_code
            ORDER BY invoice_date
           ) AS previous_price
    FROM retail_sales
)

SELECT stock_code,
       invoice_no,
       previous_price,
       current_price,
       current_price - previous_price AS price_difference
FROM product_previous_price
WHERE previous_price IS NOT NULL AND
current_price <> previous_price
ORDER BY invoice_date;


WITH customer_total_revenue AS (
    SELECT customer_id,
           SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    WHERE customer_id IS NOT NULL   
    GROUP BY customer_id
)

SELECT customer_id,
       total_amount,
       NTILE(4) OVER(ORDER BY total_amount DESC) AS sales_quartile
FROM customer_total_revenue
ORDER BY total_amount DESC;


WITH monthly_sales AS (
    SELECT country,
           DATE_TRUNC('month', invoice_date) AS month,
           SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    GROUP BY country, DATE_TRUNC('month', invoice_date)
)

SELECT country,
       month,
       total_amount,
       NTILE(4) OVER(PARTITION BY country ORDER BY total_amount DESC) AS sales_quartile
FROM monthly_sales
ORDER BY country, month;


WITH ranked_customers AS(
    SELECT customer_id,
       invoice_no,
       invoice_date,
       stock_code,
       description,
       quantity,
       unit_price,
       ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY invoice_date
        ) AS r_n
FROM retail_sales
WHERE customer_id IS NOT NULL
)

SELECT customer_id,
       invoice_no,
       invoice_date,
       stock_code,
       description,
       quantity,
       unit_price
FROM ranked_customers
WHERE r_n = 1
ORDER BY customer_id;


WITH invoice_ranked AS (
    SELECT invoice_no,
           stock_code,
           description,
           quantity,
           unit_price,
           (quantity * unit_price) AS amount,
           ROW_NUMBER() OVER(
                PARTITION BY invoice_no 
                ORDER BY quantity * unit_price DESC
            ) AS row_num
FROM retail_sales
)

SELECT invoice_no,
       stock_code,
       description,
       quantity,
       unit_price,
       amount,
       row_num
FROM invoice_ranked
WHERE row_num BETWEEN 1 AND 3
ORDER BY invoice_no, row_num;


WITH customer_sales AS (
    SELECT country,
           DATE_TRUNC('month', invoice_date) AS month,
           customer_id,
           SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY country,  DATE_TRUNC('month', invoice_date), customer_id
)

, ranked_customers AS (
    SELECT country,
           month,
           customer_id,
           total_amount,
           DENSE_RANK() OVER(
                PARTITION BY country, month
                ORDER BY total_amount DESC
            ) AS sales_rank
    FROM customer_sales)

SELECT country,
       month,
       customer_id,
       total_amount,
       sales_rank
FROM ranked_customers
WHERE sales_rank BETWEEN 1 AND 5
ORDER BY country, month, sales_rank, customer_id;


WITH invoice_ranked AS (
    SELECT invoice_no,
           stock_code,
           description,
           quantity,
           unit_price,
           DENSE_RANK() OVER(
                PARTITION BY invoice_no
                ORDER BY unit_price DESC
           ) AS price_rank
FROM retail_sales
)

SELECT invoice_no,
       stock_code,
       description,
       quantity,
       unit_price,
       price_rank
FROM invoice_ranked
WHERE price_rank BETWEEN 1 AND 5
ORDER BY invoice_no, price_rank, stock_code;
