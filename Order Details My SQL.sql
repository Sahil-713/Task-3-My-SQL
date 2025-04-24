-- Create Database
CREATE DATABASE Order_Details1;
USE Order_Details1;

-- Create Tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Country VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert Data
INSERT INTO Customers (CustomerID, Name, Email, Country) VALUES
(1, 'Sahil Kumar', 'sahil@email.com', 'India'),
(2, 'Anya Singh', 'anya@email.com', 'India'),
(3, 'John Carter', 'john@email.com', 'USA'),
(4, 'Maria Gomez', 'maria@email.com', 'Spain');

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(101, 'Bluetooth Speaker', 'Electronics', 49.99),
(102, 'Laptop Sleeve', 'Accessories', 19.99),
(103, 'Wireless Mouse', 'Electronics', 25.00),
(104, 'Coffee Mug', 'Home', 10.00);

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1001, 1, '2023-07-01'),
(1002, 2, '2023-07-03'),
(1003, 1, '2023-07-05'),
(1004, 3, '2023-07-06');

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES
(1, 1001, 101, 2),
(2, 1001, 103, 1),
(3, 1002, 104, 3),
(4, 1003, 102, 2),
(5, 1004, 101, 1),
(6, 1004, 104, 2);

-- Query: Total amount spent by each customer
SELECT Customers.Name, SUM(Products.Price * OrderDetails.Quantity) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Customers.Name
ORDER BY TotalSpent DESC;

-- Query: Products with total quantity sold greater than 2
SELECT ProductName
FROM Products
WHERE ProductID IN (
    SELECT ProductID
    FROM OrderDetails
    GROUP BY ProductID
    HAVING SUM(Quantity) > 2
);

-- View: Customer Spending Summary
CREATE VIEW CustomerSpendingNew AS
SELECT Customers.Name, SUM(Products.Price * OrderDetails.Quantity) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Customers.Name;

-- Union with LEFT JOIN and RIGHT JOIN to show all customer orders and products
SELECT Customers.Name, Orders.OrderID, Products.ProductName, OrderDetails.Quantity
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
LEFT JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
LEFT JOIN Products ON OrderDetails.ProductID = Products.ProductID

UNION

SELECT Customers.Name, Orders.OrderID, Products.ProductName, OrderDetails.Quantity
FROM Customers
RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
RIGHT JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
RIGHT JOIN Products ON OrderDetails.ProductID = Products.ProductID;

-- Create Index for Optimization
CREATE INDEX idx_order_customer ON Orders(CustomerID);

-- 1: Use of WHERE clause (filter customers from India)
SELECT * FROM Customers
WHERE Country = 'India';

-- 2: Average Order Value
SELECT AVG(Products.Price * OrderDetails.Quantity) AS AvgOrderValue
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID;

-- 3: Handling NULL values using COALESCE
SELECT Name, COALESCE(Email, 'No Email Provided') AS EmailAddress
FROM Customers;

