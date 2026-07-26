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
select year(order_date) as years,
monthname(order_date) as month_name,
count(distinct(order_id)) as total_order,sum(total_amount)
from table_join
where year(order_date) ="2024" and (month(order_date) = "1" or month(order_date)="2")
group by years,month_name;
