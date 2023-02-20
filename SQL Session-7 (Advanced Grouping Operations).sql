--SQL Session-7, 21.01.2023, (Advanced Grouping Operations)

--************HAVING************--
------------------------------------------------------------------------

--QUESTION: Write a query that checks if any product id is duplicated in product table.
--(product tablosunda herhangi bir product id'nin çoklayýp çoklamadýðýný kontrol ediniz)

SELECT
	product_id, COUNT(product_id) num_of_products
FROM
	product.product
GROUP BY
	product_id
HAVING
	COUNT(product_id) > 1

-----for product names

SELECT
	product_name, COUNT(product_name) num_of_products
FROM
	product.product
GROUP BY
	product_name
HAVING
	COUNT(product_name) > 1


--///////////////////////////////
--QUESTION: Write a query that returns category ids with conditions max list price above 4000 or a min list price below 500.
--(maximum list price'ý 4000'in üzerinde olan veya minimum list price'ý 500'ün altýnda olan categori id' leri getiriniz - category name istenmiyor)

SELECT
	category_id, 
	MAX(list_price) max_price,
	MIN(list_price) min_price
FROM
	product.product
GROUP BY
	category_id
HAVING
	MAX(list_price) > 4000
	OR MIN(list_price) < 500;


--///////////////////////////////
--QUESTION: Find the average product prices of the brands. Display brand name and average prices in descending order.
--(Markalara ait ortalama ürün fiyatlarýný, ortalama fiyatlara göre azalan sýrayla gösteriniz)

SELECT
	b.brand_name,
	AVG(list_price) avg_price
FROM
	product.product p
	INNER JOIN
	product.brand b
	ON p.brand_id=b.brand_id
GROUP BY
	b.brand_name
ORDER BY
	avg_price DESC;


--Write a query that returns the list of brands whose average product prices are more than 1000
--(ortalama ürün fiyatý 1000'den yüksek olan MARKALARI getiriniz)

SELECT
	b.brand_name,
	AVG(list_price) avg_price
FROM
	product.product p
	INNER JOIN
	product.brand b
	ON p.brand_id=b.brand_id
GROUP BY
	b.brand_name
HAVING
	AVG(list_price) > 1000
ORDER BY
	avg_price DESC;


--///////////////////////////////
--QUESTION: Write a query that returns the list of each order id and that order's total 
-- net price (please take into consideration of discounts and quantities)

--her sipariþin toplam net tutarýný getiriniz. (müþterinin sipariþ için ödediði tutar)
--discount'ý ve quantity'yi ihmal etmeyiniz.


--price calculation for every ordered item

SELECT
	*, 
	quantity * list_price * (1 - discount) net_price
FROM
	sale.order_item

--price calculation for each order

SELECT
	order_id, 
	SUM(quantity * list_price * (1 - discount)) net_price
FROM
	sale.order_item
GROUP BY
	order_id

----

SELECT
	order_id, 
	CAST(SUM(quantity * list_price * (1 - discount)) AS NUMERIC(10,2)) net_price
FROM
	sale.order_item
GROUP BY
	order_id
HAVING
	SUM(quantity * list_price * (1 - discount)) > 5000


--///////////////////////////////
--QUESTION: Write a query that returns monthly order counts of the States.
--(State'lerin aylýk sipariþ sayýlarýný hesaplayýnýz)

SELECT
	c.state, YEAR(o.order_date) years,
	MONTH(o.order_date) months
FROM
	sale.customer c
	INNER JOIN 
	sale.orders o
	ON c.customer_id=o.customer_id
ORDER BY
	c.state, years,
	months

---------------------------

SELECT
	c.state, YEAR(order_date) years,
	MONTH(order_date) months,
	COUNT(order_id) num_of_orders
FROM
	sale.customer c
	INNER JOIN 
	sale.orders o
	ON c.customer_id=o.customer_id
GROUP BY
	c.state, YEAR(order_date),
	MONTH(order_date)
HAVING
	COUNT(order_id) > 3



--************GROUPING SETS************--
------------------------------------------------------------------------

SELECT * FROM sale.order_item

--1. Calculate the total sales price (toplam satýþ miktarýný hesaplayýnýz)

SELECT
	SUM(quantity * list_price * (1 - discount)) net_sales_price
FROM
	sale.order_item


--2. Calculate the total sales price of the brands (Markalarýn toplam satýþ miktarýný hesaplayýnýz)

SELECT
	b.brand_name,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) net_sales_price
FROM
	SALE.order_item oi
	INNER JOIN
	product.product p ON oi.product_id=p.product_id
	INNER JOIN
	product.brand b ON p.brand_id=b.brand_id
GROUP BY
	b.brand_name


--3. Calculate the total sales price of the categories (Kategori bazýnda toplam satýþ miktarýný hesaplayýnýz)

SELECT
	c.category_name,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) net_sales_price
FROM
	SALE.order_item oi
	INNER JOIN
	product.product p ON oi.product_id=p.product_id
	INNER JOIN
	product.category c ON p.category_id=c.category_id
GROUP BY
	c.category_name


--4. Calculate the total sales price by brands and categories. (Marka ve kategori kýrýlýmýndaki toplam sales miktarýný hesaplayýnýz)

SELECT
	b.brand_name, c.category_name,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) net_sales_price
FROM
	SALE.order_item oi
	INNER JOIN
	product.product p ON oi.product_id=p.product_id
	INNER JOIN
	product.brand b ON p.brand_id=b.brand_id
	INNER JOIN
	product.category c ON p.category_id=c.category_id
GROUP BY
	b.brand_name, c.category_name
ORDER BY
	b.brand_name, c.category_name


------with model years

SELECT
	b.brand_name, c.category_name, p.model_year,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) net_sales_price
