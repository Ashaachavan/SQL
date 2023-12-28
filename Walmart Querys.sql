CREATE DATABASE IF NOT EXISTS SalesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(3, 1)
);
ALTER TABLE sales 
MODIFY COLUMN rating FLOAT(3, 1);

SELECT * FROM sales Where rating=10;

truncate sales;

-- ----------------FEATURE ENGINEERING---------------------------------------------------------------------------------------
SELECT time FROM sales;

SELECT time,
(CASE
     WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
     WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
     ELSE "Evening"
END) AS Time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN Time_of_date VARCHAR(20);

UPDATE sales
SET Time_of_date = (
  CASE
     WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
     WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
     ELSE "Evening"
  END);
  
  -- DATE NAME ------------------------------------------
  SELECT date,
      DAYNAME(date)
  FROM sales;
  
  ALTER TABLE sales ADD COLUMN day_name varchar(20);
  
  UPDATE sales
  SET day_name = DAYNAME(date);
  
  -- MONTH NAME------------------------------------------
  
  SELECT date, MONTHNAME(date)
  FROM sales;
  
  ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);
  
  UPDATE sales
  SET month_name = MONTHNAME(date);
  
  -- --------------------------------------------------------------------------------------------------------------------------
  -- ---------------------------------GENERIC----------------------------------------------------------------------------------
  
  
  -- How many unique cities does the data have?
SELECT 
     DISTINCT city
FROM sales;   

-- In which city is each branch?

SELECT 
     DISTINCT branch
FROM sales;

SELECT 
      DISTINCT city, branch
FROM sales;      

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------PRODUCT------------------------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT 
      COUNT(DISTINCT product_line)
FROM sales;
	
-- What is the most common payment method?
SELECT 
      payment, COUNT(payment) AS cnt
FROM sales
GROUP BY payment
ORDER BY cnt DESC;

-- What is the most selling product line?
SELECT 
      product_line, COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month?
SELECT 
      month_name AS month,
      SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;      

-- What month had the largest COGS?
SELECT 
      month_name as month,
      SUM(cogs) AS max_cogs
FROM sales
GROUP BY month
ORDER BY max_cogs;

-- What product line had the largest revenue?
SELECT 
      DISTINCT product_line, 
      SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT
      DISTINCT city,
      SUM(total) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT 
      product_line,
      SUM(tax_pct) AS VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	  AVG(quantity)
FROM sales;

SELECT
      product_line, quantity,
      CASE
          WHEN quantity > 5.51 THEN "Good"
          ELSE "Bad"
      END AS remark
FROM sales;     

-- Which branch sold more products than average product sold?
SELECT
      branch,
      SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales); 
  
-- What is the most common product line by gender?
SELECT
      gender,
      product_line,
      COUNT(gender) AS total_cnt
FROM sales 
GROUP BY gender, product_line
ORDER BY total_cnt DESC;   

-- What is the average rating of each product line?
SELECT
      product_line,
      ROUND (AVG(rating), 2) AS avg_rating
FROM sales   
GROUP BY product_line
ORDER BY avg_rating DESC;   

-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------

-- --------------------------------------------CUSTOMER-------------------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT 
      DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT
      DISTINCT payment
FROM sales;

-- What is the most common customer type?
SELECT 
      customer_type, COUNT(customer_type) AS cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC;

-- Which customer type buys the most?
SELECT 
      customer_type, SUM(quantity) AS buys
FROM sales
GROUP BY customer_type
ORDER BY buys DESC;

-- What is the gender of most of the customers?
SELECT 
	  gender, COUNT(gender) AS common_gender
FROM sales
GROUP BY gender
ORDER BY common_gender DESC;

-- What is the gender distribution per branch?
SELECT 
      branch, COUNT(gender) AS total_gender
FROM sales
GROUP BY branch
ORDER BY total_gender DESC;

-- Which time of the day do customers give most ratings?
SELECT
      Time_of_date, COUNT(rating) AS rating
FROM sales  
GROUP BY Time_of_date
ORDER BY rating DESC;
-- Customers give most rating in the evening

-- Which time of the day do customers give most ratings per branch?
SELECT
      Time_of_date, COUNT(rating) AS rating
FROM sales
WHERE branch = 'A'
GROUP BY Time_of_date
ORDER BY rating DESC;

SELECT
      Time_of_date, COUNT(rating) AS rating
FROM sales
WHERE branch = 'B'
GROUP BY Time_of_date
ORDER BY rating DESC;

SELECT
      Time_of_date, COUNT(rating) AS rating
FROM sales
WHERE branch = 'C'
GROUP BY Time_of_date
ORDER BY rating DESC;
-- For all the 3 branches customers give ratings in the evening

-- Which day of the week has the best avg ratings?
SELECT 
      day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;
-- Friday has the best avg_rating

-- Which day of the week has the best average ratings per branch?
SELECT
      day_name, AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'A'
GROUP BY day_name
ORDER BY avg_rating DESC;

SELECT
      day_name, AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'B'
GROUP BY day_name
ORDER BY avg_rating DESC;

SELECT
      day_name, AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'C'
GROUP BY day_name
ORDER BY avg_rating DESC;

-- For branch A Friday has best avg_rating
-- For branch B Monday has best avg_rating
-- For branch C Friday has best avg_rating

-- ----------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------SALES----------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT
	  Time_of_date, COUNT(*) AS total_sales
FROM sales
WHERE day_name != "Sunday" AND day_name != "Saturday"
GROUP BY Time_of_date
ORDER BY total_sales DESC;
-- Evenings make more number of sales during weekdays

-- Which of the customer types brings the most revenue?
SELECT
      customer_type, ROUND(SUM(total), 2) AS revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;
-- Member type of customer brings most revenue

-- Which city has the largest tax/VAT percent?
SELECT
      city, ROUND(AVG(tax_pct), 2) AS avg_tax
FROM sales
GROUP BY city
ORDER BY avg_tax DESC;
-- Naypyitaw city has largest tax/VAT percent

-- Which customer type pays the most in VAT?
SELECT
      customer_type, SUM(tax_pct) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;
-- Member type of customer pays most in VAT
