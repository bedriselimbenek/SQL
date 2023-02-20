-- SQL SESSION-2, 12.01.2023, AGGREGATE FUNCTIONS AND GROUP BY CLAUSE

/* Order of operations:
	1. FROM
	2. JOIN
	3. WHERE
	4. GROUP BY
	5. HAVING
	6. SELECT
	7. DISTINCT
	8. ORDER BY
	9. TOP N  */

-- COUNT
-- aggregate functions lar tek bir deðer döndürür. Tanýmlayýcý istatistik açýsýndan önemli.

-- Null deðer bir bilginin olmadýðýný gösterir. Bilgi elde edilememiþtir. 0 yada boþ stringe eþit deðildir.  
-- Aggregate functionslar count hariç null larý dikkate almaz. 

--Birden fazla satýra iþlem yapan AVG, SUM, COUNT vs. kullanýrken önüne bir sütun ismi yazmýyoruz. Çünkü yazarsak o sütunun bir satýrýna karþýlýk deðer geleceði için tek satýrý alýr. Örnek; COUNT tek satýr sonuç döndürdüðü için önüne yazacaðýn sütun için tek satýrý alýr. Aggragate fonsiyon kullanýrken buna dikkat et. Ama MIN, MAX’ýn önüne sütun ismi girebilirsin.

-- Aggregate fonksiyonlarý yalnýzca bir veri üretir. SUM ve AVG, yalnýzca integer deðerlere uygulanýr.
--  COUNT *, NULL dahil tüm satýrlarý sayar.
--  COUNT (colum_name) þeklinde sütun ismi girilirse NULL’lar hariç satýrlarý sayar.
--  COUNT * hariç diðer hepsi (min, max vs.) Null larý göz ardý eder. Zaten MIN, MAX vs. de * ile kullanma þekli yok.


-- how many products in the product table?

SELECT *
FROM product.product

SELECT COUNT(product_id) AS num_of_product -- product_id içindeki varsa NULL deðer saymaz.
FROM product.product

SELECT COUNT(*) AS num_of_product -- * sadece count içinde kullanýlýr. NULL deðerleri de sayar. 
FROM product.product

----------------
--bad practise
SELECT COUNT(1)  -- product tablosunda 520 satýr olduðu için 520 tane 1 atýyor ve onlarý sayýyor. 1 in indexleme ile alakasý yok...
FROM product.product;

SELECT COUNT('clarusway') -- yukarýdaki ile ayný mantýk 520 tane clarusway yazdýracaðý için 520 deðeri verir. 
FROM product.product;

SELECT 1

SELECT product_name,1
FROM product.product;
----------------------

SELECT *
FROM sale.customer

SELECT COUNT(phone) -- Null deðerleri saymaz.
FROM sale.customer

SELECT COUNT(*)  -- Null deðerleri sayar.
FROM sale.customer


-- How many records have a null value in the phone column?

SELECT COUNT(*) -- Null deðerleri içerdiði için IS NULL iþ görür
FROM sale.customer
WHERE phone IS NULL;

SELECT COUNT(phone) ---- Bu sorgu Null deðerleri içermediði için IS NULL 0 sonucunu döndürür. 
FROM sale.customer
WHERE phone IS NULL;
-------

SELECT COUNT(*) - COUNT(phone)
FROM sale.customer


-- How many customers are located in NY state?

SELECT COUNT(customer_id) AS num_of_customers -- customer_id unique olacaðýndan saydýrma iþlemini bunun üzerinden yapmak mantýklý. 
FROM sale.customer
WHERE state = 'NY';

SELECT COUNT(state) -- state tekrar edebileceði için state kullanmak tehlikeli 
FROM sale.customer
WHERE state = 'NY'


-- COUNT DISTINCT

--How many -different- city in the customer table?

SELECT COUNT(city)
FROM sale.customer

SELECT COUNT(DISTINCT city)
FROM sale.customer

-- MIN / MAX

--What are the minimum and maximum model years of products?

SELECT *
FROM product.product

SELECT MIN(model_year), MAX(model_year)
FROM product.product


--What are the min and max list prices for category id 5?

SELECT MIN(list_price), MAX(list_price)
FROM product.product
WHERE category_id=5

SELECT MAX(list_price)
FROM product.product
WHERE category_id=5

