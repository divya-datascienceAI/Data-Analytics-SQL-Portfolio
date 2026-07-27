with  table_join as
(
SELECT 
        c.customer_id,
        c.customer_name,
        oi.category,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100)) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name, oi.category
),
category_pivot as(
select customer_name,
MAX(case 
when category="Electronics" then total_spent
else 0
end) as Electronics_spent,
MAX(case 
when category="Clothing" then total_spent
else 0
end) as Clothing_spent
from table_join
group by customer_name
)
select customer_name,
round(Electronics_spent,2) as Electronics_spent,
round(Clothing_spent,2) as Clothing_spent,
round(Electronics_spent+Clothing_spent,2) as Total_spent,
round(case
when Clothing_spent>0 then Electronics_spent/Clothing_spent
else 0
end,2) as ratio_electronics_clothing
from category_pivot
where Electronics_spent>0 and Clothing_spent>0
group by customer_name
order by total_spent desc;
