-- SQL SESSION-1, 11.01.2023, SQL BASIC COMMANDS

-- SELECT 
-- se�im yap�p veriyi getirmek i�in kullan�l�r. Python print analog
SELECT 1

SELECT 'Martin' -- SQL �ift t�rnak kabul etmez. 

SELECT 1, 'Martin' -- Sadece �al��t�raca��n query se� ve execute yada F5 

SELECT 'Martin' AS first_name -- AS keyword �ekilen sonuca alias verilir. result tablosunda s�tun ismi verilir. 
--1. AS keyword opsiyonel kullan�lmasa da alias verir. ama yazmakta fayda var. 
--2. iki kelime varsa bo�luk b�rakacaksak 19. sat�rda ki [] kullan�l�r. 
--3. komutlar alias olarak kullan�lacaksa [] i�ine al�n�r. 
SELECT 1 AS ID, 'Martin' AS FirstName

SELECT 1 AS 'ID', 'Martin' AS 'FirstName'

SELECT 1 AS 'ID', 'Martin' AS [First Name]

-- FROM 
--Tablolardan veri �ekmek istedi�imizde FROM kullanarak yap�yoruz.

SELECT *
FROM sale.customer -- program penceresinin en sa� altta tablonun ka� sat�rdan olu�tu�unu g�rebiliriz. 
--a��lan penceredeki bilgiler result set olarak adland�r�l�r. 

SELECT first_name -- istedi�imiz s�tunu �ekebiliriz.
FROM sale.customer

SELECT first_name,last_name 
FROM sale.customer

SELECT email,first_name,last_name -- istedi�iniz s�tunu �nce �a��rabilirsiniz. 
FROM sale.customer

-- WHERE
-- filtreleme yapmak i�in kullan�yoruz.
-- filtreleme yapmak i�in kulland���m�z s�tunu Select ile �a��rmak zorunda de�iliz. 

-- WHERE ile ana tabloda bir filtreleme yapars�n�z. Sonra filtrelenen tablonuzdan istedi�iniz veriyi SELECT ile getirirsiniz

SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE city='Atlanta';
-- 
--NOT 
SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE NOT city='Atlanta'; -- Atlanta da ya�amayanlar� 

SELECT first_name,last_name,street,state
FROM sale.customer
WHERE city='Atlanta';

-- AND / OR
-- Birden fazla �art ko�abilmek i�in kullan�yoruz. 

SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE state='TX' AND city='Allen';

SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE state='TX' OR city='Allen';

SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE last_name='Chan' AND state='TX' OR state='NY'; -- soyismi Chan ve eyaleti Texas veya NY olanlar� istedik. ama AND operat�r�n�n �nceli�i oldu�undan onun anlad��� soyismi Chan ve Eyaleti Texas olan veya eyaleti NY olanlar� getirir. bunu �nlemek i�in 70. sat�rdaki parantez i�ine alma i�lemini ger�ekle�tirdik.  

SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE last_name='Chan' AND (state='TX' OR state='NY');

-- IN / NOT IN

SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE state='TX' AND city IN ('Allen','Austin');

-- LIKE
-- '_' any single character
-- '%' unknown character numbers

SELECT *
FROM sale.customer
WHERE email LIKE '%yahoo%'; -- ba��nda yada sonunda belirsiz say�da karakter olabilir. Ama mutlaka yahoo i�inde bulunsun.

SELECT *
FROM sale.customer
WHERE email LIKE 'yahoo%';

SELECT *
FROM sale.customer
WHERE first_name LIKE 'Di_ne';

SELECT *
FROM sale.customer
WHERE first_name LIKE '[TZ]%'; -- [] Regex T yada Z ile ba�las�n gerisi �nemli de�il

SELECT *
FROM sale.customer
WHERE first_name LIKE '[T-Z]%'; -- T ve Z aras�ndaki harfler ile ba�layan sonras� �nemli de�il

-- BETWEEN

--verilen say�lar dahildir. 

SELECT *
FROM product.product
WHERE list_price BETWEEN 599 AND 999; -- �r�n fiyat� 599 ile 999 aras�ndaki �r�nler 599 ve 999 dahildir. 

SELECT *
FROM sale.orders
WHERE order_date 
	BETWEEN '2018-01-05' 
		AND '2018-01-08'

-- <, >, <=, >=, =, != <> -- sonuncu != ile ayn�

SELECT *
FROM product.product
WHERE list_price < 1000;

-- IS NULL / IS NOT NULL

SELECT *
FROM sale.customer
WHERE phone IS NULL;

SELECT *
FROM sale.customer
WHERE phone IS NOT NULL;

-- TOP N

SELECT TOP 10 *
FROM sale.orders

SELECT TOP 10 customer_id
FROM sale.customer

-- ORDER BY 

-- default ASC

SELECT TOP 10 *
FROM sale.orders
ORDER BY order_id DESC;

SELECT TOP 10 *
FROM sale.orders
ORDER BY order_id ASC;

SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY first_name ASC, last_name DESC;

SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY 1,2; -- s�tun isimleri yerine say� verilir. SELECT te belirtti�iniz s�tun s�ras�na g�re 1 --> first_name, 2--> last_name


SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY customer_id DESC; -- customer_id SELECT te kullanmak zorunda de�iliz. 

-- DISTINCT

SELECT DISTINCT state -- m��terilerim toplam ka� eyalete da��lm��?
FROM sale.customer

SELECT DISTINCT state, city -- state tekrarlayabilir ama city de tekrarlama olmayacak. otomatik alfabetik olarak s�ralar. 
FROM sale.customer
--ORDER BY state DESC;

SELECT DISTINCT *  -- duplicate rows tekrarlayan sat�rlar� d�nd�r�r. (customer_id unique oldu�u i�in b�t�n sat�rlar� d�nd�r�r. ) 1999 sat�r d�nseydi 1 sat�r�n duplicate oldu�unu anlayacakt�k. 
FROM sale.customer

-----------------------------------------------

-- �ok fazla s�tun var y�ld�z kullanmak istemiyoruz. customer tablosunu t�kla s�r�kle SELECT yan�na b�rak. 
SELECT DISTINCT [first_name], [last_name], [phone], [email], [street], [city], [state], [zip_code]
FROM sale.customer
