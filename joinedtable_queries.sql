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