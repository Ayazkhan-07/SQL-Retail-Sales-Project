-- 									SQL Retail Sales Project

-- create Database
create database	sql_project;
use sql_project;

-- Creating table
drop table if exists retail_sales;
create table retail_sales (
Transactions_id	int primary key,
Sale_date	date,
Sale_time	time,
Customer_id	int,
Gender	varchar(10),
Age	int,
Category varchar(50),	
Quantity	int,
Price_per_unit	float,
Cogs	float,
Total_sale float );

SELECT * FROM retail_sales limit 10;

-- Data Cleaning	

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
    
-- Data Exploration

--  How many sales we have   
select count(*) as Total_sales from retail_sales ;
-- how many unique customers we have ?
select count(distinct Customer_id) AS Unique_customers from retail_sales; 
-- how many category we have ?
SELECT distinct category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answere

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05**:

	Select * from retail_sales where Sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is equal to more than 4 in the month of Nov-2022.
	
    SELECT * FROM retail_sales 
	WHERE category = 'Clothing' 
	AND quantity >= 4 AND DATE_FORMAT(Sale_date, '%Y-%m') = '2022-11'
	LIMIT 1000;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.

	Select category , sum(total_sale) as Total_sales 
		from retail_sales group by category;

-- 4. Write a SQL query to find the top 5 customers based on the highest total sales.
   
   SELECT customer_id, SUM(total_sale) as total_sales
		FROM retail_sales GROUP BY customer_id ORDER BY 2 DESC LIMIT 5;

-- 5. Calculate the Total sales and Total order for each category.

SELECT  category, SUM(total_sale) as net_sale,
    COUNT(*) as total_orders FROM retail_sales
		GROUP BY 1;

-- 6. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

	Select category, avg(age) AS Avg_age 
		from retail_sales group by category 
			having category = "Beauty";

-- 7.Write a SQL query to find all transactions where the total_sale is greater than 1000

	Select * from retail_sales where total_sale > 1000;

-- 8. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
	Select category , gender , count(*) as total_transaction 
		from retail_sales group by category , gender 
			order by 1;

-- 9. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

-- Average Sales Per Month
	Select
    year(Sale_date) as Year,
    month(Sale_date) as month ,
		avg(total_sale) as Avg_sales 
		from retail_sales group by year(Sale_date) , month(Sale_date)
			order by month;   

-- 	Best Month Per Year  
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

-- 10. Write a SQL query to find the number of unique customers who purchased items from each category.
	Select count(distinct customer_id) as unique_customer , category
		from retail_sales group by 2;
    
-- 11. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17, else Night.
	With hourly_sale as (Select *,
    case when hour(Sale_time) < 12 then "Morning"
		 when hour(Sale_time) between 12 and 17 then "Afternoon"
         when hour(Sale_time) between 17 and 21 then "Evening"
         else "Night"
         end as Shift 
         from retail_sales)
	select shift , count(*) as Total_sales
		from hourly_sale group by shift;

-- End of the Project
