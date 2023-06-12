--Inspecting each data table
SELECT * FROM orders

SELECT * FROM order_details

SELECT * FROM pizzas

SELECT * FROM pizza_types

--Joining orders and order_details tables
SELECT O.order_id, O.date, O.time, OD.order_id, OD.order_details_id, OD.pizza_id, OD.quantity
FROM order_details OD
JOIN orders O ON O.order_id = OD.order_id

--Joining order_details and pizzas tables
SELECT OD.order_id, OD.order_details_id, OD.pizza_id, OD.quantity, P.pizza_id, P.pizza_type_id, P.size, P.price
FROM pizzas P
JOIN order_details OD ON OD.pizza_id = P.pizza_id

--Joining pizzas and pizza_types tables
SELECT P.pizza_id, P.pizza_type_id, P.size, P.price, PT.pizza_type_id, PT.name, PT.category, PT.ingredients
FROM pizza_types PT
JOIN pizzas P ON P.pizza_type_id = PT.pizza_type_id

--All tables joined with redundant columns
SELECT *
FROM order_details OD
JOIN orders O ON O.order_id = OD.order_id
JOIN pizzas P ON P.pizza_id = OD.pizza_id
JOIN pizza_types PT ON PT.pizza_type_id = P.pizza_type_id

--All tables joined without redundant columns
SELECT O.order_id, O.date, O.time, OD.order_details_id, OD.pizza_id, OD.quantity, P.pizza_type_id, P.size, P.price, PT.name, PT.category, PT.ingredients
FROM order_details OD
JOIN orders O ON O.order_id = OD.order_id
JOIN pizzas P ON P.pizza_id = OD.pizza_id
JOIN pizza_types PT ON PT.pizza_type_id = P.pizza_type_id

--DATA CLEANING QUERIES

--Establishing foreign keys on tables
ALTER TABLE order_details
ADD FOREIGN KEY (order_id) REFERENCES
orders(order_id)

ALTER TABLE order_details
ADD FOREIGN KEY (pizza_id) REFERENCES
pizzas(pizza_id)

ALTER TABLE pizzas
ADD FOREIGN KEY (pizza_type_id) REFERENCES
pizza_types(pizza_type_id)

--Changing price column data type from float to decimal
ALTER TABLE pizzas 
ALTER COLUMN price DECIMAL(12,2) NOT NULL

--Checking for NULL values orders table
SELECT 
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Column_1, 
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS Column_2, 
    SUM(CASE WHEN time IS NULL THEN 1 ELSE 0 END) AS Column_3
FROM orders

--Checking for NULL values order_details table
SELECT 
    SUM(CASE WHEN order_details_id IS NULL THEN 1 ELSE 0 END) AS Column_1, 
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Column_2, 
    SUM(CASE WHEN pizza_id IS NULL THEN 1 ELSE 0 END) AS Column_3,
	SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS Column_4
FROM order_details

--Checking for NULL values pizzas table
SELECT 
    SUM(CASE WHEN pizza_id IS NULL THEN 1 ELSE 0 END) AS Column_1, 
    SUM(CASE WHEN pizza_type_id IS NULL THEN 1 ELSE 0 END) AS Column_2, 
    SUM(CASE WHEN size IS NULL THEN 1 ELSE 0 END) AS Column_3,
	SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS Column_4
FROM pizzas

--Checking for NULL values pizza_types table
SELECT 
    SUM(CASE WHEN pizza_type_id IS NULL THEN 1 ELSE 0 END) AS Column_1, 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS Column_2, 
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS Column_3,
	SUM(CASE WHEN ingredients IS NULL THEN 1 ELSE 0 END) AS Column_4
FROM pizza_types

--Checking for dates NOT in 2015 and in orders table
SELECT date
FROM orders
WHERE date NOT LIKE '2015%'

--Checking for times NOT between 0:00 and 23:59 hours in orders table.
SELECT time
FROM orders
WHERE 
	(DATEPART(hour,time)) NOT BETWEEN 0 AND 23

--Cleaning up string in pizza_types table
UPDATE pizza_types
SET ingredients = '`Nduja Salami, Pancetta, Tomatoes, Red Onions, Friggitello Peppers, Garlic'
WHERE ingredients = '�Nduja Salami, Pancetta, Tomatoes, Red Onions, Friggitello Peppers, Garlic'

--DATA ANALYSIS QUERIES

--Total number of orders made in the year
SELECT COUNT(order_id) AS yearly_orders
FROM orders

--Average number of orders made per day.
SELECT COUNT(order_id) / (SELECT COUNT(DISTINCT date) FROM orders) AS avg_daily_orders --The business operated for 358 days of the year
FROM orders

