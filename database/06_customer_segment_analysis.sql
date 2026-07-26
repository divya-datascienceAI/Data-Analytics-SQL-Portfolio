with  table_join as
(
select c.customer_id,c.customer_name,c.customer_segment,
o.order_id,o.order_date,o.total_amount,o.payment_method,
i.item_id,i.discount, i.unit_price,i.quantity,i.category
from customers c 
left join orders o
on c.customer_id=o.customer_id
left join order_items i
on o.order_id=i.order_id 
)
select 
customer_name,customer_segment,
count(customer_id) as total_customer,
count(order_id) as total_orders,
sum(total_amount) as total_amount_spend,
count(payment_method) as count_of_pay_method
from table_join
group by customer_segment,customer_name,payment_method
order by count_of_pay_method desc;

-----------------------------------------------
