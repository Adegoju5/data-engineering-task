# Data Engineering Home Assignment

## Overview

This project is a solution for analyzing sales data using dbt and Snowflake. It includes data ingestion, transformation, and analysis of sales data to answer specific business questions.

## Setup Instructions

### 1. **Create Snowflake Account**

1. Sign up for a free 30-day trial on [Snowflake's website](https://www.snowflake.com/).
2. Create a database named `home_assignment`, a schema (e.g., `public`), and a warehouse (e.g., `compute_wh`).

### 2. **Install dbt**

1. Ensure Python is installed on your system.
2. Install dbt using pip:

    ```bash
    pip install dbt-snowflake
    ```

### 3. **Configure dbt**

1. Locate or create the `~/.dbt/` directory.
2. Create a file named `profiles.yml` with the following content:

    ```yaml
    dbt_banxware_assignment:
      outputs:
        dev:
          type: snowflake
          threads: 4
          account: <your_snowflake_account_details>
          database: home_assignment
          user: <your_login_name>
          password: <your_password>
          schema: <your_schema_name>
          warehouse: compute_wh
          role: <your_snowflake_role>
      target: dev
    ```

    Replace placeholders (`<your_snowflake_account_details>`, etc.) with your Snowflake details.

### 4. **Initialize the Project**

1. Clone the repository:

    ```bash
    git clone https://github.com/Adegoju5/data-engineering-task.git
    cd data-engineering-home-assignment
    ```

2. Install dbt dependencies:

    ```bash
    dbt deps
    ```

### 5. **Data Ingestion**

1. Ensure `sales.csv` and `customers.csv` are in the `data` folder.
2. Load data into Snowflake:

    ```bash
    dbt seed
    ```

### 6. **Run Data Transformations**

1. Transform raw data into a structured format:

    ```bash
    dbt run
    ```

### 7. **Run Queries**

- **Top 5 Products by Total Sales Amount in 2023**

    ```sql
    SELECT * FROM queries/top_5_products_2023.sql;
    ```

- **Top 5 Customers by Total Sales Amount in 2023**

    ```sql
    SELECT * FROM queries/top_5_customers_2023.sql;
    ```

- **Average Order Value for Each Month in 2023**

    ```sql
    SELECT * FROM queries/average_order_value_monthly_2023.sql;
    ```

- **Customer with Highest Order Volume in October 2023**

    ```sql
    SELECT * FROM queries/top_customer_october_2023.sql;
    ```

### 8. **Generate Documentation**

1. Generate and serve documentation:

    ```bash
    dbt docs generate
    dbt docs serve
    ```

    Open the provided URL in your browser to view the documentation.

## Files and Directories

- **`models/`**: Contains dbt models and transformations.
- **`data/`**: Directory for CSV files.
- **`queries/`**: Contains SQL files for data analysis.
- **`DECISIONS.md`**: Documentation of decisions and processes.
- **`README.md`**: Project instructions and setup guide.

## Contact

For any questions, please contact me at adegoju_a@yahoo.com.

Thank you for reviewing this project!
