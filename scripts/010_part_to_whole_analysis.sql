/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/


-- Which categories contrubute the most to overall sales
WITH cte AS (
	SELECT
		category,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
		ON s.product_key = p.product_key
	GROUP BY
		category
)
SELECT
	category,
	total_sales,
	SUM (total_sales) OVER() AS overall_sales,
	concat(Round (CAST (total_sales AS float) / SUM (total_sales) OVER() *100, 2), '%')  AS percentage_of_total
FROM cte
ORDER BY total_sales DESC;
