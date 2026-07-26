WITH table_join AS
(
    SELECT 
        c.customer_id,
        c.customer_name,
        c.registration_date,
        o.order_id,
        o.order_date,
        o.total_amount,
        i.item_id,
        i.quantity,
        i.unit_price,
        i.category
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items i
        ON o.order_id = i.order_id
),

customer_cohort AS
(
    SELECT
        customer_id,
        customer_name,
        DATE_FORMAT(registration_date,'%Y-%m') AS cohort_month
    FROM customers
),

cohort_revenue AS
(
    SELECT
        cc.cohort_month,

        COUNT(DISTINCT cc.customer_id) AS total_customers,

        SUM(
            CASE
                WHEN YEAR(t.order_date)=2024 
                AND MONTH(t.order_date)=1
                THEN t.quantity * t.unit_price
                ELSE 0
            END
        ) AS jan_revenue,

        SUM(
            CASE
                WHEN YEAR(t.order_date)=2024 
                AND MONTH(t.order_date)=2
                THEN t.quantity * t.unit_price
                ELSE 0
            END
        ) AS feb_revenue

    FROM customer_cohort cc

    LEFT JOIN table_join t
        ON cc.customer_id=t.customer_id

    GROUP BY cc.cohort_month
)

SELECT
    cohort_month,
    total_customers,
    jan_revenue,
    feb_revenue,

    CASE
        WHEN jan_revenue = 0 THEN NULL
        ELSE 
        ((feb_revenue - jan_revenue) / jan_revenue) * 100
    END AS revenue_growth_percentage

FROM cohort_revenue
ORDER BY cohort_month;
