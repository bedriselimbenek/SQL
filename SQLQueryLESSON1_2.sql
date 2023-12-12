-- AGGREGATE FUNCTIONS & GROUP By

-- count, avg, min, sum, max return a single value 
-- sum and avg numeric values 
-- min, max, count numeric & non-numeric (str, date etc)
-- we will learn Group by clause and having clause later. 
-- what is null? bilgi elde edilemedi. kayýp yada eksik olduðu anlamýna gelir. agg func. nullarý dikkate almaz. 

-- COUNT bir column kaç kayýt var.  SELECT ile kullanacaðýz. * character sadece count içinde kullanýlabilir. * ile Null deðerleri de sayar. 

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

SELECT COUNT(product_id) AS num_of_product -- ürün sayýsý için unique deðer olan product id saydýrýp toplam ürün sayýsýný bulabiliriz. 
FROM product.product;

SELECT COUNT(*)
FROM product.product;

SELECT COUNT(1) -- tablodaki satýr sayýlarýna 1 deðerini atayacak ve sonra atadýðý 1 leri sayacak ve sonuç yine 520 olacak.  
FROM product.product;

SELECT product_name, 1 -- product name her bir deðerin karþýsýna 1 atayacak þekilde yeni column atar. 
FROM product.product

SELECT *
FROM sale.customer -- NULL deðerleri var phone column

SELECT COUNT(phone) -- 1892 row
FROM sale.customer 

SELECT COUNT(*) -- 2000 row
FROM sale.customer

-- How many records have a null value in the phone column?

SELECT COUNT(*)
FROM sale.customer
WHERE phone IS NULL; --108 row

SELECT COUNT(phone) -- count sadece NULL olmayan kayýtlarý sayar. buradan 1892 deðere bakar where ile null say dediðimizde bu sayý içinde null olmadýðý için 0 döner. 
FROM sale.customer
WHERE phone IS NULL; 

-- How many customers are located in NY state?

SELECT COUNT(customer_id) AS num_of_customers
FROM sale.customer
WHERE state = 'NY'

-- COUNT DISTINCT -- unique olanlarý saydýrýr.

SELECT COUNT(DISTINCT city) -- 48 unique þehir var.
FROM sale.customer

 -- MIN FUNCTION --seçilen kolonda minimum deðeri döndürür. null deðeri görmez. TARÝHLER ile kullanýmý önemli...
 --MAX FUNCTION -- max. , ignore NULL, Tarihler ile kullanýmý önemli...
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


 -- SUM and AVG -- numeric için kullanýlýr. numeric columnlarda deðerlerin toplamýný alýr. 
				-- numeric, columnlarda ortalama döndürüyor. int deðer ise int döndürür. 10 tane toplam 22 ort 22/10=2 döndürür. NULL ignore

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

SELECT AVG(quantity) -- 5 satýlmýþ 4 tane sipariþ var. 5/4= 1 olarak döndürdü.
FROM sale.order_item
WHERE product_id = 130


SELECT AVG(quantity*1.0) -- trick==> * 1.0 yaparsak 5/4= 1.25  olarak döndürdü.
FROM sale.order_item
WHERE product_id = 130



 




