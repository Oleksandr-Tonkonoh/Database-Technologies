-- Active: 1790175058178@@127.0.0.1@5432@superstore
-- Active: 1790175058178@@127.0.0.1@5432@retail_sales
CREATE DATABASE retail_sales;

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    region VARCHAR(20) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ship_mode VARCHAR(30) NOT NULL,
    sales NUMERIC(10, 2) NOT NULL,
    profit NUMERIC(10, 2) NOT NULL
);

ALTER DATABASE retail_sales SET datestyle TO 'ISO, MDY';

SELECT *
FROM orders;


CREATE PROCEDURE get_customer_sales(p_customer_id VARCHAR)
LANGUAGE plpgsql
AS $procedure$
DECLARE v_total_sales NUMERIC(10, 2);
BEGIN
    SELECT SUM(sales)
    INTO v_total_sales
    FROM orders
    WHERE customer_id = p_customer_id;

    RAISE NOTICE 'Zákazník % má celkový predaj %', p_customer_id, COALESCE(v_total_sales, 0);
END;
$procedure$;

CALL get_customer_sales('C001');


-- Active: 1790175058178@@127.0.0.1@5432@retail_sales
CREATE PROCEDURE apply_regional_discount(region_name VARCHAR, discount_rate NUMERIC)
LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE orders
    SET sales = sales * (1 - discount_rate)
    WHERE region = region_name;
    
    RAISE NOTICE 'Región %, použitá zľava %', region_name, discount_rate;
END;
$procedure$;

CALL apply_regional_discount('West', 0.10);


-- Active: 1790175058178@@127.0.0.1@5432@superstore
CREATE PROCEDURE get_sales_between(start_date DATE, end_date DATE)
LANGUAGE plpgsql
AS $procedure$
DECLARE v_total_sales NUMERIC(10, 2);
BEGIN
    SELECT SUM(sales)
    INTO v_total_sales
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;

    RAISE NOTICE 'Začiatok obdobia: %, koniec obdobia: %, celková hodnotu predaja: %',
                 start_date, end_date, COALESCE(v_total_sales, 0); 
END;
$procedure$;


CALL get_sales_between('2024-01-01', '2024-03-31');


