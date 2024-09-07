--Top 5 Products by Total Sales Amount in 2023

SELECT
    product_name,
    SUM(total_sales_amount) AS total_sales
FROM transformed_sales_data
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;
