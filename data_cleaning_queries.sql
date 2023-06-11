--DATA CLEANING

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