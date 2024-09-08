-- Customer with Highest Order Volume in October 2023

SELECT
    c.name,
    COUNT(t.order_id) AS order_count
FROM transformed_sales_data t
JOIN customers c ON t.customer_id = c.id
WHERE t.month = 10
GROUP BY c.name
ORDER BY order_count DESC
LIMIT 1;

