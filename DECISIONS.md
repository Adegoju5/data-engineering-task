# DECISIONS.md

## 1. Environment Setup

### 1.1. Snowflake Database Setup
- **Database Name**: `home_assignment`
  - Created to store all tables and transformed data for the assignment.
- **Schema Name**: `public`
  - Default schema used to organize tables.
- **Warehouse Name**: `compute_wh`
  - Configured to handle computational resources for queries.

### 1.2. dbt Installation and Configuration
- **dbt Version**: Installed via `pip install dbt-snowflake`.
- **Configuration**: The `profiles.yml` file was configured to connect dbt to Snowflake using the provided account details, database, schema, and credentials.

## 2. Data Ingestion

### 2.1. Downloading CSV Files
- **Files**:
  - `sales.csv`: Contains sales transaction data.
  - `customers.csv`: Contains customer information.
- **Process**:
  - **Download Using cURL**: i used cURL to download the CSV files from the following URLs:
    - `sales.csv`: [Download link](https://bitbucket.org/panther-ci/data-engineering-home-assignment/src/main/data/sales.csv)
    - `customers.csv`: [Download link](https://bitbucket.org/panther-ci/data-engineering-home-assignment/src/main/data/customers.csv)
  - **Commands**:
    ```bash
    curl -O https://bitbucket.org/panther-ci/data-engineering-home-assignment/src/main/data/sales.csv
    curl -O https://bitbucket.org/panther-ci/data-engineering-home-assignment/src/main/data/customers.csv
    ```

### 2.2. Using dbt Seed
- **Files**:
  - `sales.csv`: Contains sales transaction data.
  - `customers.csv`: Contains customer information.
- **Process**:
  - **dbt Seed Command**: Used to load CSV files into Snowflake tables.
    ```bash
    dbt seed
    ```
  - **Tables Created**:
    - `sales`: Stores raw sales data.
    - `customer`: Stores raw customer data.


## 3. Data Transformation

### 3.1. Transformation Model
- **Model File**: `transformed_sales_data.sql`
- **Transformations Applied**:
  - **Extract Date Parts**: Extracted year, month, and day from `order_date` for easier analysis.
  - **Calculate Total Sales**: Computed `total_sales_amount` as `quantity * price`.

- **SQL Code**:
    ```sql
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

    SELECT *
    FROM sales
    WHERE year = 2023

## 3.2. Data Transformation and Optimization process for Targeted Analysis

- The provided SQL code transforms order_date into a DATE type and extracts year, month, and day components for better date handling. It calculates total_sales_amount by multiplying quantity and price. By adding the `WHERE year = 2023` filter, the query optimizes performance by focusing on the relevant data from 2023, reducing the dataset size and improving query efficiency. This logical partitioning allows for faster data retrieval and processing, since the analysis the sales team came up with are (2023) year-specific analysis, we do not need irrelevant rows (non - 2023 year) in our `transformed_sales_data` .

## 4. Data Analysis Queries

### 4.1. Top 5 Products by Total Sales Amount in 2023

- **Query**:
  ```sql
    SELECT
      product_name,
      SUM(total_sales_amount) AS total_sales
    FROM transformed_sales_data
    GROUP BY product_name
    ORDER BY total_sales DESC
    LIMIT 5;


##### The query using ORDER BY with LIMIT is more optimized because it directly utilizes Snowflake’s Top-N sorting capabilities, minimizing the computational overhead by only sorting enough rows to retrieve the top 5 results. In contrast, using the ROW_NUMBER() approach involves additional steps of ranking all rows before filtering, leading to unnecessary processing and complexity. This makes the ORDER BY with LIMIT approach more efficient for retrieving a limited number of top results. 

## 4.2. Top 5 Customers by Total Sales Amount in 2023

- **Query**:
  ```sql
  SELECT
      c.customer_name,
      SUM(t.total_sales_amount) AS total_sales
  FROM transformed_sales_data t
  JOIN raw_customer_data c ON t.customer_id = c.customer_id
  GROUP BY c.customer_name
  ORDER BY total_sales DESC
  LIMIT 5;

##### The provided query is optimized for retrieving the top 5 customers by total sales in 2023 due to its use of aggregation, sorting, and limiting. It leverages Snowflake’s efficient handling of ORDER BY and LIMIT for Top-N operations

## 4.3. Average Order Value for Each Month in 2023

- **Query**:
  ```sql
  SELECT
      month,
      AVG(total_sales_amount) AS average_order_value
  FROM transformed_sales_data
  GROUP BY month
  ORDER BY month;

##### The provided query is generally well-optimized for calculating the average order value per month. It performs aggregation efficiently and sorts the results as required.

### 4.4. Customer with Highest Order Volume in October 2023

- **Query**:
  ```sql
  SELECT
      c.customer_name,
      COUNT(t.order_id) AS order_count
  FROM transformed_sales_data t
  JOIN raw_customer_data c ON t.customer_id = c.customer_id
  WHERE t.month = 10
  GROUP BY c.customer_name
  ORDER BY order_count DESC
  LIMIT 1;

##### The above query is quite optimized because it directly retrieves the top customer by order count using ORDER BY and LIMIT, leveraging Snowflake’s Top-N optimization to efficiently sort and limit the result set

## 5. Summary

- **Correctness**: i ensured by validating transformations and query results against expected outcomes.
- **Efficiency**: i optimized queries where applicable to enhance performance and readability.
- **Clarity**: i documented each step and decision to ensure transparency and understanding.
