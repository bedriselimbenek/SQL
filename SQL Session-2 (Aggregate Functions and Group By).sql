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
-- aggregate functions lar tek bir de�er d�nd�r�r. Tan�mlay�c� istatistik a��s�ndan �nemli.

-- Null de�er bir bilginin olmad���n� g�sterir. Bilgi elde edilememi�tir. 0 yada bo� stringe e�it de�ildir.  
-- Aggregate functionslar count hari� null lar� dikkate almaz. 

--Birden fazla sat�ra i�lem yapan AVG, SUM, COUNT vs. kullan�rken �n�ne bir s�tun ismi yazm�yoruz. ��nk� yazarsak o s�tunun bir sat�r�na kar��l�k de�er gelece�i i�in tek sat�r� al�r. �rnek; COUNT tek sat�r sonu� d�nd�rd��� i�in �n�ne yazaca��n s�tun i�in tek sat�r� al�r. Aggragate fonsiyon kullan�rken buna dikkat et. Ama MIN, MAX��n �n�ne s�tun ismi girebilirsin.

-- Aggregate fonksiyonlar� yaln�zca bir veri �retir. SUM ve AVG, yaln�zca integer de�erlere uygulan�r.
--  COUNT *, NULL dahil t�m sat�rlar� sayar.
--  COUNT (colum_name) �eklinde s�tun ismi girilirse NULL�lar hari� sat�rlar� sayar.
--  COUNT * hari� di�er hepsi (min, max vs.) Null lar� g�z ard� eder. Zaten MIN, MAX vs. de * ile kullanma �ekli yok.


-- how many products in the product table?

SELECT *
FROM product.product

SELECT COUNT(product_id) AS num_of_product -- product_id i�indeki varsa NULL de�er saymaz.
FROM product.product

SELECT COUNT(*) AS num_of_product -- * sadece count i�inde kullan�l�r. NULL de�erleri de sayar. 
FROM product.product

----------------
--bad practise
SELECT COUNT(1)  -- product tablosunda 520 sat�r oldu�u i�in 520 tane 1 at�yor ve onlar� say�yor. 1 in indexleme ile alakas� yok...
FROM product.product;

SELECT COUNT('clarusway') -- yukar�daki ile ayn� mant�k 520 tane clarusway yazd�raca�� i�in 520 de�eri verir. 
FROM product.product;

SELECT 1

SELECT product_name,1
FROM product.product;
----------------------

SELECT *
FROM sale.customer

SELECT COUNT(phone) -- Null de�erleri saymaz.
FROM sale.customer

SELECT COUNT(*)  -- Null de�erleri sayar.
FROM sale.customer


-- How many records have a null value in the phone column?

SELECT COUNT(*) -- Null de�erleri i�erdi�i i�in IS NULL i� g�r�r
FROM sale.customer
WHERE phone IS NULL;

SELECT COUNT(phone) ---- Bu sorgu Null de�erleri i�ermedi�i i�in IS NULL 0 sonucunu d�nd�r�r. 
FROM sale.customer
WHERE phone IS NULL;
-------

SELECT COUNT(*) - COUNT(phone)
FROM sale.customer


-- How many customers are located in NY state?

SELECT COUNT(customer_id) AS num_of_customers -- customer_id unique olaca��ndan sayd�rma i�lemini bunun �zerinden yapmak mant�kl�. 
FROM sale.customer
WHERE state = 'NY';

SELECT COUNT(state) -- state tekrar edebilece�i i�in state kullanmak tehlikeli 
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

SELECT TOP 1 list_price  -- ORDER BY ile azalan bir s�ralamada en �stte gelecek olan �cret en y�ksek olacakt�r. 
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

--AVG  -- integer de�er al�rsa integer de�er olarak sonu� d�nd�r�r. integer de�erlerse 22\10 2.2 d�nd�rmez 2 d�nd�r�r. NULL de�erleri de dikkate almaz. 

--What is the avg list price of the 2020 model products?
--float

SELECT AVG(list_price)
FROM product.product
WHERE model_year = 2020;

--Find the average order quantity for product 130.
--integer


SELECT AVG(quantity*1.0) -- integer de�er oldu�u i�in float 1 ile �arparsak float olarak d�nd�r�r. 
FROM sale.order_item
WHERE product_id=130

---------------------------------------------------------------
-- GROUP BY
---------------------------------------------------------------

-- WHERE�i Aggregate fonksiyonundan �nce �al��t�r�r ki �nce s�n�rlay�p, s�n�rlanm�� veriye fonksiyon i�lemi uygulans�n. B�ylece sistemi yormam�� oluyor.
-- GROUP BY da WHERE�den sonra �al��t�r�l�yor. Ayn� nedenden dolay�. 
-- aggregate fonksiyonlarda yan�nda �u s�tunuda g�reyim diyemiyoruz. ancak bunu group by la sa�lar�z.
-- SELECT�teki nonaggregate ifade (column_1), GROUP BY c�mlesinde olmal�!!! Yani neyi GROUP BY��n yan�na yaz�p grupluyor isek aynen onu SELECT yan�na yap��t�r.

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

