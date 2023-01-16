-- SQL SESSÝON-1, 11.01.2023, SQL BASIC COMMANDS
USE SampleRetail
--SELECT

--SQL SESSÝON-1 11.01.2023, SQL BASÝC COMMANDS BEN
-- SELECT

SELECT 1
SELECT 'mARTÝN'

SELECT 1,'MARTÝN'

SELECT 'mustafa' AS cohort_13 ,'ertan' AS cohort_13,'barýþ' AS cohort_14

SELECT 1 AS 'ID','MARTÝN'AS [first name]
SELECT 1 AS 'ID','MARTÝN'AS 'first name'
SELECT 1 AS 'ID','MARTÝN'AS firstname

--from

SELECT *
FROM sale.customer

SELECT first_name 
FROM sale.customer
SELECT email,first_name,last_name 
FROM sale.customer

--WHERE  filtreleme

SELECT first_name,last_name,city,state
FROM sale.customer 
WHERE city='Atlanta';

SELECT first_name,last_name,city,state
FROM sale.customer 
WHERE NOT city='Atlanta';

-- AND / OR

SELECT first_name,last_name,city,state
FROM sale.customer 
WHERE state='TX' or city='Allen';

SELECT first_name,last_name,city,state
FROM sale.customer 
WHERE last_name='Chan' AND state='TX' OR state='NY';

SELECT first_name,last_name,city,state
FROM sale.customer 
WHERE last_name='Chan' AND (state='TX' OR state='NY');

--IN / NOT IN
SELECT first_name,last_name,city,state
FROM sale.customer 
WHERE  state='TX' ;

SELECT first_name,last_name,city,state
FROM sale.customer 
WHERE  state='TX' AND city IN ('allen','Austin');

SELECT first_name,last_name,city,state
FROM sale.customer 
WHERE  state='TX' AND city NOT IN ('allen','Austin');

--LÝKE
--'_' match nay single character
-- '%' unknown character numbers

SELECT * 
FROM sale.customer
WHERE email LIKE '%yahoo%';

SELECT * 
FROM sale.customer
WHERE email LIKE 'yahoo%'; -- boþ döndürür. yahoo ile baþlayan bir veri yok.

SELECT * 
FROM sale.customer
WHERE first_name LIKE 'Di_ne'

SELECT * 
FROM sale.customer
WHERE first_name LIKE 'Di__ne'

SELECT * 
FROM sale.customer
WHERE first_name LIKE '[TZ]%'; -- T yada Z ile baþlasýn % sonrasý ne olursa olsun

SELECT * 
FROM sale.customer
WHERE first_name LIKE '[T-Z]%'; -- T ile Z arasýndaki harflerle baþlayanlara getirir. 

-- BETWEEN

SELECT * 
FROM product.product
WHERE list_price BETWEEN 599 AND 999; -- Yazýlan deðerler dahildir. 

SELECT * 
FROM sale.orders
WHERE order_date 
	BETWEEN '2018-01-05' 
		AND '2018-01-08';

-- <, >, <=, >=, =, !=, <>

SELECT * 
FROM product.product
WHERE list_price < 1000;

-- IS NULL / IS NOT NULL -- Null deðerleri getirir. Not null olmayanlarý getirir.

SELECT *
FROM sale.customer
WHERE phone IS NULL; 

SELECT *
FROM sale.customer
WHERE phone IS NOT NULL;

-- TOP N

SELECT TOP 10 *
FROM sale.orders;

SELECT TOP 10 customer_id 
FROM sale.customer;

-- ORDER BY -- default ASC

SELECT TOP 10 *
FROM sale.orders
ORDER BY order_id DESC;

SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY first_name ASC, last_name DESC;,


SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY 1 ASC, 2 DESC; -- Select yapýlan seçimlerden birincisi (first_name) ve ikincisini sýralar.


SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY customer_id DESC; -- buraya yazýlan column selecte yazýlmak zorunda deðiliz.

-- DISTINCT 

SELECT DISTINCT state
FROM sale.customer

SELECT DISTINCT state, city -- state tekrarlayabilir ama city tekrarlamaz. CA da kaç þehir olduðunu görebiliyoruz. 
FROM sale.customer

SELECT DISTINCT *  -- duplicate rows customer_id unique deðerlere sahip olduðu için bütün hepsini döndürür.
FROM sale.customer

-- SQL SESSION-2 12.01.2023, AGGREGATE FUNCTIONS AND GROUP BY CLAUSE

/* Order of operations:
	1. FROM 
	2. JOIN 
	3. WHERE 
	4. GROUP BY
	5. HAVING
	6. SELECT
	7. DISTINCT
	8. ORDER BY
	9. TOP N, */


-- COUNT

SELECT *
FROM product.product

SELECT COUNT(product_id) AS num_of_product
FROM product.product

SELECT COUNT(1)  -- product içinde 520 sütun olduðu için bir yazsakta 520 olarak sayacak. ordaki 1 index deðil....
FROM product.product

SELECT *
FROM sale.customer

SELECT COUNT(phone)
FROM sale.customer

SELECT COUNT(*)
FROM sale.customer
WHERE phone IS NULL;


-- How many customer are located in NY state?
SELECT COUNT(*)
FROM sale.customer
WHERE state = 'NY';

--COUNT DISTINCT 

SELECT COUNT(city)
FROM sale.customer

SELECT COUNT(DISTINCT city) 
FROM sale.customer


SELECT SUM(quantity)
FROM sale.order_item
WHERE order_id = 45;

SELECT AVG(list_price)
FROM product.product
WHERE model_year = 2020;

SELECT AVG(quantity)
FROM sale.order_item
WHERE product_id = 130



SELECT model_year, COUNT(product_id)
FROM product.product
GROUP BY model_year 

SELECT brand_id, COUNT(product_id) most_expensive_prod
FROM product.product
WHERE list_price > 1000
GROUP BY brand_id
ORDER BY COUNT(product_id) DESC;

SELECT customer_id, 
	MIN(order_date) first_order, 
	MAX(order_date) last_order
FROM sale.orders
GROUP BY customer_id

SELECT model_year, 
	AVG(list_price) avg_price
FROM product.product
GROUP BY model_year

SELECT TOP 1 first_name, COUNT(first_name) AS quantity
FROM sale.customer
GROUP BY first_name
ORDER BY quantity DESC;

SELECT TOP 1 first_name, COUNT(*) freq
FROM sale.customer
GROUP BY first_name
ORDER BY freq DESC

SELECT TOP 1 state, COUNT(*)
FROM sale.customer
WHERE email LIKE '%yandex%'
GROUP BY state
ORDER BY COUNT(*) DESC;