FROM
	SALE.order_item oi
	INNER JOIN
	product.product p ON oi.product_id=p.product_id
	INNER JOIN
	product.brand b ON p.brand_id=b.brand_id
	INNER JOIN
	product.category c ON p.category_id=c.category_id
GROUP BY
	b.brand_name, c.category_name, p.model_year
ORDER BY
	b.brand_name, c.category_name


--Perform the above four variations in a single query using 'Grouping Sets'.
--Yukarýdaki 4 maddede istenileni tek bir sorguda getirmek için Grouping sets kullanýlabilir
--Yani brand, category, brand + category, total


SELECT
	b.brand_name, c.category_name, 
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) net_sales_price
FROM
	SALE.order_item oi
	INNER JOIN
	product.product p ON oi.product_id=p.product_id
	INNER JOIN
	product.brand b ON p.brand_id=b.brand_id
	INNER JOIN
	product.category c ON p.category_id=c.category_id
GROUP BY
	GROUPING SETS(
		(b.brand_name, c.category_name),
		(b.brand_name),
		(c.category_name),
		()
	)
ORDER BY
	1,2;

---- with model year

SELECT
	b.brand_name, c.category_name, p.model_year, 
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) net_sales_price
FROM
	SALE.order_item oi
	INNER JOIN
	product.product p ON oi.product_id=p.product_id
	INNER JOIN
	product.brand b ON p.brand_id=b.brand_id
	INNER JOIN
	product.category c ON p.category_id=c.category_id
GROUP BY
	GROUPING SETS(
		(b.brand_name, c.category_name, p.model_year),
		(b.brand_name, c.category_name),
		(b.brand_name, p.model_year),
		(c.category_name, p.model_year),
		(b.brand_name),
		(c.category_name),
		(p.model_year),
		()
	)
ORDER BY
	1,2,3;


--************PIVOT************--
------------------------------------------------------------------------

--QUESTION: Write a query using summary table that returns the number of products for each category by model year. (in pivot table format)
--(kategorilere ve model yýlýna göre toplam ürün sayýsýný summary tablosu üzerinden hesaplayýn)

SELECT b.brand_name, p.model_year,
		COUNT(p.product_id)
FROM product.product p
INNER JOIN product.brand b
	ON p.brand_id=b.brand_id
GROUP BY b.brand_name, p.model_year
ORDER BY 1,2


--1. Select the columns from related table(s) as the base data for pivoting:

select model_year, product_id
from product.product

--2. Create a temporary result set using a derived table:

select * from (
	select model_year, product_id
	from product.product
) t


--3. Apply the PIVOT operator:

select * from (
	select model_year, product_id
	from product.product
) t
PIVOT (
	COUNT(product_id)
	FOR model_year IN(
		[2018],
		[2019],
		[2020],
		[2021])
) AS pvt;


--4. Add a dimension to the pivot table. (brand_name)

select * from (
	select model_year, product_id, b.brand_name
	from product.product p
	inner join product.brand b
		on p.brand_id=b.brand_id
) t
PIVOT (
	COUNT(product_id)
	FOR model_year IN(
		[2018],
		[2019],
		[2020],
		[2021])
) AS pvt;



--generating column values
--QUOTENAME function

SELECT QUOTENAME(category_name) + ','
FROM product.category

[Televisions & Accessories],
[Camera],
[Dryer],
[Computer Accessories],
[Speakers],
[mp4 player],
[Home Theater],
[Car Electronics],
[Digital Camera Accessories],
[Hi-Fi Systems],
[Earbud],
[Game],
[Audio & Video Accessories],
[Bluetooth],
[gps],
[Receivers Amplifiers]


--///////////////////////////////
--QUESTION: Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.
--(Ýki günden geç kargolanan sipariþlerin haftanýn günlerine göre daðýlýmýný hesaplayýnýz)

SELECT DATENAME(dw, order_date) as day_of_week, order_id
FROM sale.orders
WHERE DATEDIFF(day, order_date, shipped_date) > 2


SELECT * FROM (
	SELECT DATENAME(dw, order_date) as day_of_week, order_id
	FROM sale.orders
	WHERE DATEDIFF(day, order_date, shipped_date) > 2
) t
PIVOT(
	COUNT(order_id)
	FOR day_of_week IN(
		[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday])
) as pvt


		

