-- SQL SESSION-6, 19.01.2023, (Set Operators & CASE Expression)


--*******SET OPERATIONS*******--
--////////////////////////////--


-- UNION / UNION ALL-------------------------------------------------

-- QUESTION: List the products sold in the cities of Charlotte and Aurora
-- (Charlotte þehrinde satýlan ürünler ile Aurora þehrinde satýlan ürünleri listeleyin)


--view / join recap

create view sales_info_2 as
select c.customer_id, c.first_name, c.last_name, c.city, o.order_id, oi.list_price,
	   p.product_name
from sale.customer c
inner join sale.orders o on c.customer_id=o.customer_id
inner join sale.order_item oi on o.order_id=oi.order_id
inner join product.product p on oi.product_id=p.product_id

--------

alter view sales_info_2 as
select c.customer_id, c.first_name, c.last_name, c.city, o.order_id, oi.list_price,
	   p.product_name
from sale.customer c
full join sale.orders o on c.customer_id=o.customer_id
full join sale.order_item oi on o.order_id=oi.order_id
full join product.product p on oi.product_id=p.product_id

select * from sales_info_2

drop view sales_info_2

-------------------------------------

select p.product_name
from sale.customer c
inner join sale.orders o on c.customer_id=o.customer_id
inner join sale.order_item oi on o.order_id=oi.order_id
inner join product.product p on oi.product_id=p.product_id
where c.city='Charlotte'
UNION ALL
select p.product_name
from sale.customer c
inner join sale.orders o on c.customer_id=o.customer_id
inner join sale.order_item oi on o.order_id=oi.order_id
inner join product.product p on oi.product_id=p.product_id
where c.city='Aurora'

--with union

select p.product_name
from sale.customer c
inner join sale.orders o on c.customer_id=o.customer_id
inner join sale.order_item oi on o.order_id=oi.order_id
inner join product.product p on oi.product_id=p.product_id
where c.city='Charlotte'
UNION
select p.product_name
from sale.customer c
inner join sale.orders o on c.customer_id=o.customer_id
inner join sale.order_item oi on o.order_id=oi.order_id
inner join product.product p on oi.product_id=p.product_id
where c.city='Aurora'

--UNION ALL / UNION vs. IN 
--IN logical operatörü kullanýlarak da yapýlabilir.

select distinct p.product_name
from sale.customer c
inner join sale.orders o on c.customer_id=o.customer_id
inner join sale.order_item oi on o.order_id=oi.order_id
inner join product.product p on oi.product_id=p.product_id
where c.city in ('Aurora', 'charlotte')

--SOME IMPORTANT RULES OF UNION / UNION ALL
--Even if the contents of to be unified columns are different, the data type must be the same.
--NOT: Sütunlarýn içeriði farklý da olsa veritipinin ayný olmasý yeterlidir.

select *
from product.brand
UNION
select *
from product.category

----------

select 1
UNION
select 5

select 'clarusway'
UNION
select 5


--The number of columns to be unified must be the same in both queries.
--Her iki sorguda da ayný sayýda column olmasý lazým.


select brand_id, brand_name
from product.brand
UNION
select category_id
from product.category


