-- Top 5 Customers by Total Sales Amount in 2023

SELECT
    c.name,
    SUM(t.total_sales_amount) AS total_sales
FROM transformed_sales_data t
JOIN customers c ON t.customer_id = c.id
GROUP BY c.name
ORDER BY total_sales DESC
LIMIT 5;

