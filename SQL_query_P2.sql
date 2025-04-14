--- SQL Amazon_sales - P2

create database sql_project_p2;

--- Create Table
create table amazon_sales
(order_id varchar(20) primary key,
date date,
product varchar(20),
category varchar(20),
price int,
quantity int,	
total_sales int,
customer_name varchar(20),
customer_location varchar(20),
payment_method varchar(20),
status varchar(20)
);

select * from amazon_sales

--- Data Cleaning

select * from amazon_sales
where order_id is null	
or date is null	
or product is null	
or category is null	
or price is null	
or quantity is null	
or total_sales is null	
or customer_name is null	
or customer_location is null	
or payment_method is null	
or status is null;

-- Data Analysis and Business Key Problems

-- Q.1 Find the total number of orders placed each month.
-- Q.2 Identify the top 5 most purchased products.
-- Q.3 Which month had the highest revenue, and what was the best-selling product in that month?
-- Q.4 Find the total quantity sold per category.
-- Q.5 Which categories perform best in terms of revenue but have low quantities sold?
-- Q.6 Find the total number of successful orders placed by each payment mode per month.	
-- Q.7 Find the number of orders placed in each state per month, those with a status of "Pending" or "Cancelled"?
-- Q.8 Find the total revenue generated per product category each month, and generated more than ₹10,000 in revenue.
-- Q.9 Identify customers who bought the most expensive products on average.
-- Q.10 Identify products with more cancellations in top 3 location.
-- Q.11 Identify seasonal sales in different categories perform in each season.

-- Analysis and Findings

-- Q.1 Find the total number of orders per category placed each month.

select to_char(date, 'YYYY-MM') as month, category, count(order_id) as total_orders from amazon_sales
group by month, category
order by month asc;

-- Q.2 Identify the top 5 most purchased products.

select product, sum(quantity) as total_purchase from amazon_sales
group by product
order by total_purchase desc
limit 5;

-- Q.3 Which month had the highest revenue, and which product contributed the most?

select to_char(date, 'YYYY-MM') as month, product, sum(total_sales) as revenue from amazon_sales
group by month, product
order by revenue desc
limit 1;

-- Q.4 Find the total quantity sold per category.

select category, sum(quantity) as total_quantity from amazon_sales
group by category
order by total_quantity desc;

-- Q.5 Which categories perform best in terms of revenue but have low quantities sold?

select category, sum(quantity)as total_quantity, sum(total_sales) as revenue,
round(sum(total_sales) / nullif(sum(quantity), 0), 2) as revenue_per_unit
from amazon_sales
group by category
order by revenue_per_unit desc;

-- Q.6 Find the total number of successful orders placed by each payment mode per month.	

select to_char(date, 'YYYY-MM') as month, payment_method as payment_mode, count(order_id) as total_order from amazon_sales
where status = 'Completed'
group by month, payment_mode
order by month, total_order desc;

-- Q.7  Find the number of orders placed in each state per month, those with a status of "Pending" or "Cancelled"?

select to_char(date, 'YYYY-MM') as month, count(order_id) as total_orders, customer_location as location, status
from amazon_sales
where status in ( 'Cancelled', 'Pending')
group by month, location, status
order by month, total_orders desc;

-- Q.8 Find the total revenue generated per product category each month, and generated more than ₹10,000 in revenue.

select to_char(date, 'YYYY-MM') as month, product, sum(total_sales) as revenue from amazon_sales
group by month, product
having sum(total_sales)> 10000
order by month, revenue desc;

-- Q.9 Identify top 5 customers with highest average product price per order(Completed orders, total sales > ₹500).

select customer_name, round(avg(price), 2) as avg_revenue_per_order from amazon_sales
where status = 'Completed' and total_sales > 500
group by customer_name
order by avg_revenue_per_order desc
limit 5;

-- Q.10 Identify products with more cancellations in top 3 location.

with top_locations as ( 
select customer_location from amazon_sales
where status = 'Cancelled'
group by customer_location
order by count(*) desc
limit 3)
select customer_location, product, count(*) as cancelled_orders
from amazon_sales
where status = 'Cancelled'
and customer_location in (select customer_location from top_locations)
group by customer_location, product
order by customer_location, cancelled_orders desc;

-- Q.11 Identify seasonal sales in different categories perform in each season.

select case
when extract(month from date) in (12,1,2) then 'Winter'
when extract(month from date) in (3,4,5) then 'Spring'
when extract(month from date) in (6,7,8) then 'Summer'
when extract(month from date) in (9,10,11) then 'Autumn'
end as season,
category, sum(total_sales) as total_sales
from amazon_sales
group by season, category
order by season, total_sales desc;

-- End of Project 
