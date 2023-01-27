-- SQL SESSION-1, 11.01.2023, SQL BASIC COMMANDS

-- SELECT 
-- seçim yapýp veriyi getirmek için kullanýlýr. Python print analog
SELECT 1

SELECT 'Martin' -- SQL çift týrnak kabul etmez. 

SELECT 1, 'Martin' -- Sadece çalýþtýracaðýn query seç ve execute yada F5 

SELECT 'Martin' AS first_name -- AS keyword çekilen sonuca alias verilir. result tablosunda sütun ismi verilir. 
--1. AS keyword opsiyonel kullanýlmasa da alias verir. ama yazmakta fayda var. 
--2. iki kelime varsa boþluk býrakacaksak 19. satýrda ki [] kullanýlýr. 
--3. komutlar alias olarak kullanýlacaksa [] içine alýnýr. 
SELECT 1 AS ID, 'Martin' AS FirstName

SELECT 1 AS 'ID', 'Martin' AS 'FirstName'

SELECT 1 AS 'ID', 'Martin' AS [First Name]

-- FROM 
--Tablolardan veri çekmek istediðimizde FROM kullanarak yapýyoruz.

SELECT *
FROM sale.customer -- program penceresinin en sað altta tablonun kaç satýrdan oluþtuðunu görebiliriz. 
--açýlan penceredeki bilgiler result set olarak adlandýrýlýr. 

SELECT first_name -- istediðimiz sütunu çekebiliriz.
FROM sale.customer

SELECT first_name,last_name 
FROM sale.customer

SELECT email,first_name,last_name -- istediðiniz sütunu önce çaðýrabilirsiniz. 
FROM sale.customer

-- WHERE
-- filtreleme yapmak için kullanýyoruz.
-- filtreleme yapmak için kullandýðýmýz sütunu Select ile çaðýrmak zorunda deðiliz. 

-- WHERE ile ana tabloda bir filtreleme yaparsýnýz. Sonra filtrelenen tablonuzdan istediðiniz veriyi SELECT ile getirirsiniz

SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE city='Atlanta';
-- 
--NOT 
SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE NOT city='Atlanta'; -- Atlanta da yaþamayanlarý 

SELECT first_name,last_name,street,state
FROM sale.customer
WHERE city='Atlanta';

-- AND / OR
-- Birden fazla þart koþabilmek için kullanýyoruz. 

SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE state='TX' AND city='Allen';

SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE state='TX' OR city='Allen';

SELECT first_name,last_name,street,city,state
FROM sale.customer
WHERE last_name='Chan' AND state='TX' OR state='NY'; -- soyismi Chan ve eyaleti Texas veya NY olanlarý istedik. ama AND operatörünün önceliði olduðundan onun anladýðý soyismi Chan ve Eyaleti Texas olan veya eyaleti NY olanlarý getirir. bunu önlemek için 70. satýrdaki parantez içine alma iþlemini gerçekleþtirdik.  

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
WHERE email LIKE '%yahoo%'; -- baþýnda yada sonunda belirsiz sayýda karakter olabilir. Ama mutlaka yahoo içinde bulunsun.

SELECT *
FROM sale.customer
WHERE email LIKE 'yahoo%';

SELECT *
FROM sale.customer
WHERE first_name LIKE 'Di_ne';

SELECT *
FROM sale.customer
WHERE first_name LIKE '[TZ]%'; -- [] Regex T yada Z ile baþlasýn gerisi önemli deðil

SELECT *
FROM sale.customer
WHERE first_name LIKE '[T-Z]%'; -- T ve Z arasýndaki harfler ile baþlayan sonrasý önemli deðil

-- BETWEEN

--verilen sayýlar dahildir. 

SELECT *
FROM product.product
WHERE list_price BETWEEN 599 AND 999; -- ürün fiyatý 599 ile 999 arasýndaki ürünler 599 ve 999 dahildir. 

SELECT *
FROM sale.orders
WHERE order_date 
	BETWEEN '2018-01-05' 
		AND '2018-01-08'

-- <, >, <=, >=, =, != <> -- sonuncu != ile ayný

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
ORDER BY 1,2; -- sütun isimleri yerine sayý verilir. SELECT te belirttiðiniz sütun sýrasýna göre 1 --> first_name, 2--> last_name


SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY customer_id DESC; -- customer_id SELECT te kullanmak zorunda deðiliz. 

-- DISTINCT

SELECT DISTINCT state -- müþterilerim toplam kaç eyalete daðýlmýþ?
FROM sale.customer

SELECT DISTINCT state, city -- state tekrarlayabilir ama city de tekrarlama olmayacak. otomatik alfabetik olarak sýralar. 
FROM sale.customer
--ORDER BY state DESC;

SELECT DISTINCT *  -- duplicate rows tekrarlayan satýrlarý döndürür. (customer_id unique olduðu için bütün satýrlarý döndürür. ) 1999 satýr dönseydi 1 satýrýn duplicate olduðunu anlayacaktýk. 
FROM sale.customer

-----------------------------------------------

-- çok fazla sütun var yýldýz kullanmak istemiyoruz. customer tablosunu týkla sürükle SELECT yanýna býrak. 
SELECT DISTINCT [first_name], [last_name], [phone], [email], [street], [city], [state], [zip_code]
FROM sale.customer