--Total number of individual pizzas made in the year
SELECT COUNT(order_details_id)
FROM order_details

--Average number of pizzas per order
SELECT 
	COUNT(order_details_id) AS total_pizzas_made,
	COUNT(DISTINCT order_id) AS total_orders,
	COUNT(order_details_id) / COUNT(DISTINCT order_id) AS avg_pizzas
FROM order_details

--Number of pizzas ordered by order_id
SELECT order_id,
	COUNT(order_id) AS number_pizzas_ordered
FROM order_details
GROUP BY order_id
ORDER BY number_pizzas_ordered DESC

--Number of distinct customers that ordered 2 pizzas
WITH temp_table AS (
SELECT order_id,
	COUNT(order_id) AS number_pizzas_ordered
FROM order_details
GROUP BY order_id)

SELECT
	COUNT(number_pizzas_ordered) AS number_customers
FROM temp_table
WHERE number_pizzas_ordered = 2

--Total yearly sales revenue
SELECT SUM(price) AS yearly_revenue
FROM pizzas P
JOIN order_details OD ON P.pizza_id = OD.pizza_id

--Average number of sales made per day.
SELECT SUM(price) / (SELECT COUNT(DISTINCT date) FROM orders) AS avg_daily_sales --The business operated for 358 days of the year
FROM order_details OD
JOIN orders O ON O.order_id = OD.order_id
JOIN pizzas P ON P.pizza_id = OD.pizza_id

--Total yearly sales revenue by pizza name
SELECT name, SUM (price) AS yearly_revenue
FROM pizza_types PT
JOIN pizzas P ON PT.pizza_type_id = P.pizza_type_id
JOIN order_details OD ON P.pizza_id = OD.pizza_id
GROUP BY name
ORDER BY yearly_revenue DESC

--Total yearly sales revenue by pizza category
SELECT category, SUM(price) AS yearly_revenue
FROM pizza_types PT
JOIN pizzas P ON PT.pizza_type_id = P.pizza_type_id
JOIN order_details OD ON P.pizza_id = OD.pizza_id
GROUP BY category
ORDER BY yearly_revenue DESC

--Total yearly sales revenue by pizza size
SELECT size, SUM(price) AS yearly_revenue
FROM pizzas P
JOIN order_details OD ON P.pizza_id = OD.pizza_id
GROUP BY size
ORDER BY yearly_revenue DESC

--Total yearly count sold of individual pizzas by pizza name
SELECT name, SUM(quantity) AS yearly_quantity
FROM pizza_types PT
JOIN pizzas P ON PT.pizza_type_id = P.pizza_type_id
JOIN order_details OD ON P.pizza_id = OD.pizza_id
GROUP BY name
ORDER BY yearly_quantity DESC

--Pizzas not ordered at all the entire year
SELECT order_details_id, p.pizza_id
FROM order_details OD
FULL JOIN pizzas P ON P.pizza_id = OD.pizza_id
WHERE OD.order_details_id IS NULL

--Total yearly count sold of individual pizzas by pizza category
SELECT category, SUM(quantity) AS yearly_quantity
FROM pizza_types PT
JOIN pizzas P ON PT.pizza_type_id = P.pizza_type_id
JOIN order_details OD ON P.pizza_id = OD.pizza_id
GROUP BY category
ORDER BY yearly_quantity DESC

--Total yearly count sold of individual pizzas by pizza size
SELECT size, SUM(quantity) AS yearly_quantity
FROM pizza_types PT
JOIN pizzas P ON PT.pizza_type_id = P.pizza_type_id
JOIN order_details OD ON P.pizza_id = OD.pizza_id
GROUP BY size
ORDER BY yearly_quantity DESC

--What is the average price for each pizza by name?
SELECT name, AVG(price) AS avg_price
FROM pizza_types PT
JOIN pizzas P ON P.pizza_type_id = PT.pizza_type_id
GROUP BY name
ORDER BY avg_price DESC

--What is the average price for each pizza by category?
SELECT category, AVG(price) AS avg_price
FROM pizza_types PT
JOIN pizzas P ON P.pizza_type_id = PT.pizza_type_id
GROUP BY category
ORDER BY avg_price DESC

--What is the average price for each pizza by size?
SELECT size, AVG(price) AS avg_price
FROM pizza_types PT
JOIN pizzas P ON P.pizza_type_id = PT.pizza_type_id
GROUP BY size
ORDER BY avg_price DESC

