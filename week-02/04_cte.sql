-- Active: 1790175058178@@127.0.0.1@5432@datacraftinglab_db
WITH daily_sales AS (
    SELECT DATE_TRUNC('day', sale_date) AS day, SUM(total_amount) AS total_daily_sales
    FROM flourmills_sales
    GROUP BY DATE_TRUNC('day', sale_date)
)

SELECT day AS sale_date, total_daily_sales
FROM daily_sales
WHERE total_daily_sales > 3000000
ORDER BY total_daily_sales DESC;


WITH category_sales AS (
    SELECT product_category, SUM(total_amount) AS total_category_sales
    FROM flourmills_sales
    GROUP BY product_category
)

SELECT * FROM category_sales
ORDER BY total_category_sales DESC;


WITH product_sales AS (
    SELECT product_category, product_name, SUM(total_amount) AS total_product_sales
    FROM flourmills_sales
    GROUP BY product_category, product_name
),

ranked_products AS (
    SELECT product_category, product_name, total_product_sales,
           RANK() OVER(PARTITION BY product_category ORDER BY total_product_sales DESC) AS category_rank
    FROM product_sales
)

SELECT product_category, product_name, total_product_sales, category_rank
FROM ranked_products
WHERE category_rank BETWEEN 1 AND 3
ORDER BY product_category, category_rank;


WITH customers_revenue AS (
    SELECT customer_type, SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY customer_type
),

customers_revenue_percentage AS (
    SELECT customer_type, revenue, 
           SUM(revenue) OVER() AS total_revenue,
           ROUND(revenue  * 100.0 / SUM(revenue) OVER(), 2) AS revenue_percentage
    FROM customers_revenue
)

SELECT customer_type, revenue, total_revenue, revenue_percentage
FROM customers_revenue_percentage
ORDER BY revenue DESC;


WITH customers_orders AS (
    SELECT customer_id, product_name, sale_date, total_amount,
           ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY sale_date DESC) AS sale_date_rank
    FROM flourmills_sales
)

SELECT customer_id, product_name, sale_date, total_amount
FROM customers_orders 
WHERE sale_date_rank = 1
ORDER BY customer_id;


WITH RECURSIVE min_max_date AS (
    SELECT MIN(sale_date) AS first_sale_date, MAX(sale_date) AS last_sale_date
    FROM flourmills_sales
),

dates AS (
    SELECT first_sale_date AS date, last_sale_date
    FROM min_max_date

    UNION ALL

    SELECT date + 1, last_sale_date
    FROM dates
    WHERE date < last_sale_date
)

SELECT date
FROM dates;


WITH RECURSIVE monthly_revenue AS (
    SELECT DATE_TRUNC('month', sale_date) AS month,
           SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY DATE_TRUNC('month', sale_date)
),

ordered_months AS (
    SELECT month, revenue, 
           ROW_NUMBER() OVER(ORDER BY month) AS rn
    FROM monthly_revenue
),

cumulative_target AS ( 
    SELECT rn, month, revenue, revenue AS cumulative_revenue
    FROM ordered_months
    WHERE rn = 1

    UNION ALL

    SELECT om.rn, om.month, om.revenue, ct.cumulative_revenue + om.revenue AS cumulative_revenue
    FROM cumulative_target ct
    JOIN ordered_months om on om.rn = ct.rn + 1
    WHERE ct.cumulative_revenue < 500000000
)

SELECT *
FROM cumulative_target
WHERE cumulative_revenue >= 500000000
ORDER BY rn
LIMIT 1;




