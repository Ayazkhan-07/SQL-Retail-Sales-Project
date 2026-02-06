# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `sql_project`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in MYSQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT * FROM retail_sales WHERE quantity is null;
SELECT * FROM retail_sales WHERE Transactions_id IS null;

SELECT * FROM retail_sales WHERE 
    sale_date IS NULL OR sale_time IS NULL 
    OR customer_id IS NULL OR gender IS NULL
    OR age IS NULL OR category IS NULL 
    OR quantity IS NULL OR price_per_unit IS NULL
    OR cogs IS NULL;
    
    SET SQL_SAFE_UPDATES=0;

DELETE FROM retail_sales
WHERE 
    Transactions_id IS NULL or sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```
### 3. Data Exploration
 How many sales we have   
```sql
Select count(*) as Total_sales from retail_sales ;
```
How many unique customers we have ?
```sql
Select count(distinct Customer_id) AS Unique_customers from retail_sales; 
```
How many category we have ?
```sql 
SELECT distinct category FROM retail_sales;
```

### 4. Data Analysis & Finding

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is equal to more than 4 in the month of Nov-2022**:
```sql
SELECT * FROM retail_sales 
	WHERE category = 'Clothing' 
	AND quantity >= 4 AND DATE_FORMAT(Sale_date, '%Y-%m') = '2022-11'
	LIMIT 1000;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
	Select category , sum(total_sale) as Total_sales 
		from retail_sales group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
	Select category, avg(age) AS Avg_age 
		from retail_sales group by category 
			having category = "Beauty";
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
	Select category , gender , count(*) as total_transaction 
		from retail_sales group by category , gender 
			order by 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
        Average Sales Per Month
```sql
	Select
    year(Sale_date) as Year,
    month(Sale_date) as month ,
		avg(total_sale) as Avg_sales 
		from retail_sales group by year(Sale_date) , month(Sale_date)
			order by month;   

```
        Best Month Per Year  
```sql
    WITH monthly_avg AS (
    SELECT 
        YEAR(Sale_date) AS year,
        MONTH(Sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sale
    FROM retail_sales
    GROUP BY YEAR(Sale_date), MONTH(Sale_date)),
ranked_months AS (
    SELECT 
        year, month, avg_sale,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rn
    FROM monthly_avg )
SELECT year, month, avg_sale AS best_month_avg_sale
FROM ranked_months
WHERE rn = 1
ORDER BY year;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
   SELECT customer_id, SUM(total_sale) as total_sales
		FROM retail_sales GROUP BY customer_id 
            ORDER BY 2 DESC LIMIT 5;
```
9. **Calculate the Total sales and Total order for each category.**
```sql
SELECT  category, SUM(total_sale) as net_sale,
    COUNT(*) as total_orders FROM retail_sales
		GROUP BY 1;
```
10. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
	    Select count(distinct customer_id) as unique_customer, 
             category from retail_sales 
                group by 2;
```

11. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - Ayaz Khan
 📧 ayazriyazahmedkhan@gmail.com 🌐 https://www.linkedin.com/in/ayazriyazkhan
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles.