SELECT brand_id, COUNT(product_id) most_expensive_prod  -- order by selectten sonra �al��t��� i�in alias� order by de kullanabiliriz. 
FROM product.product
WHERE list_price > 1000
GROUP BY brand_id
ORDER BY most_expensive_prod DESC; --ORDER BY COUNT(product_id) DESC

--GROUP BY, aggregate function�� �a��rmadan �nce sonu�lar� grupland�r�r. Bu, t�m sorgu yerine gruplara aggregate func.  uygulaman�za olanak tan�r.
--WHERE c�mlesi, aggregate�ten �nceki veriler �zerinde operasyon yapar (�al���r).
--WHERE c�mlesi, GROUP BY c�mlesinden �nce �al���r. Dolay�s�yla ana tablomuzun sadece WHERE c�mlesindeki �artlar� sa�layan sat�rlar� gruplan�r.
--ORDER BY, GROUP BY�dan sonra gelir. (Sonucu s�ralar.)
--Yani ilk �nce WHERE �art� uygulan�p data filtrelenir,
--sonra �zerine GROUP BY uygulan�r,
--sonra aggregate function uygulan�r.
--Son olarak da sonu� ORDER BY a g�re s�ralan�r.
  
--(�al��ma s�tunlar�n� + ko�ula g�re se� + fonksiyona g�re grupland�r + s�ralamas�n� belirle)


-- SQL'�N KEND� ���NDEK� ��LEM SIRASI:
--FROM : hangi tablolara gitmem gerekiyor?
--WHERE : o tablolardan hangi verileri �ekmem gerekiyor?
--GROUP BY : bu bilgileri ne �ekilde gruplayay�m?
--SELECT : neleri getireyim ve hangi aggragate i�lemine tabi tutay�m.
--HAVING : yukardaki sorgu sonucu ��kan tablo �zerinden nas�l bir filtreleme yapay�m (mesela list_price>1000)
--Gruplama yapt���m�z ayn� sorgu i�inde bir filtreleme yapmak istiyorsak HAVING kullanaca��z
--(HAVING kullanmadan; HAVING'ten yukar�s�n� al�p ba�ka bir SELECT sorgusunda WHERE �art� ile de bu filtrelemeyi yapabiliriz.)
--ORDER BY : ��kan sonucu hangi s�ralama ile getireyim?


--WHERE ile ana tabloda bir filtreleme yap�yoruz. Ana tablo i�inde herhangi bir filtreleme yapmayacaksan WHERE sat�r� kullanmayacaks�n demektir.
--ORDER BY, SELECT'ten sonra �al���yor. Dolay�s�yla SELECT'te yazd���m Allias'� kabul eder!
--SELECT sat�r�nda yazd���n s�tunlar�n hepsi GROUP BY'da olmas� gerekiyor!
--ORDER BY sat�r�ndaki ilk parametre (�rne�in) 2 ise bu SELECT sat�r�ndaki 2. s�tuna g�re s�rala demektir.
--HAVING ile ise query ile d�nen sonu� �zerinde bir filtreleme yap�yoruz.
--HAVING ile sadece aggregate sonucuna bir filtre uyguluyoruz. Dolay�s�yla HAVING, GROUP BY ile birlikte kullan�l�yor.
--HAVING�de kulland���n s�tun, aggregate te kulland���n s�tunla ayn� olmal�.


--COUNT DISTINCT WITH GROUP BY
SELECT brand_id, COUNT(DISTINCT category_id) -- markan�n ka� kategoride �r�n� var. farkl� kategoriler i�in d�st�nct atmal�y�z. 
FROM product.product
GROUP BY brand_id;

SELECT brand_id, category_id
FROM product.product
GROUP BY brand_id, category_id -- marka ve kategori ye g�re gruplay�p her markan�n ka� kategoride �r�n� var onu g�rd�k bunu sayd�rmak i�in 194. sat�rdaki query yaz�lmal�. 

select order_id, product_id--, max(list_price)
from sale.order_item
group by order_id, product_id
order by order_id;

select *
from sale.order_item

-- MIN/MAX

--Find the first and last purchase dates for each customer. (Her m��teri i�in ilk ve son sat�n alma tarihlerini bulun.)

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

---find the total discount amount of each order (her bir sipari�in toplam indirim tutar�n� bulun)

SELECT * FROM sale.order_item

SELECT order_id, 
	SUM(quantity * list_price * discount) total_amount --quantity * list_price * discount indirim tutar�n� elde ederiz.
FROM sale.order_item
GROUP BY order_id

SELECT order_id, list_price*2, -- product 1 �r�n� iki tane oldu�u i�in 2 ile �arpt�k. 
	SUM(quantity * list_price * (1-discount)) total_amount, -- quantity * list_price * (1-discount) �r�ne indirim uyguland�ktan sonra fiyat�. 
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

-- sale.customer tablosunda email i�inde yandex ge�enleri eyaletlerine g�re grupla ve
-- her eyalete d��en yandex i�eren emailleri say bu say�ya g�re azalan �ekilde s�rala ve en fazla olan� getir. 