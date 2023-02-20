-- SQL Session-5, 18.01.2023, (Subqueries & CTEs)

----SUBQUERIES----
--**************************************

-- A subquery is a query nested inside another statement such as SELECT, INSERT, UPDATE or DELETE.
-- A subquery must be enclosed in parentheses.
-- The inner query can be run by itself.
-- The subquery in a SELECT clause must return a single value.
-- The subquery in a FROM clause must be used with an alias.
-- An ORDER BY clause is not allowed to use in a subquery.(unless TOP, OFFSET or FOR XML is also specified)

/*	1. Soru benden ne istiyor? 
	2. Ýstenen veri hangi tablolarda yer alýyor (join etmem gerekiyor mu)? 
	3. Soruda bir þart/filtreleme var mý(WHERE clause)? 
	4. Gruplama var mý(GROUP BY)?  
	5. Sýralamam gerekiyor mu (ORDER BY) 
	6. Subquery kullanacak mýyým?
Acele etmeden adým adým gidiyor. Önce subquery'i yazýyor. Ordan sonucu alýp o sonucu nerde kullanacaksa oraya yapýþtýrýyor.  
Sonra üst sorguyu tamamlýyor. */

/* Subquery, baþka bir SELECT ifadenin içine yerleþtirilmiþ bir ifadedir. Subquery'e inner query veya nested query de denir.
Bir subquery þu durumlarda kullanýlabilir:
- SELECT yan tümcesi
- FROM yan tümcesi
- WHERE yan tümcesi
Subquery kullanýrken bazý kurallar vardýr:
Bir subquery parantez içine alýnmalýdýr.
Bir ORDER BY yan tümcenin bir subquery'de kullanýlmasýna izin verilmez. Sadece TOP ile kullanýlýrsa izin verir. 
BETWEEN Operatör bir subquery ile kullanýlamaz . BETWEEN'i Ancak subquery içinde kullanabilirsiniz.
Subquery'i hangi deyimi kullanýrsanýz kullanýn, bu kurallar geçerlidir ve subquery çoðunlukla ayný þekilde yazýlýr. 
FROM yan tümcesi içinde kullanýldýðýnda alias vermek gerekir.
Üç ana subqery türü vardýr:
1- Single-row subqueries
2- Multiple-row subqueries
3- Correlated subqueries
*/


-- ****Single-Row Subqueries**** --
--**************************************

