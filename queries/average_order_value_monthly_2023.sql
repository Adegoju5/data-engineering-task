-- Average Order Value for Each Month in 2023

SELECT
    month,
    ROUND(AVG(total_sales_amount), 2) AS average_order_value -- i rounded the average value up to two decimal place
FROM transformed_sales_data
GROUP BY month
ORDER BY month;
