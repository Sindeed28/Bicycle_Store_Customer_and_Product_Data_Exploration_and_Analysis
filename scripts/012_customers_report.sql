/*
=========================================================================
Customer Report
=========================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
========================================================================
*/


-- Create view report for customers

IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

/*-------------------------------------------------------
Base Query: Retrieve core columns from the tables
--------------------------------------------------------*/
WITH base_query AS (
	SELECT
		s.order_number,
		s.product_key,
		s.order_date,
		s.sales_amount,
		s.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name, ' ',c.last_name) AS customer_name,
		DATEDIFF(year, c.birthdate, GETDATE()) AS age
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
		ON c.customer_key = s.customer_key
	WHERE order_date IS NOT NULL
),
/*-------------------------------------------------------
Aggregates customer-level metrics
--------------------------------------------------------*/
customer_aggregation AS (
	SELECT
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order,
		DATEDIFF(MONTH, MIN (order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY
		customer_key,
		customer_number,
		customer_name,
		age
)
/*-------------------------------------------------------
Combines all product results into one output
--------------------------------------------------------*/
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE
		WHEN age <20 THEN 'Under 20'
		WHEN age between 20 AND 29 THEN '20-29'
		WHEN age between 30 AND 39 THEN '30-39'
		WHEN age between 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS age_group,
	CASE
		WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order,
	lifespan,
	DATEDIFF(MONTH, last_order, GETDATE()) recency_in_months_KPI,
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS average_order_value_KPI,
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS average_monthly_spend_KPI

FROM customer_aggregation


-- VIEW REPORT

SELECT
	*
FROM gold.report_customers