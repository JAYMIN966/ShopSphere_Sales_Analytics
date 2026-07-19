-- =========================================
-- Section 1: Basic Business KPIs
-- =========================================


--Query-1 :- Total Sales--

SELECT ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales;

--Query-2 :- Total Profit--

SELECT ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales;

--Query-3 :- Total Orders (distinct orders, not row count
-- since one order has multiple line items)

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM shopsphere_sales;

--Query-4 :- Average Order Value (sales summed per order first, then averaged --
-- not just averaging every row's sales)--

WITH order_totals AS (
    SELECT order_id, SUM(sales) AS order_value
    FROM shopsphere_sales
    GROUP BY order_id
)
SELECT ROUND(AVG(order_value), 2) AS avg_order_value
FROM order_totals;

--Query-5 :- Total Unique Customers--

SELECT COUNT(DISTINCT customer_id) AS total_unique_customers
FROM shopsphere_sales;

-- =========================================
-- Section 2: Product Performance
-- =========================================


--Query-6 :- Sales by Category--

SELECT category, ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales
GROUP BY category
ORDER BY total_sales DESC;

--Query-7 :- Profit by Category--

SELECT category, ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY category
ORDER BY total_profit DESC;

--Query-8 :- Sales by Sub-Category--

SELECT sub_category, ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales
GROUP BY sub_category
ORDER BY total_sales DESC;

--Query-9 :- Profit by Sub-Category--

SELECT sub_category, ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY sub_category
ORDER BY total_profit DESC;

--Query-10 :- Top 10 Products by Sales--

SELECT product_name, ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

--Query-11 :- Bottom 10 Products by Profit (biggest loss-makers) --

SELECT product_name, ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 10;

--Query-12 :- Most Sold Products (by Quantity) --

SELECT product_name, SUM(quantity) AS total_quantity_sold
FROM shopsphere_sales
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- =========================================
-- Section 3: Section 3: Customer Analysis
-- =========================================

--Query-13 :- Top Customers by Sales --

SELECT customer_id, ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;

--Query-14 :- Top Customers by Profit --

SELECT customer_id, ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY customer_id
ORDER BY total_profit DESC
LIMIT 10;

--Query-15 :- Number of Orders per Customer (distinct orders, not row count --
--same reasoning as before, since each order can have multiple product rows) --

SELECT customer_id, COUNT(DISTINCT order_id) AS num_orders
FROM shopsphere_sales
GROUP BY customer_id
ORDER BY num_orders DESC;

--Query-16 :- Average Spending per Customer --

SELECT customer_id, ROUND(AVG(sales), 2) AS avg_spending_per_line
FROM shopsphere_sales
GROUP BY customer_id
ORDER BY avg_spending_per_line DESC;

--Query-17 :- Customer Distribution by Segment --

SELECT segment, COUNT(DISTINCT customer_id) AS num_customers
FROM shopsphere_sales
GROUP BY segment
ORDER BY num_customers DESC;

--Query-18 :-  Highest Profit Customers (same as #14, but showing top 10 explicitly with-- --ranking) --

SELECT
    customer_id,
    ROUND(SUM(profit), 2) AS total_profit,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM shopsphere_sales
GROUP BY customer_id
ORDER BY total_profit DESC
LIMIT 10;

-- =========================================
-- Section 4: Regional Analysis
-- =========================================

--Query-19 :-   Sales by Region --

SELECT region, ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales
GROUP BY region
ORDER BY total_sales DESC;

--Query-20 :-   Profit by Region --

SELECT region, ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY region
ORDER BY total_profit DESC;

--Query-21 :-   Sales by State --

SELECT state, ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales
GROUP BY state
ORDER BY total_sales DESC;

--Query-22 :-  Profit by State --

SELECT state, ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY state
ORDER BY total_profit DESC;

--Query-23 :-  Top 10 States by Profit --

SELECT state, ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY state
ORDER BY total_profit DESC
LIMIT 10;

--Query-24 :-   Loss-Making States --

SELECT state, ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY state
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

-- =========================================
-- Section 5: Time Analysis
-- =========================================

--Query-25 :-   Monthly Sales Trend --

SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
       ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

--Query-26 :-  Monthly Profit Trend --

SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
       ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

--Query-27 :-  Yearly Sales --

SELECT EXTRACT(YEAR FROM order_date) AS year,
       ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;

--Query-28 :-  Quarterly Sales --

SELECT EXTRACT(YEAR FROM order_date) AS year,
       EXTRACT(QUARTER FROM order_date) AS quarter,
       ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(QUARTER FROM order_date)
ORDER BY year, quarter;

--Query-29 :-  Best Sales Month --

SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
       ROUND(SUM(sales), 2) AS total_sales
FROM shopsphere_sales
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY total_sales DESC
LIMIT 1;

--Query-30 :- Best Profit Month --

SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
       ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY total_profit DESC
LIMIT 1;

-- =========================================
-- Section 6: Discount & Shipping Analysis
-- =========================================

--Query-31 :- Average Discount by Category --

SELECT category, ROUND(AVG(discount), 4) AS avg_discount
FROM shopsphere_sales
GROUP BY category
ORDER BY avg_discount DESC;

--Query-32 :- Profit by Discount Level --

SELECT
    CASE
        WHEN discount = 0 THEN '0% (No Discount)'
        WHEN discount <= 0.20 THEN '1-20%'
        WHEN discount <= 0.40 THEN '21-40%'
        WHEN discount <= 0.60 THEN '41-60%'
        ELSE '60%+'
    END AS discount_level,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(*) AS num_rows
FROM shopsphere_sales
GROUP BY discount_level
ORDER BY discount_level;

--Query-33 :- Average Shipping Days --

SELECT ROUND(AVG(ship_date - order_date), 2) AS avg_shipping_days
FROM shopsphere_sales;

--Query-34 :- Shipping Days by Ship Mode --

SELECT ship_mode,
       ROUND(AVG(ship_date - order_date), 2) AS avg_shipping_days
FROM shopsphere_sales
GROUP BY ship_mode
ORDER BY avg_shipping_days;

--Query-35 :- Profit by Ship Mode--

SELECT ship_mode, ROUND(SUM(profit), 2) AS total_profit
FROM shopsphere_sales
GROUP BY ship_mode
ORDER BY total_profit DESC;

--Query-36 :- Discount Impact on Profit--

-- Overall correlation: negative value = higher discount tends to mean lower profit
SELECT ROUND(CORR(discount, profit)::numeric, 4) AS discount_profit_correlation
FROM shopsphere_sales;

-- Practical view: profit margin % by discount band (clearer story than raw totals)
SELECT
    CASE
        WHEN discount = 0 THEN '0% (No Discount)'
        WHEN discount <= 0.20 THEN '1-20%'
        WHEN discount <= 0.40 THEN '21-40%'
        WHEN discount <= 0.60 THEN '41-60%'
        ELSE '60%+'
    END AS discount_level,
    ROUND(AVG(profit / NULLIF(sales, 0)) * 100, 2) AS avg_profit_margin_pct
FROM shopsphere_sales
GROUP BY discount_level
ORDER BY discount_level;


