CREATE DATABASE EcommerceDB;
USE EcommerceDB;

CREATE TABLE Orders (
    CustomerID INT,
    CustomerStatus VARCHAR(20),
    DateOrderPlaced DATE,
    DeliveryDate DATE,
    OrderID BIGINT PRIMARY KEY,
    ProductID BIGINT,
    QuantityOrdered INT,
    TotalRetailPrice DECIMAL(10,2),
    CostPricePerUnit DECIMAL(10,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/order.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ','       -- each column is separated by a comma
ENCLOSED BY '"'               -- text values are in quotes
LINES TERMINATED BY '\n'      -- each row ends with a new line
IGNORE 1 ROWS                 -- skip the header row in CSV
(CustomerID, CustomerStatus, DateOrderPlaced, DeliveryDate, OrderID, ProductID, QuantityOrdered, TotalRetailPrice, CostPricePerUnit);

DESCRIBE Orders;
SELECT COUNT(*) AS total_rows
FROM Orders;
select * from orders;

CREATE TABLE Products (
    ProductID BIGINT PRIMARY KEY,
    ProductLine VARCHAR(50),
    ProductCategory VARCHAR(50),
    ProductGroup VARCHAR(100),
    ProductName VARCHAR(150),
    SupplierCountry VARCHAR(50),
    SupplierName VARCHAR(100),
    SupplierID INT
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/product.csv'
INTO TABLE Products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductID, ProductLine, ProductCategory, ProductGroup, ProductName, SupplierCountry, SupplierName, SupplierID);

SELECT COUNT(*) AS total_rows
FROM products;
select * from products;

-- 1. Find orders from active customers in 2017 (SELECT, WHERE, ORDER BY, GROUP BY)
SELECT *FROM Orders
WHERE CustomerStatus = 'Platinum'
  AND YEAR(DateOrderplaced) = 2017
ORDER BY TotalRetailPrice DESC;

-- 2. Total revenue per customer
SELECT CustomerID, SUM(TotalRetailPrice) AS TotalRevenue FROM orders
GROUP BY CustomerID
ORDER BY TotalRevenue DESC;

-- INNER JOIN Orders and Products (JOINS)
SELECT o.OrderID, o.CustomerID, p.ProductName, o.QuantityOrdered, o.TotalRetailPrice
FROM Orders o INNER JOIN Products p 
ON o.ProductID = p.ProductID;

-- LEFT JOIN (show orders even if product is missing in Products table)
SELECT o.OrderID, p.ProductName, o.QuantityOrdered
FROM Orders o LEFT JOIN Products p 
ON o.ProductID = p.ProductID;

-- Customers who spent above average (SUBQUERY)
SELECT CustomerID, SUM(TotalRetailPrice) AS TotalSpent FROM orders 
GROUP BY CustomerID HAVING SUM(TotalRetailPrice) > (SELECT AVG(TotalRetailPrice) FROM Orders);

-- Average revenue per customer (AGGREGATE FUNCTIONS)
SELECT AVG(CustomerTotal) AS AvgRevenuePerCustomer
FROM (SELECT CustomerID, SUM(TotalRetailPrice) AS CustomerTotal FROM Orders
    GROUP BY CustomerID) AS customer_revenue;

-- Monthly sales summary view (VIEW)
CREATE VIEW MonthlySales AS
SELECT YEAR(DateOrderPlaced) AS Year, MONTH(DateOrderPlaced) AS Month, SUM(TotalRetailPrice) AS TotalSales FROM orders
GROUP BY YEAR(DateOrderPlaced), MONTH(DateOrderPlaced);
SELECT * FROM MonthlySales;

-- (INDEXES)
CREATE INDEX idx_customer ON Orders(CustomerID);
CREATE INDEX idx_product ON Orders(ProductID);
SELECT * FROM Orders WHERE CustomerID = 7574;