--What size options are available for each pizza by name?
WITH temp_table AS 
(SELECT name, size
FROM pizza_types PT
JOIN pizzas P ON P.pizza_type_id = PT.pizza_type_id)

SELECT name, STRING_AGG(size, ', ') AS sizes_available
FROM temp_table
GROUP BY name

--What is the average count of pizzas sold per month?
SELECT COUNT(*)/12 --Divide by 358 to return average count per day. (The business operated for 358 days of the year)
FROM pizzas P
JOIN order_details OD ON OD.pizza_id = P.pizza_id

--What is the count of pizzas sold for each individual month?
WITH temp_table AS(
SELECT *,
	DATEPART(month, date) AS month_number
FROM orders)

SELECT month_number,
	COUNT(month_number) AS total_number_orders
FROM temp_table
GROUP BY month_number
ORDER BY month_number

--What are the average sales per month?
SELECT SUM(price)/12 --Divide by 358 to return average sales per day. (The business operated for 358 days of the year)
FROM pizzas P
JOIN order_details OD ON OD.pizza_id = P.pizza_id

--What are the sales for each individual month?
WITH temp_table AS(
SELECT price,
	DATEPART(month, date) AS month_number
FROM pizzas P
JOIN order_details OD ON OD.pizza_id = P.pizza_id
JOIN orders O ON O.order_id = OD.order_id)

SELECT month_number,
	SUM(price) AS sum_price
FROM temp_table
GROUP BY month_number
ORDER BY month_number

--What is the yearly count of pizzas sold for each day of the week?
WITH temp_table AS(
SELECT *,
	DATEPART(weekday, date) AS day_of_week
FROM orders)

SELECT day_of_week,
	COUNT(day_of_week) AS total_number_orders
FROM temp_table
GROUP BY day_of_week
ORDER BY total_number_orders DESC

--What is the average count of pizzas ordered by day of the week?
WITH temp_table AS(
SELECT *,
	DATEPART(weekday, date) AS day_of_week
FROM orders)

SELECT day_of_week,
	COUNT(*) AS total_yearly_orders,
	COUNT(order_id) / COUNT (DISTINCT date) AS avg_order_per_weekday
FROM temp_table
GROUP BY day_of_week
ORDER BY avg_order_per_weekday DESC

--What are the yearly sales for each day of the week?
WITH temp_table AS(
SELECT price,
	DATEPART(weekday, date) AS day_of_week
FROM pizzas P
JOIN order_details OD ON OD.pizza_id = P.pizza_id
JOIN orders O ON O.order_id = OD.order_id)

SELECT day_of_week,
	SUM(price) AS sum_price
FROM temp_table
GROUP BY day_of_week
ORDER BY sum_price DESC

--What is the yearly count of pizzas sold for each hour of the day?
WITH temp_table AS(
SELECT *,
	DATEPART(hour, time) AS hour_of_day
FROM orders)

SELECT hour_of_day,
	COUNT(hour_of_day) AS total_number_orders
FROM temp_table
GROUP BY hour_of_day
ORDER BY total_number_orders DESC

--What are the yearly sales for each hour of the day?
WITH temp_table AS(
SELECT price,
	DATEPART(hour, time) AS hour_of_day
FROM pizzas P
JOIN order_details OD ON OD.pizza_id = P.pizza_id
JOIN orders O ON O.order_id = OD.order_id)

SELECT hour_of_day,
	SUM(price) AS sum_price
FROM temp_table
GROUP BY hour_of_day
ORDER BY sum_price DESC

--What is the hour and day of the week when the most orders are made?
WITH temp_table AS(
SELECT *,
	DATEPART(weekday, date) AS day_of_week,
	DATEPART(hour, time) AS hour_of_day
FROM orders)

SELECT day_of_week, hour_of_day,
	COUNT(day_of_week) AS total_number_orders
FROM temp_table
GROUP BY day_of_week, hour_of_day
ORDER BY total_number_orders DESC

--What dates had the most total orders?
WITH temp_table AS(
SELECT date,
	COUNT(*) AS total_number_orders
FROM orders O
JOIN order_details OD ON OD.order_id = O.order_id
GROUP BY date)

SELECT *,
	DATEPART(weekday, date) AS day_of_week
FROM temp_table
ORDER BY total_number_orders DESC

--What dates generated the most sales revenue?
WITH temp_table AS(
SELECT price, date
FROM pizzas P
JOIN order_details OD ON OD.pizza_id = P.pizza_id
JOIN orders O ON O.order_id = OD.order_id)

SELECT date,
	SUM(price) AS sum_price
FROM temp_table
GROUP BY date
ORDER BY sum_price DESC