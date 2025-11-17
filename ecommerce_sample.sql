
-- Ecommerce Database Schema & Sample Data (MySQL-ready)
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Customers Table
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50),
    signup_date DATE
);

INSERT INTO customers VALUES
(1,'John Doe','john@example.com','USA','2023-01-05'),
(2,'Emma Smith','emma@example.com','UK','2023-02-10'),
(3,'Liam Brown','liam@example.com','Canada','2023-03-12'),
(4,'Sophia Johnson','sophia@example.com','USA','2023-04-20'),
(5,'Ethan Clark','ethan@example.com','Australia','2023-04-22');

-- Products Table
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

INSERT INTO products VALUES
(101,'Laptop','Electronics',950.00),
(102,'Headphones','Electronics',110.50),
(103,'Office Chair','Furniture',150.00),
(104,'Coffee Mug','Kitchen',9.99),
(105,'Smartphone','Electronics',699.00);

-- Orders Table
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders VALUES
(5001,1,'2023-04-25',960.00),
(5002,2,'2023-04-26',110.50),
(5003,3,'2023-04-30',159.99),
(5004,1,'2023-05-01',699.00),
(5005,4,'2023-05-02',150.00);

-- Order Items Table
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items VALUES
(1,5001,101,1,950.00),
(2,5001,104,1,10.00),
(3,5002,102,1,110.50),
(4,5003,103,1,150.00),
(5,5003,104,1,9.99),
(6,5004,105,1,699.00),
(7,5005,103,1,150.00);

SHOW TABLES;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

SELECT customer_name, country FROM customers
WHERE country = 'USA';

SELECT product_name, price FROM products
WHERE price > 100;

SELECT o.order_id, c.customer_name, o.order_date, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

SELECT o.order_id, p.product_name, oi.quantity, oi.subtotal
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN orders o ON oi.order_id = o.order_id;

SELECT p.product_name, SUM(oi.subtotal) AS total_sales
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;

SELECT c.customer_name, SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_revenue DESC;

SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;

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


SELECT product_name
FROM products
WHERE product_id NOT IN (SELECT product_id FROM order_items);

CREATE OR REPLACE VIEW customer_revenue_view AS
SELECT c.customer_name, c.country, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.country
ORDER BY total_spent DESC;

SELECT * FROM customer_revenue_view;

CREATE INDEX idx_product_name ON products(product_name);

SHOW INDEX FROM products;





