CREATE TABLE dm_customer (
    CustomerId INT PRIMARY KEY,
    FirstName VARCHAR(40),
    LastName VARCHAR(20),
    Company VARCHAR(80),
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10)
);


CREATE TABLE dm_date (
    DateId INT PRIMARY KEY,
    Day INT,
    Week INT,
    Month INT,
    Year INT,
    Quarter INT
);


CREATE TABLE dm_employee (
    EmployeeId INT PRIMARY KEY,
    FirstName VARCHAR(20),
    LastName VARCHAR(20),
    Title VARCHAR(30),
    ReportsTo INT,
    HireDate DATETIME,
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10)
);


CREATE TABLE dm_billingAddress (
    AddressId INT PRIMARY KEY,
    BillingAddress VARCHAR(70),
    BillingCity VARCHAR(40),
    BillingState VARCHAR(40),
    BillingCountry VARCHAR(40)
);


CREATE TABLE dm_track (
    TrackId INT PRIMARY KEY,
    TrackName VARCHAR(200),
    Composer VARCHAR(220),
    AlbumId INT,
    MediaTypeId INT,
    GenreId INT
);


CREATE TABLE dm_playlist (
    PlaylistId INT PRIMARY KEY,
    Playlist_Name VARCHAR(120)
);


CREATE TABLE bridge (
    BridgeId INT PRIMARY KEY,
    TrackId INT,
    PlaylistId INT,
    CONSTRAINT fk_bridge_track_id FOREIGN KEY (TrackId) REFERENCES dm_track(TrackId),
    CONSTRAINT fk_bridge_playlist_id FOREIGN KEY (PlaylistId) REFERENCES dm_playlist(PlaylistId)
);


CREATE TABLE fact_sales (
    SaleId INT PRIMARY KEY,
    InvoiceDate DATETIME,
    Total DECIMAL(10,2),
    Track_Miliseconds INT(11),
    Track_Bytes INT(11),
    Quantity INT(11),
    UnitPrice DECIMAL(10,2),
    dm_billingAddress_AddressId INT,
    dm_customer_CustomerId INT,
    dm_date_DateId INT,
    dm_employee_EmployeeId INT,
    dm_track_TrackId INT,
    CONSTRAINT fk_sales_billing_id FOREIGN KEY (dm_billingAddress_AddressId) REFERENCES dm_billingAddress(AddressId),
    CONSTRAINT fk_sales_customer_id FOREIGN KEY (dm_customer_CustomerId) REFERENCES dm_customer(CustomerId),
    CONSTRAINT fk_sales_date_id FOREIGN KEY (dm_date_DateId) REFERENCES dm_date(DateId),
    CONSTRAINT fk_sales_employee_id FOREIGN KEY (dm_employee_EmployeeId) REFERENCES dm_employee(EmployeeId),
    CONSTRAINT fk_sales_track_id FOREIGN KEY (dm_track_TrackId) REFERENCES dm_track(TrackId)
);