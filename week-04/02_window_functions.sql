-- Active: 1790175058178@@127.0.0.1@5432@superstore
WITH orders_ranked AS (
    SELECT c.customer_name,
           o.order_id,
           o.order_date,
           ROW_NUMBER() OVER(
                PARTITION BY o.customer_id
                ORDER BY o.order_date DESC
           ) AS r_n
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
)

SELECT customer_name,
       order_id,
       order_date
FROM orders_ranked
WHERE r_n BETWEEN 1 AND 2
ORDER BY customer_name, r_n;


WITH customer_total_profit AS (
    SELECT c.region,
           c.customer_name,
           SUM(o.profit) AS total_profit
    FROM customers c 
    JOIN orders o on c.customer_id = o.customer_id
    GROUP BY c.region, c.customer_name
)

SELECT region,
       customer_name,
       total_profit,
       RANK() OVER(
            PARTITION BY region
            ORDER BY total_profit DESC
       ) AS profit_rank,
       DENSE_RANK() OVER(
            PARTITION BY region
            ORDER BY total_profit DESC
       ) AS profit_dense_rank 
FROM customer_total_profit;


WITH customers_total_sales AS (
    SELECT c.customer_name,
           SUM(o.sales) AS total_sales
    FROM customers c 
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_name
)

SELECT customer_name,
       total_sales,
       NTILE(4) OVER(
            ORDER BY total_sales DESC
       ) AS quartile
FROM customers_total_sales;


WITH sales_by_month AS (
    SELECT DATE_TRUNC('month', order_date) AS month,
           SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)

SELECT month,
       monthly_sales,
       LAG(monthly_sales, 1) 
       OVER(ORDER BY month) AS prev_month_sales,
       LEAD(monthly_sales, 1) 
       OVER(ORDER BY month) AS next_month_sales
FROM sales_by_month
ORDER BY month;


WITH sales_by_product AS (
    SELECT p.category,
           p.product_name,
           SUM(o.sales) AS product_sales
    FROM orders o
    JOIN products p ON o.product_id = p.product_id 
    GROUP BY p.category, p.product_name 
),

category_sales AS (
    SELECT category,
           product_name,  
           product_sales,
           SUM(product_sales) OVER(
                PARTITION BY category
           ) AS category_total
    FROM sales_by_product
)

SELECT category,
       product_name,  
       product_sales,
       category_total,
       ROUND((product_sales * 100.0 / category_total), 2) AS pct_of_category
FROM category_sales;


WITH customer_last_order_date AS (
    SELECT c.customer_id,
           c.customer_name,
           MAX(o.order_date) OVER(
                PARTITION BY c.customer_id
           ) AS last_order_date,
           MAX(o.order_date) OVER() AS latest_order_date
    FROM customers c 
    JOIN orders o ON c.customer_id = o.customer_id
)

SELECT DISTINCT customer_id,
       customer_name,
       last_order_date
FROM customer_last_order_date
WHERE latest_order_date - last_order_date > 90
ORDER BY last_order_date;


WITH sales_by_month AS (
    SELECT DATE_TRUNC('month', order_date) AS month,
           SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),

sales_by_prev_month AS (
    SELECT month,
           monthly_sales,
           LAG(monthly_sales) OVER (ORDER BY month) AS prev_month_sales
    FROM sales_by_month
)

SELECT month,
       monthly_sales,
       prev_month_sales,
       monthly_sales - prev_month_sales AS sales_change,
       ROUND(((monthly_sales - prev_month_sales) / prev_month_sales) * 100.0, 2) 
       AS growth_percentage
FROM sales_by_prev_month
ORDER BY month;


WITH customer_first_order_month AS (
    SELECT customer_id,
           MIN(
                DATE_TRUNC('month', order_date)
            ) AS first_order_month
    FROM orders
    GROUP BY customer_id
),

customers_with_first_order_in_june AS (
    SELECT customer_id
    FROM customer_first_order_month 
    WHERE first_order_month = '2024-06-01'
)

SELECT customer_id
FROM customers_with_first_order_in_june c
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id AND
    order_date >= '2024-07-01'
);