CREATE TABLE dm_customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    ContactName VARCHAR(50),
    Address VARCHAR(50),
    City VARCHAR(20),
    PostalCode VARCHAR(10),
    Country VARCHAR(15)
);


CREATE TABLE dm_date (
    DateID INT PRIMARY KEY,
    Day INT,
    Week INT,
    Month INT,
    Year INT,
    Quarter INT
);


CREATE TABLE dm_employees (
    EmployeeID INT PRIMARY KEY,
    LastName VARCHAR(15),
    FirstName VARCHAR(15),
    Notes VARCHAR(1024)
);


CREATE TABLE dm_products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    SupplierID INT,
    CategoryID INT,
    Unit VARCHAR(25),
    SupplierName VARCHAR(50),
    SupplierContactName VARCHAR(50),
    SupplierAddress VARCHAR(50),
    SupplierCity VARCHAR(20),
    SupplierPostalCode VARCHAR(10),
    SupplierCountry VARCHAR(15),
    CategoryName VARCHAR(25)
);


CREATE TABLE dm_shippers (
    ShipperID INT PRIMARY KEY,
    ShipperName VARCHAR(25)
);


CREATE TABLE fact_sales (
    SaleID INT PRIMARY KEY,
    OrderDate DATETIME,
    Quantity INT(11),
    Price DECIMAL(10, 0),
    dm_customers_CustomerID INT,
    dm_shippers_ShipperID INT,
    dm_products_ProductID INT,
    dm_date_DateID INT,
    dm_employees_EmployeeID INT,
    CONSTRAINT fk_fact_sales_customer_id FOREIGN KEY(dm_customers_CustomerID) REFERENCES dm_customers(CustomerID),
    CONSTRAINT fk_fact_sales_shipper_id FOREIGN KEY(dm_shippers_ShipperID) REFERENCES dm_shippers(ShipperID),
    CONSTRAINT fk_fact_sales_product_id FOREIGN KEY(dm_products_ProductID) REFERENCES dm_products(ProductID),
    CONSTRAINT fk_fact_sales_date_id FOREIGN KEY(dm_date_DateID) REFERENCES dm_date(DateID),
    CONSTRAINT fk_fact_sales_employee_id FOREIGN KEY(dm_employees_EmployeeID) REFERENCES dm_employees(EmployeeID)
);