SELECT TOP 1 list_price  -- ORDER BY ile azalan bir sýralamada en üstte gelecek olan ücret en yüksek olacaktýr. 
FROM product.product
WHERE category_id=5
ORDER BY list_price DESC;

-- SUM
--What is the total list price of the products that belong to category 6?

SELECT SUM(list_price)
FROM product.product
WHERE category_id=6

--How many product sold in order_id 45?

SELECT *
FROM sale.order_item

SELECT SUM(quantity) 
FROM sale.order_item
WHERE order_id = 45;

--AVG  -- integer deðer alýrsa integer deðer olarak sonuç döndürür. integer deðerlerse 22\10 2.2 döndürmez 2 döndürür. NULL deðerleri de dikkate almaz. 

--What is the avg list price of the 2020 model products?
--float

SELECT AVG(list_price)
FROM product.product
WHERE model_year = 2020;

--Find the average order quantity for product 130.
--integer


SELECT AVG(quantity*1.0) -- integer deðer olduðu için float 1 ile çarparsak float olarak döndürür. 
FROM sale.order_item
WHERE product_id=130

---------------------------------------------------------------
-- GROUP BY
---------------------------------------------------------------

-- WHERE’i Aggregate fonksiyonundan önce çalýþtýrýr ki önce sýnýrlayýp, sýnýrlanmýþ veriye fonksiyon iþlemi uygulansýn. Böylece sistemi yormamýþ oluyor.
-- GROUP BY da WHERE’den sonra çalýþtýrýlýyor. Ayný nedenden dolayý. 
-- aggregate fonksiyonlarda yanýnda þu sütunuda göreyim diyemiyoruz. ancak bunu group by la saðlarýz.
-- SELECT’teki nonaggregate ifade (column_1), GROUP BY cümlesinde olmalý!!! Yani neyi GROUP BY’ýn yanýna yazýp grupluyor isek aynen onu SELECT yanýna yapýþtýr.

SELECT *
FROM product.product

SELECT DISTINCT model_year
FROM product.product

SELECT model_year
FROM product.product
GROUP BY model_year

--count

--How many products are in each model year?

SELECT model_year, COUNT(product_id)
FROM product.product
GROUP BY model_year

--Write a query that returns the number of products priced over $1000 by brands.

SELECT brand_id, COUNT(product_id) most_expensive_prod  -- order by selectten sonra çalýþtýðý için aliasý order by de kullanabiliriz. 
FROM product.product
WHERE list_price > 1000
GROUP BY brand_id
ORDER BY most_expensive_prod DESC; --ORDER BY COUNT(product_id) DESC

--GROUP BY, aggregate function’ý çaðýrmadan önce sonuçlarý gruplandýrýr. Bu, tüm sorgu yerine gruplara aggregate func.  uygulamanýza olanak tanýr.
--WHERE cümlesi, aggregate’ten önceki veriler üzerinde operasyon yapar (çalýþýr).
--WHERE cümlesi, GROUP BY cümlesinden önce çalýþýr. Dolayýsýyla ana tablomuzun sadece WHERE cümlesindeki þartlarý saðlayan satýrlarý gruplanýr.
--ORDER BY, GROUP BY’dan sonra gelir. (Sonucu sýralar.)
--Yani ilk önce WHERE þartý uygulanýp data filtrelenir,
--sonra üzerine GROUP BY uygulanýr,
--sonra aggregate function uygulanýr.
--Son olarak da sonuç ORDER BY a göre sýralanýr.
  
--(çalýþma sütunlarýný + koþula göre seç + fonksiyona göre gruplandýr + sýralamasýný belirle)