-- QUESTION: Write a query that returns all customers whose  first or last name is Thomas.  (don't use 'OR')

SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION ALL
SELECT first_name, last_name
from sale.customer
WHERE last_name = 'Thomas'


---- other database

select city
from sale.customer
union
select capital
from [Workshop].dbo.Countries


-- INTERSECT-------------------------------------------------

-- QUESTION: Write a query that returns all brands with products for both 2018 and 2020 model year.

select brand_name
from product.brand
where brand_id IN(
		select brand_id
		from product.product
		where model_year=2018
		INTERSECT
		select brand_id
		from product.product
		where model_year=2020)

--solution with cte

WITH t1 as
(
	select brand_id
	from product.product
	where model_year=2018
	INTERSECT
	select brand_id
	from product.product
	where model_year=2020
)
select b.brand_name
from product.brand b
inner join t1 on b.brand_id=t1.brand_id


-- QUESTION: Write a query that returns the first and the last names of the customers who placed orders in all of 2018, 2019, and 2020.


select first_name, last_name
from sale.customer
where customer_id IN(
			select customer_id
			from sale.orders
			where year(order_date)=2018
			INTERSECT
			select customer_id
			from sale.orders
			where year(order_date)=2019
			INTERSECT
			select customer_id
			from sale.orders
			where year(order_date)=2020)


-- EXCEPT-------------------------------------------------

-- QUESTION: Write a query that returns the brands have 2018 model products but not 2019 model products.

select brand_id, brand_name
from product.brand
where brand_id IN(
		select brand_id
		from product.product
		where model_year=2018
		EXCEPT
		select brand_id
		from product.product
		where model_year=2019)


-- QUESTION: Write a query that contains only products ordered in 2019 (Result not include products ordered in other years)
-- (Sadece 2019 yýlýnda sipariþ verilen diðer yýllarda sipariþ verilmeyen ürünleri getiriniz)

select product_id,product_name
from product.product
where product_id IN(
					select oi.product_id
					from sale.orders o
					inner join sale.order_item oi on o.order_id=oi.order_id
					where year(order_date)=2019
					EXCEPT
					select oi.product_id
					from sale.orders o
					inner join sale.order_item oi on o.order_id=oi.order_id
					where year(order_date)<>2019)


--///////////////////////////////////////////////////////////////////////

--*******CASE EXPRESSION*******--
--////////////////////////////--


-- Simple Case Expression-------------------------------------------------

-- QUESTION: Create a new column with the meaning of the values in the Order_Status column. 
-- (Order_Status isimli alandaki deðerlerin ne anlama geldiðini içeren yeni bir alan oluþturun)

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

select order_id, order_status,
	CASE order_status
		WHEN 1 THEN 'Pending'
		WHEN 2 THEN 'Processing'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Completed'
	END orders_status_description
from sale.orders


-- Searched Case Expression-------------------------------------------------

-- QUESTION: Create a new column with the meaning of the values in the Order_Status column. 
-- (use searched case ex.)

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed


select order_id, order_status,
	CASE 
		WHEN order_status=1 THEN 'Pending'
		WHEN order_status=2 THEN 'Processing'
		WHEN order_status=3 THEN 'Rejected'
		WHEN order_status=4 THEN 'Completed'
	END orders_status_description
from sale.orders


-- QUESTION: Create a new column that shows which email service provider ("Gmail", "Hotmail", "Yahoo" or "Other" ).
-- (Müþterilerin e-mail adreslerindeki servis saðlayýcýlarýný yeni bir sütun oluþturarak belirtiniz)

select first_name, last_name, email,
		CASE
			WHEN email LIKE '%@gmail.%' THEN 'Gmail'
			WHEN email LIKE '%@hotmail.%' THEN 'Hotmail'
			WHEN email LIKE '%@yahoo.%' THEN 'Yahoo'
			WHEN email IS NOT NULL THEN 'Other'
			--ELSE NULL
		END as email_service_provider
from sale.customer


-- QUESTION: Write a query that gives the first and last names of customers who have ordered products from the computer accessories, speakers, and mp4 player categories in the same order.
-- (Ayný sipariþte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde ürün sipariþ veren müþterileri bulunuz)

select first_name,last_name
from
(
select c.customer_id, c.first_name, c.last_name, o.order_id,
	sum(case when cat.category_name='speakers' then 1 else 0 end) as spe,
	sum(case when cat.category_name='Computer Accessories' then 1 else 0 end) as ca,
	sum(case when cat.category_name='mp4 player' then 1 else 0 end) as mp4
from sale.customer c
inner join sale.orders o on c.customer_id=o.customer_id
inner join sale.order_item oi on o.order_id=oi.order_id
inner join product.product p on oi.product_id=p.product_id
inner join product.category cat on p.category_id=cat.category_id
group by c.customer_id, c.first_name, c.last_name, o.order_id) subq
where spe > 0 and ca > 0 and mp4 > 0


-----solution with cte

with cte as
(
	select c.customer_id, c.first_name, c.last_name, o.order_id,
	sum(case when cat.category_name='speakers' then 1 else 0 end) as spe,
	sum(case when cat.category_name='Computer Accessories' then 1 else 0 end) as ca,
	sum(case when cat.category_name='mp4 player' then 1 else 0 end) as mp4
	from sale.customer c
	inner join sale.orders o on c.customer_id=o.customer_id
	inner join sale.order_item oi on o.order_id=oi.order_id
	inner join product.product p on oi.product_id=p.product_id
	inner join product.category cat on p.category_id=cat.category_id
	group by c.customer_id, c.first_name, c.last_name, o.order_id
)
select first_name, last_name
from cte
where spe > 0 and ca > 0 and mp4 > 0



-- QUESTION: Write a query that returns the count of the orders day by day in a pivot table format that has been shipped two days later.
-- 2 günden geç kargolanan sipariþlerin haftanýn günlerine göre daðýlýmýný hesaplayýnýz.

