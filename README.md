# Amazon Sales Analysis SQL Project

#  **Project Overview**

The ``amazon_sales`` dataset includes detailed information such as order ID, purchase date, product and category details, price, quantity, total sales, customer data, location, payment method, and order status.
The primary goal of this project is to understand customer behavior, identify top-performing products and regions, evaluate seasonal sales trends, and evaluate factors affecting revenue and profitability. 

## **Objectives**

1. **Database Setup-** Import and organize the Amazon Sales dataset into a structured database ``amazon_sales`` for efficient query. 
2. **Data Cleaning-** Identify and remove duplicate, null, or inconsistent entries to ensure data accuracy and reliability.
3. **Exploratory Data Analysis (EDA)-** Segment data by product categories, customer demographics, and geographic locations for a better understanding of key patterns and behaviors.
4. **Business Analysis Using SQL-** Use SQL queries to solve practical business problem such as identifying top-selling products, evaluating seasonal sales trends, and analyzing revenue distribution.
5. **Insights & Recommendations-** Provide meaningful insights from the data based on customer purchasing behavior, product performance, and location-based sales.
Suggest strategies for improving sales, targeting high-value customers, and managing inventory based on demand trenda and regional preferences.


## **Project Structure**

1. **Database Setup**

**Database Creation:** The project starts by creating a database named sql_query_p2.
**Table Creation:** A table named amazon_sales is created to store the sales data. The table includes columns for  order ID, purchase date, product and category details, price, quantity, total sales, customer data, location, payment method, and order status.

``` sql
create database sql_project_p2

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
2. Data Handling & Cleaning
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
```

3. **Data Analysis & Findings**

The SQL queries below were designed to address key business questions and find insights.

Q.1 Find the total number of orders per category placed each month.

```sql
select to_char(date, 'YYYY-MM') as month, category, count(order_id) as total_orders from amazon_sales
group by month, category
order by month asc;
```

Q.2 Identify the top 5 most purchased products.

```sql
select product, sum(quantity) as total_purchase from amazon_sales
group by product
order by total_purchase desc
limit 5;
```

Q.3 Which month had the highest revenue, and which product contributed the most?

```sql
select to_char(date, 'YYYY-MM') as month, product, sum(total_sales) as revenue from amazon_sales
group by month, product
order by revenue desc
limit 1;
```

Q.4 Find the total quantity sold per category.

```sql
select category, sum(quantity) as total_quantity from amazon_sales
group by category
order by total_quantity desc;
```

Q.5 Which categories perform best in terms of revenue but have low quantities sold?

```sql
select category, sum(quantity)as total_quantity, sum(total_sales) as revenue,
round(sum(total_sales) / nullif(sum(quantity), 0), 2) as revenue_per_unit
from amazon_sales
group by category
order by revenue_per_unit desc;
```

Q.6 Find the total number of successful orders placed by each payment mode per month.	

```sql
select to_char(date, 'YYYY-MM') as month, payment_method as payment_mode, count(order_id) as total_order from amazon_sales
where status = 'Completed'
group by month, payment_mode
order by month, total_order desc;
```

Q.7  Find the number of orders placed in each state per month, those with a status of "Pending" or "Cancelled"?

```sql
select to_char(date, 'YYYY-MM') as month, count(order_id) as total_orders, customer_location as location, status
from amazon_sales
where status in ( 'Cancelled', 'Pending')
group by month, location, status
order by month, total_orders desc;
```

Q.8 Find the total revenue generated per product category each month, and generated more than ₹10,000 in revenue.

```sql
select to_char(date, 'YYYY-MM') as month, product, sum(total_sales) as revenue from amazon_sales
group by month, product
having sum(total_sales)> 10000
order by month, revenue desc;
```

Q.9 Identify top 5 customers with highest average product price per order(Completed orders, total sales > ₹500).

```sql
select customer_name, round(avg(price), 2) as avg_revenue_per_order from amazon_sales
where status = 'Completed' and total_sales > 500
group by customer_name
order by avg_revenue_per_order desc
limit 5;
```

Q.10 Identify products with more cancellations in top 3 location.

```sql
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
```

Q.11 Identify seasonal sales in different categories perform in each season.

```sql
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
```

## Findings & Insights

1. **Customer & Product Insights**
•	Olivia Wilson, Jane Smith, John Doe, David Lee, and Daniel Harris are the top 5 customers who consistently purchase premium or higher-priced products.
•	Products like Refrigerator, Smartwatches, Laptop, and Washing Machine appear frequently, indicating high demand.


2. **Category Performance**
•	Home Appliances and Electronics perform best in terms of total revenue.
•	Books, Clothing, and Footwear contribute much less to revenue, with lower quantities and lower revenue per unit.
•	Refrigerators consistently top revenue across both February and March 2025.

4. **Order Status & Payment**
•	High volumes of pending and cancelled orders, especially in February, suggest potential issues in supply chain, delivery, or payment processing. There's a positive shift in March, with more completed orders, possibly due to operational adjustments or seasonal trends.
•	PayPal consistently dominates across all months, making it the most preferred and reliable payment method. Credit and Debit Cards maintain stable usage.


## Conclusion

The analysis of the ``amazon_sales`` database provides key insights into customer purchasing behavior and business performance. 
Home Appliances generate high revenue with lower sales volume, making it a top-performing category with low quantities sold — ideal for focusing on high-margin products.
February and March 2025 saw strong performance in premium segments like Refrigerators, Laptops, and Smartphones, contributing to revenue above ₹10,000 per product.
Dallas, Los Angeles, and Miami are consistently showing higher cancellation volumes, pointing to possible region-specific challenges like Delivery/logistics disruptions, stock unavailability, payment issues, improve delivery timelines, enhance customer service.
