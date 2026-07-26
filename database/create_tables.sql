use inventory;

-- =============================================
-- STEP 1: Drop existing tables (if any)
-- =============================================
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- =============================================
-- STEP 2: Create tables with AUTO_INCREMENT
-- =============================================
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE,
    customer_segment VARCHAR(20)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(20),
    payment_method VARCHAR(30),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,  -- AUTO_INCREMENT added!
    order_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(5,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- =============================================
-- STEP 3: Insert Customers (200 rows)
-- =============================================
SET SESSION cte_max_recursion_depth = 10000;

INSERT INTO customers (customer_id, customer_name, email, city, registration_date, customer_segment)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 200
)
SELECT 
    n AS customer_id,
    CONCAT(
        ELT(FLOOR(1 + RAND()*10), 
            'Alice','Bob','Carol','David','Eve','Frank','Grace','Henry','Ivy','Jack'),
        ' ',
        ELT(FLOOR(1 + RAND()*10),
            'Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis','Rodriguez','Martinez')
    ) AS customer_name,
    CONCAT(
        LOWER(ELT(FLOOR(1 + RAND()*10),
            'alice','bob','carol','david','eve','frank','grace','henry','ivy','jack')),
        FLOOR(RAND()*1000),
        '@email.com'
    ) AS email,
    ELT(FLOOR(1 + RAND()*10),
        'New York','Los Angeles','Chicago','Miami','San Francisco','Boston','Seattle','Denver','Austin','Portland'
    ) AS city,
    DATE_SUB('2024-01-01', INTERVAL FLOOR(RAND()*365) DAY) AS registration_date,
    ELT(FLOOR(1 + RAND()*4),
        'Premium','Gold','Silver','Bronze'
    ) AS customer_segment
FROM numbers;

-- =============================================
-- STEP 4: Insert Orders (700 rows)
-- =============================================
INSERT INTO orders (order_id, customer_id, order_date, order_status, payment_method, total_amount)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 700
)
SELECT 
    n AS order_id,
    FLOOR(1 + RAND()*200) AS customer_id,
    DATE_SUB('2024-02-28', INTERVAL FLOOR(RAND()*90) DAY) AS order_date,
    ELT(FLOOR(1 + RAND()*3),
        'Completed','Pending','Cancelled'
    ) AS order_status,
    ELT(FLOOR(1 + RAND()*4),
        'Credit Card','PayPal','Debit Card','Bank Transfer'
    ) AS payment_method,
    ROUND(50 + RAND()*800, 2) AS total_amount
FROM numbers;

-- =============================================
-- STEP 5: Insert Order Items - BATCH 1
-- (Without specifying item_id - AUTO_INCREMENT handles it)
-- =============================================
INSERT INTO order_items (order_id, product_name, category, quantity, unit_price, discount)
WITH numbers AS (
    SELECT 
        (a.n - 1) * 100 + b.n AS n
    FROM 
        (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
         UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
         UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
         UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20) a
        CROSS JOIN 
        (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
         UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
         UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
         UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20) b
    WHERE (a.n - 1) * 100 + b.n <= 1800
)
SELECT 
    FLOOR(1 + RAND()*700) AS order_id,
    ELT(FLOOR(1 + RAND()*20),
        'Laptop','Smartphone','Tablet','Headphones','Smart Watch','Bluetooth Speaker',
        'Monitor','Keyboard','Mouse','USB Cable','Phone Case','Screen Protector',
        'T-shirt','Jeans','Jacket','Shoes','Socks','Hat','Scarf','Gloves'
    ) AS product_name,
    ELT(FLOOR(1 + RAND()*4),
        'Electronics','Electronics','Electronics','Clothing'
    ) AS category,
    FLOOR(1 + RAND()*3) AS quantity,
    ROUND(20 + RAND()*500, 2) AS unit_price,
    ROUND(RAND()*20, 2) AS discount
FROM numbers;

-- =============================================
-- STEP 6: Insert Order Items - BATCH 2 (300 rows)
-- =============================================
INSERT INTO order_items (order_id, product_name, category, quantity, unit_price, discount)
WITH numbers AS (
    SELECT 
        (a.n - 1) * 100 + b.n AS n
    FROM 
        (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
         UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
         UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
         UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20) a
        CROSS JOIN 
        (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
         UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
         UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
         UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20) b
    WHERE (a.n - 1) * 100 + b.n <= 300
)
SELECT 
    FLOOR(1 + RAND()*700) AS order_id,
    ELT(FLOOR(1 + RAND()*20),
        'Cookbook','Novel','Desk Lamp','Coffee Maker','Plant Pot','Baking Set',
        'Blender','Toaster','Microwave','Vacuum','Bookshelf','Rug',
        'Pillow','Blanket','Towel','Umbrella','Backpack','Wallet','Belt','Sunglasses'
    ) AS product_name,
    ELT(FLOOR(1 + RAND()*4),
        'Books','Books','Home & Kitchen','Home & Kitchen'
    ) AS category,
    FLOOR(1 + RAND()*3) AS quantity,
    ROUND(15 + RAND()*400, 2) AS unit_price,
    ROUND(RAND()*15, 2) AS discount
FROM numbers;

-- =============================================
-- STEP 7: Verify Data
-- =============================================
SELECT 
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items;

SELECT 
    category,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_items), 2) AS percentage
FROM order_items
GROUP BY category
ORDER BY count DESC;

-- Check auto_increment is working
SELECT MAX(item_id) FROM order_items;

-- Sample data
SELECT * FROM order_items LIMIT 10;

-- Reset recursion limit
SET SESSION cte_max_recursion_depth = 1000;
