with  table_join as
(
select c.customer_id,c.customer_name,o.order_id,o.order_date,o.total_amount,
i.item_id,i.discount, i.unit_price,i.quantity,i.category
from customers c 
left join orders o
on c.customer_id=o.customer_id
left join order_items i
on o.order_id=i.order_id 
)
select *
from 
(select category,sum((unit_price * quantity) - discount) as total_revenue 
from table_join
group by category
) as revenue
where total_revenue>500;
