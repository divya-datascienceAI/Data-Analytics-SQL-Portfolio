WITH table_join AS
(
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount,
    i.item_id,
    i.discount,
    i.unit_price,
    i.quantity,
    i.category,
    i.product_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
LEFT JOIN order_items i
ON o.order_id = i.order_id
)

SELECT 
    order_id,
    customer_name,
    COUNT(DISTINCT product_name) AS total_products,
    COUNT(DISTINCT category) AS categories_count,
    SUM(quantity) AS total_quantity,
    SUM(total_amount) AS total_order_value
FROM table_join
GROUP BY 
    order_id,
    customer_name
HAVING COUNT(DISTINCT category) >= 3;