-- SQL'ÝN KENDÝ ÝÇÝNDEKÝ ÝÞLEM SIRASI:
--FROM : hangi tablolara gitmem gerekiyor?
--WHERE : o tablolardan hangi verileri çekmem gerekiyor?
--GROUP BY : bu bilgileri ne þekilde gruplayayým?
--SELECT : neleri getireyim ve hangi aggragate iþlemine tabi tutayým.
--HAVING : yukardaki sorgu sonucu çýkan tablo üzerinden nasýl bir filtreleme yapayým (mesela list_price>1000)
--Gruplama yaptýðýmýz ayný sorgu içinde bir filtreleme yapmak istiyorsak HAVING kullanacaðýz
--(HAVING kullanmadan; HAVING'ten yukarýsýný alýp baþka bir SELECT sorgusunda WHERE þartý ile de bu filtrelemeyi yapabiliriz.)
--ORDER BY : Çýkan sonucu hangi sýralama ile getireyim?


--WHERE ile ana tabloda bir filtreleme yapýyoruz. Ana tablo içinde herhangi bir filtreleme yapmayacaksan WHERE satýrý kullanmayacaksýn demektir.
--ORDER BY, SELECT'ten sonra çalýþýyor. Dolayýsýyla SELECT'te yazdýðým Allias'ý kabul eder!
--SELECT satýrýnda yazdýðýn sütunlarýn hepsi GROUP BY'da olmasý gerekiyor!
--ORDER BY satýrýndaki ilk parametre (örneðin) 2 ise bu SELECT satýrýndaki 2. sütuna göre sýrala demektir.
--HAVING ile ise query ile dönen sonuç üzerinde bir filtreleme yapýyoruz.
--HAVING ile sadece aggregate sonucuna bir filtre uyguluyoruz. Dolayýsýyla HAVING, GROUP BY ile birlikte kullanýlýyor.
--HAVING’de kullandýðýn sütun, aggregate te kullandýðýn sütunla ayný olmalý.


--COUNT DISTINCT WITH GROUP BY
SELECT brand_id, COUNT(DISTINCT category_id) -- markanýn kaç kategoride ürünü var. farklý kategoriler için dýstýnct atmalýyýz. 
FROM product.product
GROUP BY brand_id;

SELECT brand_id, category_id
FROM product.product
GROUP BY brand_id, category_id -- marka ve kategori ye göre gruplayýp her markanýn kaç kategoride ürünü var onu gördük bunu saydýrmak için 194. satýrdaki query yazýlmalý. 

select order_id, product_id--, max(list_price)
from sale.order_item
group by order_id, product_id
order by order_id;

select *
from sale.order_item

-- MIN/MAX

--Find the first and last purchase dates for each customer. (Her müþteri için ilk ve son satýn alma tarihlerini bulun.)

SELECT customer_id, 
	MIN(order_date) first_order, 
	MAX(order_date) last_order
FROM sale.orders
GROUP BY customer_id

-- Find min and max product prices of each brand.

SELECT brand_id, 
	MIN(list_price) min_price, 
	MAX(list_price) max_price
FROM product.product
GROUP BY brand_id

--SUM / AVG

---find the total discount amount of each order (her bir sipariþin toplam indirim tutarýný bulun)

SELECT * FROM sale.order_item

SELECT order_id, 
	SUM(quantity * list_price * discount) total_amount --quantity * list_price * discount indirim tutarýný elde ederiz.
FROM sale.order_item
GROUP BY order_id

SELECT order_id, list_price*2, -- product 1 ürünü iki tane olduðu için 2 ile çarptýk. 
	SUM(quantity * list_price * (1-discount)) total_amount, -- quantity * list_price * (1-discount) ürüne indirim uygulandýktan sonra fiyatý. 
	SUM(quantity * list_price * discount) total_amount
FROM sale.order_item
WHERE order_id=1 AND product_id=8
GROUP BY order_id, list_price

---What is the average list price for each model year?

SELECT model_year, AVG(list_price)
FROM product.product
GROUP BY model_year

-------------------------------------------------------------------

--INTERVIEW QUESTION: 
--Write a query that returns the most repeated name in the customer table.

SELECT TOP 1 first_name, COUNT(first_name)
FROM  sale.customer
GROUP BY first_name 
ORDER BY COUNT(first_name) DESC

SELECT TOP 1 first_name, COUNT(*) freq
FROM sale.customer
GROUP BY first_name
ORDER BY freq DESC

---- Find the state where "yandex" is used the most? (with number of users)

SELECT TOP 1 [state], COUNT(email) AS num_of_yandex_mail 
FROM sale.customer
WHERE email LIKE '%yandex%'
GROUP BY [state]
ORDER BY num_of_yandex_mail DESC;

-- sale.customer tablosunda email içinde yandex geçenleri eyaletlerine göre grupla ve
-- her eyalete düþen yandex içeren emailleri say bu sayýya göre azalan þekilde sýrala ve en fazla olaný getir. 