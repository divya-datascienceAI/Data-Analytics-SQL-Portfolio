with  table_join as
(
select c.customer_id,c.customer_name,c.customer_segment,o.order_id,o.order_date,o.total_amount,o.order_status,
i.item_id,i.discount, i.unit_price,i.quantity,i.category
from customers c 
left join orders o
on c.customer_id=o.customer_id
left join order_items i
on o.order_id=i.order_id 
)
select customer_name,category,customer_segment,order_status,sum(total_amount) as sales_amount
from table_join
where  order_status ="completed"
group by customer_name,category,customer_segment,order_status
having sum(total_amount)>1000
order by sales_amount desc;
