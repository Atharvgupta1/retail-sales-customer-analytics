DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate TIMESTAMP,   
    UnitPrice NUMERIC(10,2), 
    CustomerID INT,
    Country VARCHAR(100),
    TotalPrice NUMERIC(10,2));

--Data Validation
SELECT COUNT(*) AS total_rows FROM transactions;
SELECT * FROM transactions LIMIT 10;

-- 4. Total Revenue
SELECT ROUND(SUM(TotalPrice), 2) AS total_revenue
FROM transactions;

-- 5. Revenue by Country
SELECT Country, ROUND(SUM(TotalPrice), 2) AS revenue
FROM transactions
GROUP BY Country
ORDER BY revenue DESC;

-- 6. Top 10 Products by Quantity
SELECT Description, SUM(Quantity) AS total_quantity_sold
FROM transactions
GROUP BY Description
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- 7. Top 10 Products by Revenue
SELECT Description, ROUND(SUM(TotalPrice), 2) AS revenue
FROM transactions
GROUP BY Description
ORDER BY revenue DESC
LIMIT 10;

-- 8. Top Customers
SELECT CustomerID, ROUND(SUM(TotalPrice), 2) AS total_spent
FROM transactions
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 10;

-- 9. Monthly Revenue Trend
SELECT TO_CHAR(InvoiceDate, 'YYYY-MM') AS month,
       ROUND(SUM(TotalPrice), 2) AS revenue
FROM transactions
GROUP BY month
ORDER BY month;

-- 10. Repeat vs One-Time Customers
WITH customer_orders AS (
    SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS order_count
    FROM transactions
    GROUP BY CustomerID)
SELECT 
    CASE 
        WHEN order_count = 1 THEN 'One-Time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY customer_type;

-- 11. Average Order Value
SELECT ROUND(SUM(TotalPrice) / COUNT(DISTINCT InvoiceNo), 2) AS avg_order_value
FROM transactions;

-- 12. Customer Purchase Frequency
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS total_orders
FROM transactions
GROUP BY CustomerID
ORDER BY total_orders DESC;

-- 13. RFM Analysis
SELECT CustomerID,
       CURRENT_DATE - MAX(InvoiceDate)::DATE AS recency_days,
       COUNT(DISTINCT InvoiceNo) AS frequency,
       ROUND(SUM(TotalPrice), 2) AS monetary
FROM transactions
GROUP BY CustomerID;

-- 14. Customer Lifetime Value
SELECT CustomerID,
       ROUND(SUM(TotalPrice), 2) AS customer_lifetime_value
FROM transactions
GROUP BY CustomerID
ORDER BY customer_lifetime_value DESC;

-- 15. Top Countries by Customers
SELECT Country,
       COUNT(DISTINCT CustomerID) AS total_customers
FROM transactions
GROUP BY Country
ORDER BY total_customers DESC;