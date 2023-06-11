--DATA ANALYSIS QUERIES

--Total number of orders made in the year
SELECT COUNT(order_id)
FROM orders

--Total number of individual pizzas made in the year
SELECT COUNT(order_details_id)
FROM order_details

--Total yearly sales revenue
SELECT SUM(price) AS yearly_revenue
FROM pizzas P
JOIN order_details OD ON P.pizza_id = OD.pizza_id

--Total yearly sales revenue by pizza name
SELECT name, SUM (price) AS yearly_revenue
FROM pizza_types PT
JOIN pizzas P ON PT.pizza_type_id = P.pizza_type_id
JOIN order_details OD ON P.pizza_id = OD.pizza_id
GROUP BY name
ORDER BY yearly_revenue DESC

--TOTAL yearly sales revenue by pizza category
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
SELECT COUNT(*)/12 --Divide by 365 to return average count per day
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
SELECT SUM(price)/12 --Divide by 365 to return average sales per day
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
	COUNT(*) AS 'total_yearly_orders',
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