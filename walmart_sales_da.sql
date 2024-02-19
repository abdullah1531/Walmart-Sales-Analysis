Create Table sales(
	invoice_id VARCHAR(50) Not Null Primary Key,
	branch Varchar(50) Not Null,
	city Varchar(50) Not Null,
	customer_type Varchar(50) Not Null,
	gender Varchar(50) Not Null,
	product_line Varchar(100) Not Null,
	unit_price decimal(10,2) Not Null,
	quantity int Not Null,
	vat Float Not Null,
	total decimal(12,4) Not Null,
	date DateTime Not Null,
	time time Not Null,
	payment_method varchar(50) Not Null,
	cogs decimal(10,2) Not Null,
	gross_margin_pct float Not Null,
	gross_income decimal(12,4) Not Null,
	rating float Not Null,
	);

select *
From sales

-------------------------------------------------------------------------------------------------------------

-- Feature Engineering--

SELECT 
    time,
    (CASE
        WHEN CAST("time" AS TIME) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN CAST("time" AS TIME) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM sales;

ALTER TABLE sales
ADD time_of_day VARCHAR(20);

UPDATE sales
set time_of_day = (
CASE
        WHEN CAST("time" AS TIME) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN CAST("time" AS TIME) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);


-- day name

Select date,
Datename(dw, date) As day_name
From sales;

Alter Table sales
Add day_name varchar(50)

Update sales
Set day_name = Datename(dw, date)

-- month_name

Select date,
Datename(month, date) As month_name
From sales;

Alter Table sales
Add month_name varchar(50)

Update sales
Set month_name = Datename(month, date)


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EXPLORATORY DATA ANALYSIS --

-- How many unique cities does the data have?

Select Distinct City
From sales

-- In which city is each branch?

Select Distinct City, Branch
From sales

-- How many unique product lines does the data have?

Select Distinct "Product line"
From sales

-- What is the most common payment method?

Select *
From sales

Select Payment, Count(Payment) As Number
From sales
Group By Payment

-- What is the most selling product line?

Select "Product line", Count("Product line") As Number
From sales
Group By "Product line"
Order By Count("Product line") DESC;

-- What is the total revenue by month?

Select month_name As month,
Sum(Total) As Total_revenue
From sales
Group By month_name
Order By Total_revenue DESC

-- What month had the largest COGS(cost of goods sold)?
Select *
From sales


Select month_name As month,
Sum(cogs) As Total_cogs
From sales
Group By month_name
Order By Total_cogs DESC

-- What product line had the largest revenue?

Select "Product line",
Sum(Total) As Total_revenue
From sales
Group By "Product line"
Order By Total_revenue DESC

-- What is the city with the largest revenue?

Select City,
Sum(Total) As Total_revenue
From sales
Group By City
Order By Total_revenue DESC

-- What product line had the largest VAT?
Select *
From sales

Select "Product line",
Sum("Tax 5%") As Total_vat
From sales
Group By "Product line"
Order By Total_vat DESC

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales






-- Which branch sold more products than average product sold?

Select Branch, Sum(Quantity) as qty
From sales
Group By Branch
Having Sum(Quantity) > (Select Avg(Quantity) From sales)

-- What is the most common product line by gender?

Select Gender, "Product line", Count(Gender) as cnt
From sales
Group By Gender, "Product line"
Order By Count(Gender) DESC

-- What is the average rating of each product line?

Select "Product line", Round(Avg(Rating),2) as avg_rating
From sales
Group By "Product line"
Order By Avg(Rating) DESC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
----- SALES -----

-- Number of sales made in each time of the day per weekday?

Select *
From sales

Select time_of_day, Count(*) as total_sales
From sales
Where day_name = 'Saturday' -- change the day to see for other days
Group By time_of_day
Order by total_sales DESC

-- Which of the customer types brings the most revenue?
Select "Customer type", Sum(Total) as total_revenue
From sales
Group BY "Customer type"
Order By total_revenue DESC

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

Select City, AVG("Tax 5%") as avg_vat
From sales
Group BY City
Order By avg_vat DESC

-- Which customer type pays the most in VAT?

Select "Customer type", AVG("Tax 5%") as avg_vat
From sales
Group BY "Customer type"
Order By avg_vat DESC

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------- CUSTOMER ---------

-- How many unique customer types does the data have?

Select Count(Distinct "Customer type") as unique_customers
From sales

-- How many unique payment methods does the data have?
Select Distinct Payment as unique_payment_methods
From sales

-- Which customer type buys the most?

Select "Customer type", Count(*) as customer_count
From sales
Group By "Customer type"
Order By customer_count DESC

-- What is the gender of most of the customers?

Select Gender, Count(*) as gender_count
From sales
Group By Gender
Order By gender_count DESC

-- What is the gender distribution per branch?

Select Gender, Branch, Count(*) as gender_count
From sales
Group By Gender, Branch
Order By gender_count DESC

-- Which time of the day do customers give most ratings?

Select time_of_day, Round(Avg(Rating),2) as avg_rating
From sales
Group By time_of_day
Order By avg_rating DESC

-- Which time of the day do customers give most ratings per branch?

Select time_of_day, Branch, Round(Avg(Rating),2) as avg_rating
From sales
Group By time_of_day, Branch
Order By avg_rating DESC

-- Which day of the week has the best avg ratings?

Select day_name, Round(Avg(Rating),2) as avg_rating
From sales
Group By day_name
Order By avg_rating DESC

-- Which day of the week has the best average ratings per branch?

Select day_name,Branch, Round(Avg(Rating),2) as avg_rating
From sales
Group By day_name, Branch
Order By avg_rating DESC





