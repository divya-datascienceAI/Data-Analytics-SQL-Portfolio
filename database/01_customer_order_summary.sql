use inventory;
with  table_join as
(
select c.customer_id,c.customer_name,o.order_id,o.order_date,o.total_amount,i.item_id 
from customers c 
left join orders o
on c.customer_id=o.customer_id
left join order_items i
on o.order_id=i.order_id 
)
select customer_name,count(order_id) as total_orders,
sum(total_amount) as total_amount_spend,
(sum(total_amount)/count(order_id)) as average_order_value
from table_join
group by customer_name
order by total_amount_spend desc;
