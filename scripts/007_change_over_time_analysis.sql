/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/



-- By Year
SELECT
	YEAR(order_date) AS order_year,
	SUM(sales_amount) AS total_sales,
	COUNT (DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_qunatity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);


-- By Month
SELECT
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT (DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_qunatity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);


-- Over Months
SELECT
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT (DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_qunatity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
	YEAR(order_date),
	MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);