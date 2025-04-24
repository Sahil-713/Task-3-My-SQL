
# 📦 Order_Details1 Database

This project sets up a sample e-commerce order management database named **`Order_Details1`**. It models customer information, product inventory, order processing, and includes analytical SQL queries and views for reporting purposes.

---

## 🗃️ Database Schema

### Customers Table
```sql
CustomerID INT PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Country VARCHAR(50)
```

### Products Table
```sql
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100),
Category VARCHAR(50),
Price DECIMAL(10, 2)
```

### Orders Table
```sql
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
```

### OrderDetails Table
```sql
OrderDetailID INT PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
```

---

## 🧪 Sample Data

The database comes pre-filled with:
- 4 customers
- 4 products
- 4 orders
- 6 order detail entries

This makes it ideal for practicing SQL queries and relational database operations.

---

## 🔍 Key SQL Features & Queries

### 1. 💰 Total Spending by Customer
```sql
SELECT Customers.Name, SUM(Products.Price * OrderDetails.Quantity) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Customers.Name
ORDER BY TotalSpent DESC;
```

### 2. 🛒 Most Sold Products (Quantity > 2)
```sql
SELECT ProductName
FROM Products
WHERE ProductID IN (
    SELECT ProductID
    FROM OrderDetails
    GROUP BY ProductID
    HAVING SUM(Quantity) > 2
);
```

### 3. 📊 Create a View for Customer Spending
```sql
CREATE VIEW CustomerSpendingNew AS
SELECT Customers.Name, SUM(Products.Price * OrderDetails.Quantity) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Customers.Name;
```

### 4. 🔀 Combine Orders with LEFT and RIGHT JOIN (UNION)
```sql
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
```

### 5. ⚡ Index for Optimization
```sql
CREATE INDEX idx_order_customer ON Orders(CustomerID);
```

---

## 🧩 Bonus Queries

### Customers from India
```sql
SELECT * FROM Customers WHERE Country = 'India';
```

### Average Order Value
```sql
SELECT AVG(Products.Price * OrderDetails.Quantity) AS AvgOrderValue
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID;
```

### Handle NULLs using COALESCE
```sql
SELECT Name, COALESCE(Email, 'No Email Provided') AS EmailAddress
FROM Customers;
```

---

## 📋 Requirements

- MySQL, MariaDB, or any SQL-compliant RDBMS
- SQL client or IDE (e.g., MySQL Workbench, DBeaver, DataGrip)

---

## ✅ Notes

- Designed for testing, learning, and demonstrating relational SQL queries.
- Foreign key constraints ensure referential integrity.
- Views and indexes improve data access and performance.

--
