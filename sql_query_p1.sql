	--create database sql_project_p2
	create database sql_project_p2
	
	-- create table retail_sales
	drop table if exists retail_sales;
	create table retail_sales(
	
					transactions_id int primary key,
					sale_date DATE,
					sale_time TIME,
					customer_id	int,
					gender varchar(15),
					age	int,
					category varchar(15),
					quantiy	int,
					price_per_unit	FLOAT,
					cogs float,
					total_sale FLOAT
	);
	--Data Cleaning Done here
	select * from retail_sales limit 10;
	select count(*) from retail_sales ;
	select * from retail_sales where transactions_id is null;
	
	select * from retail_sales where age is null;
	
	
	update retail_sales set age=(select round(avg(age)) from retail_sales) where age is null;
	
	select * from retail_sales where sale_time is null;
	select * from retail_sales where transactions_id is null
								or 
								sale_date is null
								or
								gender is null
								or
								category is null
								or
								quantiy is null 
								or 
								price_per_unit is null
								or
								cogs is null 
								or
								total_sale is null;
	
	--Delete the rows where is null
	delete from retail_sales where transactions_id is null
								or 
								sale_date is null
								or
								gender is null
								or
								category is null
								or
								quantiy is null 
								or 
								price_per_unit is null
								or
								cogs is null 
								or
								total_sale is null;
	--Data Exploration
	--how many sales we have ?
	select count(*) as Total_sales from retail_sales;
	--How many unique customer we have
	select count(distinct customer_id) as Total_customers from retail_sales;
	--How many distinct category we have?
	select count(distinct category) as Categories from retail_sales;
	--List out the categories name 
	select distinct category as Categories from retail_sales;
	
	
	--data Exploration
	--Write a SQL query to retrieve all columns for sales made on '2022-11-05:
		select * 
		from retail_sales 
		where sale_date='2022-11-05';
	--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:--
	--select * from retail_sales where category='Clothing' and quantiy>=4 and sale_date>='2022-11-01' and sale_date<='2022-11-30';
		select * 
		from retail_sales 
		where category='Clothing' 
		and
		quantiy>=4 
		and 
		to_char(sale_date,'YYYY-MM')='2022-11';
	--Write a SQL query to calculate the total sales (total_sale) for each category.:
		select category,sum(total_sale) as TOTAL_SALES,count(category) as Total_orders 
		from retail_sales
		group by category
	--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
		select round(avg(age),2) as Average_age_of_Customers 
		from retail_sales 
		where category='Beauty';
	--Write a SQL query to find all transactions where the total_sale is greater than 1000.:
		select * from retail_sales 
		where total_sale>1000;
	--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
		select gender,category,count(transactions_id) as No_of_transactions from retail_sales 
		group by gender,category
		order by gender,category;
	
	--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
		select
		YEAR,MONTH,AVG_SALE
		FROM
		(select extract(year from sale_date) as YEAR, extract(month from sale_date) as MONTH,avg(total_sale) AS AVG_SALE, 
		 rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
		 from retail_sales
		 group by 1,2) 
		 WHERE rank=1;
					
	--Write a SQL query to find the top 5 customers based on the highest total sales **:
	select 
		customer_id ,
		sum(total_sale) as total_sales
	from retail_sales
	group by customer_id
	order by total_sales desc
	limit 5;
	
	--Write a SQL query to find the number of unique customers who purchased items from each category.:
	select 
		category,
		count(distinct customer_id) as customers
	from retail_sales 
	group by category
	order by customers desc;
	
	--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
		select count(*) as no_of_orders,
				case
					when extract(hour from sale_time) < 12 then 'Morning'
					 when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
					 when extract(hour from sale_time) > 17 then 'Evening'
				 end as shift
		 from retail_sales
		 group by shift
		 order by no_of_orders desc;
	--Highest Revenue Category-
		select
			category,
			 Revenue
		from 
			(select category,
		 	sum(total_sale) as Revenue,
		 	rank() over(order by sum(total_sale) desc) as rank
			from retail_sales
			group by 1 ) as Highest_revenue_Category
		 WHERE rank=1;
 -- Customer Age Group Analysis
 select
 	count(*) as No_of_customers ,
		 case
		 when age<20  then 'Teen'
		 when age between 20 and 40 then 'Adult'
		 else 'Senior'
		 end as age_group
	 from retail_sales
	 group by age_group
	--End of Project		
		