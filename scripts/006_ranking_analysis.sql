/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/


-- Which 5 products generate the highest revenue
SELECT TOP 5
	P.product_name,
	SUM(S.sales_amount) AS total_revenue
FROM gold.fact_sales S
LEFT JOIN gold.dim_products P
	ON P.product_key = S.product_key
GROUP BY P.product_name
ORDER BY total_revenue DESC;


-- What are the 5 worst-performing products in terms of sales
SELECT TOP 5
	P.product_name,
	SUM(S.sales_amount) AS total_revenue
FROM gold.fact_sales S
LEFT JOIN gold.dim_products P
	ON P.product_key = S.product_key
GROUP BY P.product_name
ORDER BY total_revenue;


-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	C.customer_key,
	C.first_name,
	C.last_name,
	SUM(S.sales_amount) AS total_revenue_by_customer
FROM gold.fact_sales S
LEFT JOIN gold.dim_customers C
	ON C.customer_key = S.customer_key
Group BY 
	C.customer_key,
	C.first_name,
	C.last_name
ORDER BY total_revenue_by_customer DESC;


-- Find the 3 customers with the fewest orders placed
SELECT TOP 3
	C.customer_key,
	C.first_name,
	C.last_name,
	COUNT(distinct order_number) AS total_orders
FROM gold.fact_sales S
LEFT JOIN gold.dim_customers C
ON C.customer_key = S.customer_key
GROUP BY 
	C.customer_key,
	C.first_name,
	C.last_name
ORDER BY total_orders;