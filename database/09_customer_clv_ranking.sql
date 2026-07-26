use inventory;
with  table_join as
(
select c.customer_id,c.customer_name,o.order_id,o.order_date,o.total_amount,
i.item_id,i.discount, i.unit_price,i.quantity,i.category,i.product_name
from customers c 
left join orders o
on c.customer_id=o.customer_id
left join order_items i
on o.order_id=i.order_id 
),
customer_summary as
(select customer_name,count(order_id) as total_orders,
sum(total_amount) as total_spend
from table_join
group by customer_name)

select customer_name,total_orders,total_spend,
SUM(total_spend) OVER(
        ORDER BY total_spend DESC
    ) AS running_total,
dense_rank() over ( order by total_spend desc) as customer_rank,
percent_rank() over( order by total_spend desc) as percentile_rank
from customer_summary;
