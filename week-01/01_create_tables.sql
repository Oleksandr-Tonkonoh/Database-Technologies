-- Active: 1790175058178@@127.0.0.1@5432@superstore


CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50)
);


CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(100)
);


CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
    product_id VARCHAR(20),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    order_date DATE,
    ship_date DATE,
    sales DECIMAL(10, 2),
    quantity INT,
    discount DECIMAL(10, 2),
    profit DECIMAL(10, 2)
);


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
