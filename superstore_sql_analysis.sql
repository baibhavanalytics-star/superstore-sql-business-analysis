-- Q1 What are the total sales, total profit, and total orders in the dataset?

SELECT 
SUM(o.sales) as total_sales,
SUM(o.profit) as total_profit,
Count(distinct o.order_id) as total_order
FROM orders o;

-- Q2What is the overall profit margin of the business?

SELECT 
Round((SUM(o.profit)/SUM(o.sales)) *100,2) as profi_margin_percentage
FROM orders o;

-- Q3 On average, how much sales value does each order generate?

SELECT  
ROUND(SUM(o.sales)/COUNT(DISTINCT o.order_id),2) as average_ordefr_value
FROM ORDERS o;

-- Q4 Show sales and profit year-wise to understand business trends

SELECT 
SUM(o.sales),
SUM(o.profit),
YEAR(o.order_date) as years
 FROM Orders o
 group by YEAR(o.order_date)
 ORDER BY years;
 
 -- Q5 Which category generates the highest sales and which gives the highest profit?
 
 SELECT 
 o.category,
 SUM(o.sales) as total_sales,
 SUM(O.profit) as total_profit
 FROM ORDERS o
 GROUP BY o.category
 order by  total_sales desc
 Limit 1;

-- Q6 Which sub-categories are generating negative total profit?

SELECT 
sub_category,
SUM(profit) AS total_profit
FROM orders
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- Q7 Which products are ordered the most based on quantity?

SELECT 
o.product_id,o.product_name,
SUM(o.quantity) as ordered_quantity
FROM orders o
group by o.product_id,o.product_name
order by ordered_quantity desc
Limit 3;

-- Q8 Which products generate the highest revenue?

SELECT 
 o.product_id,o.product_name,
SUM(o.sales) as total_revenue
FROM orders o
group by o.product_id,o.product_name
order by total_revenue desc
LIMIT 5;

-- Q9 Which sub-categories receive the highest average discount?

SELECT 
o.sub_category,
ROUND(AVG(o.discount) * 100,2) as average_discount
FROM orders o
GROUP BY o.sub_category
order by  average_discount desc;

-- Q10 Who are the most valuable customers based on total sales?

SELECT 
o.customer_id,o.customer_name,
SUM(o.sales) as total_sales
FROM orders o
GROUP BY o.customer_id,o.customer_name
Order by total_sales desc
Limit 10;

-- Q11 Which customers generate the highest total profit?

SELECT 
o.customer_id,o.customer_name,
SUM(o.profit) as total_profit
FROM orders o
GROUP BY o.customer_id,o.customer_name
Order by total_profit desc
Limit 10;

-- Q12 Which customer segment contributes the most to sales and profit?

SELECT
o.segment,  
SUM(o.sales) as total_sales,
SUM(o.profit) as total_profit
FROM orders o
GROUP BY o.segment
order by total_sales desc;

-- Q13 Which customers have generated negative total profit?

SELECT 
    o.customer_id,
    o.customer_name,
    SUM(o.profit) AS total_profit
FROM
    orders o
GROUP BY o.customer_id , o.customer_name
HAVING total_profit < 0
ORDER BY total_profit ASC;

-- Q14 Which region generates the highest sales and profit?

SELECT 
o.region,
SUM(o.sales) as total_sales,
SUM(o.profit) as total_profit 
FROM orders o
GROUP BY o.region
ORDER BY total_sales desc;

-- Q15 Which states are generating negative total profit?

SELECT 
o.state,
SUM(o.profit) as total_profit
 FROM orders o
 group by o.state
 having SUM(o.profit) < 0
 order by total_profit asc;
 
 -- Q16 For each region, which city generates the highest total profit?

With region_rank as(
SELECT 
o.region,o.city,
SUM(o.profit) as total_profit ,
rank() over(partition by o.region order by SUM(o.profit) desc) as rank_in_region
FROM orders o
group by o.region,o.city)
select * 
from region_rank
where rank_in_region = 1
order by total_profit desc;

-- Q17 How does profit behave across different discount levels?

SELECT 
CASE 
    WHEN discount = 0 THEN 'No Discount'
    WHEN discount <= 0.2 THEN 'Low Discount'
    WHEN discount <= 0.5 THEN 'Medium Discount'
    ELSE 'High Discount'
END AS discount_category,

ROUND(AVG(profit), 2) AS avg_profit

FROM orders
GROUP BY discount_category
ORDER BY avg_profit;

-- Q18 Find orders where discount > 30% but profit is negative.

SELECT 
o.order_id,
o.discount,
o.profit
FROM orders o
WHERE o.discount > 0.3
AND o.profit < 0;

-- Q19 What percentage of total sales comes from each category?

select 
o.category,
sum(o.sales) as total_sales,
Round(sum(o.sales) * 100 /(Select SUM(o.sales) from orders) , 2) as percentage_contribution
from orders o
group by o.category
order by percentage_contribution desc;

-- Q20 Calculate month-wise sales and the running total of sales over time.

SELECT 
DATE_FORMAT(order_date, '%Y-%m') AS month,

SUM(sales) AS monthly_sales,

SUM(SUM(sales)) OVER (
    ORDER BY DATE_FORMAT(order_date, '%Y-%m')
) AS running_total_sales

FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

