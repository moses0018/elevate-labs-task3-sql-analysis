-- =========================================
-- TASK 3: SQL FOR DATA ANALYSIS
-- DATABASE: ecommerce_db
-- =========================================

-- Select the database
USE ecommerce_db;

-- =========================================
-- PHASE 1: BASIC QUERIES
-- =========================================

-- Q1: View entire tables
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

-- Q2: Get all customers from USA
SELECT customer_name, country FROM customers
WHERE country = 'USA';

-- Q3: Products costing more than 100
SELECT product_name, price FROM products
WHERE price > 100;


-- =========================================
-- PHASE 2: JOINS + GROUP BY + AGGREGATION
-- =========================================

-- Q4: Orders with customer details
SELECT o.order_id, c.customer_name, o.order_date, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Q5: Ordered products with quantity and subtotal
SELECT o.order_id, p.product_name, oi.quantity, oi.subtotal
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN orders o ON oi.order_id = o.order_id;

-- Q6: Total sales per product
SELECT p.product_name, SUM(oi.subtotal) AS total_sales
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;

-- Q7: Total revenue per customer
SELECT c.customer_name, SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_revenue DESC;

-- Q8: Count of orders per customer
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;


-- =========================================
-- PHASE 3: ADVANCED (SUBQUERIES, VIEWS, INDEX)
-- =========================================

-- Q9: Customers with above-average revenue
SELECT customer_name, total_revenue
FROM (
    SELECT c.customer_name, SUM(o.total_amount) AS total_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_name
) AS revenue_table
WHERE total_revenue > (
    SELECT AVG(t.total_revenue)
    FROM (
        SELECT SUM(total_amount) AS total_revenue
        FROM orders
        GROUP BY customer_id
    ) AS t
);

-- Q10: Products never ordered
SELECT product_name
FROM products
WHERE product_id NOT IN (SELECT product_id FROM order_items);

-- Q11: Create a View for customer revenue summary
CREATE OR REPLACE VIEW customer_revenue_view AS
SELECT c.customer_name, c.country, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.country
ORDER BY total_spent DESC;

-- View the results
SELECT * FROM customer_revenue_view;

-- Q12: Create an index to optimize product searches
CREATE INDEX idx_product_name ON products(product_name);

-- View index info
SHOW INDEX FROM products;

-- =========================================
-- END OF FILE
-- =========================================