-- QUESTION: Write a query that shows all employees in the store where Davis Thomas works.
-- (Davis Thomas'ýn çalýþtýðý maðazadaki tüm personeli listeleyin)


SELECT *
FROM sale.staff


SELECT b.store_id, b.store_name, a.first_name, a.last_name
FROM sale.store b, sale.staff a
WHERE a.store_id = b.store_id AND b.store_id =
(
SELECT a.store_id
FROM sale.staff a 
WHERE a.first_name = 'Davis' and a.last_name = 'Thomas'
)

-----------------------------------------------------------

SELECT a.first_name, a.last_name
FROM sale.staff a
WHERE  a.store_id = 
(
		SELECT a.store_id
		FROM sale.staff a
		WHERE a.first_name = 'Davis' AND a.last_name = 'Thomas'
)
---------------------------------------------------------------
select * 
from sale.staff
where store_id = (
		select store_id
		from sale.staff
		where first_name='Davis' 
			and last_name='Thomas')

--------------------------------------------
select * 
from sale.staff
where store_id = 1

-- QUESTION: Write a query that shows the employees for whom Charles Cussona is a first-degree manager.(To which employees are Charles Cussona a first-degree manager?)
-- (Charles Cussona'nýn birinci derece yönetici olduðu personeli listeleyin)

select *
from sale.staff
where manager_id = (
		select staff_id
		from sale.staff
		where first_name='Charles' 
			and last_name='Cussona')


-- QUESTION: Write a query that returns the list of products that are more expensive than the product named 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'.(Also show model year and list price)
-- 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli üründen pahalý olan ürünleri listeleyin.
-- Product id, product name, model_year, fiyat, marka adý ve kategori adý alanlarýna ihtiyaç duyulmaktadýr.

select a.product_id, a.product_name, a.model_year, a.list_price, b.category_name 
from product.product a, product.category b
WHERE a.category_id = b.category_id 
AND 
list_price >
(
select list_price
from product.product
WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
);

------------------------
SELECT *
FROM product.product
WHERE list_price > (
    SELECT list_price
    FROM product.product
    WHERE product_name LIKE 'Pro-Series 49%' --- böyle baþlayan baþka bir ürün varsa sýkýntý olur. 
)
--------------------------------------------


select product_id, product_name, model_year, list_price
from product.product
where list_price > (
		select list_price
		from product.product
		where product_name='Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')



-- ****Multiple-Row Subqueries**** --
--**************************************

-- They are used with multiple-row operators such as IN, NOT IN, ANY, and ALL.
-- Multiple-row subquer'ler, IN, NOT IN, ANY, ALL gibi çok satýrlý operatörlerle birlikte kullanýlýr  vesatýr kümelerini döndürür . 
---//////////////////////////---

-- QUESTION: Write a query that returns the first name, last name, and order date of customers who ordered on the same dates as Laurel Goldammer.
-- (Laurel Goldammer isimli müþterinin alýþveriþ yaptýðý tarihlerde alýþveriþ yapan tüm müþterilerin ad, soyad ve sipariþ tarihi bilgileri listeleyin)

select a.first_name, a.last_name, b.order_date
from sale.customer a, sale.orders b
where a.customer_id=b.customer_id
and b.order_date IN(
		select order_date
		from sale.customer c, sale.orders o
		where c.customer_id=o.customer_id
			and first_name='Laurel'
			and last_name='Goldammer')


select a.first_name, a.last_name, b.order_date
from sale.customer a
inner join sale.orders b
	on a.customer_id=b.customer_id
where b.order_date IN(
		select o.order_date 
		from sale.customer c
		inner join sale.orders o
			on c.customer_id=o.customer_id
		where c.first_name='Laurel' and c.last_name='Goldammer')


-- QUESTION: List the products that ordered in the last 10 orders in Buffalo city.
-- (Buffalo þehrinde son 10 sipariþte sipariþ verilen ürünleri listeleyin)

select distinct p.product_name
from product.product p, sale.order_item oi
where p.product_id=oi.product_id
and oi.order_id IN(
		select top 10 o.order_id
		from sale.customer c
		inner join sale.orders o
			on c.customer_id=o.customer_id
		where c.city='Buffalo'
		order by o.order_date desc)



-- ****Correlated Subqueries**** --
--**************************************

-- A correlated subquery is a subquery that uses the values of the outer query. In other words, the correlated subquery depends on the outer query for its values.
-- Because of this dependency, a correlated subquery cannot be executed independently as a simple subquery.
-- Correlated subqueries are used for row-by-row processing. Each subquery is executed once for every row of the outer query.
-- A correlated subquery is also known as repeating subquery or synchronized subquery.

---//////////////////////////---


select product_id, product_name, p.category_id, list_price 
		--(select avg(list_price) from product.product where category_id=p.category_id)
from product.product p
where list_price < (select avg(list_price) from product.product where category_id=p.category_id)


-- EXISTS / NOT EXISTS

-- QUESTION: Write a query that returns a list of States where 'Apple - Pre-Owned iPad 3 - 32GB - White' product is not ordered
-- 'Apple - Pre-Owned iPad 3 - 32GB - White' isimli ürünün sipariþ verilmediði state'leri döndüren bir sorgu yazýnýz. (müþterilerin state'leri üzerinden)


select distinct state
from sale.customer x
where NOT EXISTS (
	select 1
	from product.product p, sale.order_item oi, sale.orders o, sale.customer c
	where p.product_id=oi.product_id
		and oi.order_id=o.order_id
		and o.customer_id=c.customer_id
		and p.product_name='Apple - Pre-Owned iPad 3 - 32GB - White'
		and c.state=x.state)


----///////////////////////////

-- QUESTION: Write a query that returns stock information of the products in Davi techno Retail store. 
-- The BFLO Store hasn't  got any stock of that products.

-- Davi techno maðazasýndaki ürünlerin stok bilgilerini döndüren bir sorgu yazýn. 
-- Bu ürünlerin The BFLO Store maðazasýnda stoðu bulunmuyor.




----///////////////////////////

-- Subquery in SELECT Statement

-- QUESTION: Write a query that creates a new column named "total_price" calculating the total prices of the products on each order.
-- order id'lere göre toplam list price larý hesaplayýn.



--/////////////////////////////////////////////////////////////

----CTE's (Common Table Expression)----
--********************************************

-- Common Table Expression exists for the duration of a single statement. That means they are only usable inside of the query they belong to.
-- It is also called "with statement".
-- CTE is just syntax so in theory it is just a subquery. But it is more readable.
-- An ORDER BY clause is not allowed to use in a subquery.(unless TOP, OFFSET or FOR XML is also specified)
-- Each column must have a name.

---//////////////////////////---

-- QUESTION: List customers who have an order prior to the last order date of a customer named Jerald Berray and are residents of the city of Austin. 
-- (Jerald Berray isimli müþterinin son sipariþinden önce sipariþ vermiþ 
-- ve Austin þehrinde ikamet eden müþterileri listeleyin)


WITH t1 as
(
	select max(order_date) as last_order_date
	from sale.customer c
	inner join sale.orders o
		on c.customer_id=o.customer_id
	where c.first_name='Jerald' and last_name='Berray'
)
select a.customer_id, a.first_name, a.last_name, a.city, b.order_date
from sale.customer a, sale.orders b, t1
where a.customer_id=b.customer_id
	and b.order_date < t1.last_order_date
	and a.city='austin'



-- QUESTION: List all customers their orders are on the same dates with Laurel Goldammer.
-- Laurel Goldammer isimli müþterinin alýþveriþ yaptýðý tarihte/tarihlerde alýþveriþ yapan tüm müþterileri listeleyin.
-- Müþteri adý, soyadý ve sipariþ tarihi bilgilerini listeleyin.


WITH cte as
	(
		select o.order_date
		from sale.customer c
		inner join sale.orders o
			on c.customer_id=o.customer_id
		where c.first_name='laurel' and c.last_name='goldammer'
		)
select a.first_name, a.last_name, b.order_date
from sale.customer a, sale.orders b, cte
where a.customer_id=b.customer_id
	and b.order_date=cte.order_date


-- QUESTION: List the stores whose turnovers are under the average store turnovers in 2018.
-- (2018 yýlýnda tüm maðazalarýn ortalama cirosunun altýnda ciroya sahip maðazalarý listeleyin)

WITH trn_1 as
(
	select s.store_name, sum(list_price * quantity * (1-discount)) as turnover
	from sale.order_item oi, sale.orders o, sale.store s
	where oi.order_id=o.order_id
		and o.store_id=s.store_id
	group by s.store_name
	), 
trn_2 as
	(select avg(turnover) as avg_trn
	from trn_1)
select * 
from trn_1, trn_2
where trn_1.turnover < trn_2.avg_trn


-- QUESTION: Write a query that returns the net amount of their first order for customers who placed their first order after 2019-10-01.
-- (Ýlk sipariþini 2019-10-01 tarihinden sonra veren müþterilerin ilk sipariþlerinin net tutarýný döndürünüz)


