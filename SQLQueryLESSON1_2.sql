-- AGGREGATE FUNCTIONS & GROUP By

-- count, avg, min, sum, max return a single value 
-- sum and avg numeric values 
-- min, max, count numeric & non-numeric (str, date etc)
-- we will learn Group by clause and having clause later. 
-- what is null? bilgi elde edilemedi. kay�p yada eksik oldu�u anlam�na gelir. agg func. nullar� dikkate almaz. 

-- COUNT bir column ka� kay�t var.  SELECT ile kullanaca��z. * character sadece count i�inde kullan�labilir. * ile Null de�erleri de sayar. 

/* Order of operations:
	1. FROM
	2. JOIN
	3. WHERE
	4. GROUP BY
	5. HAVING
	6. SELECT
	7. DISTINCT
	8. ORDER BY
	9. TOP N */

-- COUNT
SELECT *
FROM product.product

SELECT COUNT(product_id) AS num_of_product -- �r�n say�s� i�in unique de�er olan product id sayd�r�p toplam �r�n say�s�n� bulabiliriz. 
FROM product.product;

SELECT COUNT(*)
FROM product.product;

SELECT COUNT(1) -- tablodaki sat�r say�lar�na 1 de�erini atayacak ve sonra atad��� 1 leri sayacak ve sonu� yine 520 olacak.  
FROM product.product;

SELECT product_name, 1 -- product name her bir de�erin kar��s�na 1 atayacak �ekilde yeni column atar. 
FROM product.product

SELECT *
FROM sale.customer -- NULL de�erleri var phone column

SELECT COUNT(phone) -- 1892 row
FROM sale.customer 

SELECT COUNT(*) -- 2000 row
FROM sale.customer

-- How many records have a null value in the phone column?

SELECT COUNT(*)
FROM sale.customer
WHERE phone IS NULL; --108 row

SELECT COUNT(phone) -- count sadece NULL olmayan kay�tlar� sayar. buradan 1892 de�ere bakar where ile null say dedi�imizde bu say� i�inde null olmad��� i�in 0 d�ner. 
FROM sale.customer
WHERE phone IS NULL; 

-- How many customers are located in NY state?

SELECT COUNT(customer_id) AS num_of_customers
FROM sale.customer
WHERE state = 'NY'

-- COUNT DISTINCT -- unique olanlar� sayd�r�r.

SELECT COUNT(DISTINCT city) -- 48 unique �ehir var.
FROM sale.customer

 -- MIN FUNCTION --se�ilen kolonda minimum de�eri d�nd�r�r. null de�eri g�rmez. TAR�HLER ile kullan�m� �nemli...
 --MAX FUNCTION -- max. , ignore NULL, Tarihler ile kullan�m� �nemli...
 SELECT *  
 FROM product.product

 SELECT MIN(model_year) AS min_year, MAX(model_year) AS max_year
 FROM product.product

 -- what are the min and max list prices for category id 5? 

 SELECT MIN(list_price) AS min_price, MAX(list_price) AS max_price 
 FROM product.product
 WHERE category_id= 5;

 SELECT TOP 1 list_price -- Maximum list_price getirir. 
 FROM product.product
 WHERE category_id= 5
 ORDER BY list_price DESC


 -- SUM and AVG -- numeric i�in kullan�l�r. numeric columnlarda de�erlerin toplam�n� al�r. 
				-- numeric, columnlarda ortalama d�nd�r�yor. int de�er ise int d�nd�r�r. 10 tane toplam 22 ort 22/10=2 d�nd�r�r. NULL ignore

-- What is the total price of the products that belong to category 6?

SELECT SUM(list_price)
FROM product.product
WHERE category_id= 6

-- How many product sold in order_id 45?

SELECT *
FROM sale.order_item
WHERE order_id = 45

SELECT SUM(quantity)
FROM sale.order_item
WHERE order_id = 45


--AVG 

-- What is the avg list price of the 2020 model products?

SELECT AVG(list_price)
FROM product.product
WHERE model_year = 2020

-- Find the average order quantity for product 130.

SELECT AVG(quantity) -- 5 sat�lm�� 4 tane sipari� var. 5/4= 1 olarak d�nd�rd�.
FROM sale.order_item
WHERE product_id = 130


SELECT AVG(quantity*1.0) -- trick==> * 1.0 yaparsak 5/4= 1.25  olarak d�nd�rd�.
FROM sale.order_item
WHERE product_id = 130



 




