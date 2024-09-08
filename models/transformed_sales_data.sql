WITH sales AS (
    SELECT
        *,
        TO_DATE(order_date, 'MM/DD/YYYY') AS order_date_casted, 
        EXTRACT(YEAR FROM TO_DATE(order_date, 'MM/DD/YYYY')) AS year,
        EXTRACT(MONTH FROM TO_DATE(order_date, 'MM/DD/YYYY')) AS month,
        EXTRACT(DAY FROM TO_DATE(order_date, 'MM/DD/YYYY')) AS day,
        quantity * price AS total_sales_amount
    FROM {{ ref('sales') }}
)

SELECT
    order_id,
    customer_id,
    product_name,
    year,
    month,
    total_sales_amount
FROM sales
WHERE year = 2023

