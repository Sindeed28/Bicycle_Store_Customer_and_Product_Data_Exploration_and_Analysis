/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/


/*Segment products into cost ranges and
count how many products fall into each segment*/
WITH cte AS (
	SELECT
		product_key,
		product_name,
		cost,
		CASE
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products
)
Select
	cost_range,
	COUNT(*) AS total_products
FROM cte
GROUP BY cost_range
ORDER BY total_products DESC;


/*Group customers into three segments based on their spending behavior:
- VIP: Customers with at least 12 months of history and spending more than �5,000.
- Regular: Customers with at least 12 months of history but spending �5,000 or less.
- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/


WITH cte AS (
	SELECT
		c.customer_key,
		SUM(s.sales_amount) AS total_spending,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
		DATEDIFF (MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
		ON s.customer_key = c.customer_key
	GROUP BY c.customer_key
)
SELECT
	customer_segment,
	COUNT(*) AS total_customers
	FROM (
	SELECT
	CASE
		WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
FROM cte ) t
GROUP BY customer_segment
ORDER BY total_customers DESC;