SELECT first_name FROM sale.customer 
SELECT DISTINCT first_name FROM sale.customer ORDER BY first_name ASC;

SELECT DISTINCT first_name FROM sale.customer ORDER BY first_name DESC;

SELECT DISTINCT customer_id, order_date From sale.orders ORDER BY order_date DESC;

SELECT DISTINCT * FROM sale.orders ORDER BY order_date ASC;

SELECT * FROM sale.orders ORDER BY order_date ASC;

SELECT customer_id FROM sale.orders WHERE customer_id > 500  ORDER BY customer_id ASC;

SELECT customer_id
FROM sale.orders
WHERE customer_id > 500
ORDER BY customer_id ASC;


SELECT TOP(3) * FROM sale.orders WHERE customer_id < 500 ORDER BY order_id ASC;