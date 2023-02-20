-- SQL SESSION-3, 14.01.2023, Data Types & Built-in Functions

-- String Data Types
-- varchar vs. nvarchar (unicode / non-unicode) -- unicode karakterler için nchar-nvarchar kullanılır. non_unicode ise varchar yada char kullanılır. 

SELECT N'قمر'

SELECT CONVERT(VARCHAR, N'قمر')
SELECT CONVERT(NVARCHAR, N'قمر')

SELECT N'😀'


-- char vs. varchar -- char(5) belirledik ancak 3 karakter yazdık yine de char 5 byte harcar. varchar(5) belirledik 3 karakter yazdık 3 byte harcar. 

SELECT DATALENGTH(CONVERT(CHAR(50), 'clarusway')) -- boyutunu verir.
SELECT DATALENGTH(CONVERT(VARCHAR(50), 'clarusway')) -- clarusway 9 karakter olduğu için 9 byte döndürür. 

-- Eğer sınırlama yapmazsanız VARCHAR ın 65000 karakter sınırı var. CHAR kullanırsanız 255 karaktere kadar müsaade eder. VARCHAR'ı daha büyük doküman yazacaksanız tercih edebilirsiniz.
-- Aralarındaki fark şu: Diyelim siz CHAR dediniz ve karakter uzunluğunu 200 olarak belirlediniz. Ondan sonra siz bir satıra ister 5 karakter girin ister 200 karakter girin CHAR her zaman hafızada 200 karakter yer tutar.
-- Ama diyelim ki VARCHAR'a 200 değeri girdiniz. Bir satıra 10 karakter yazdınız. VARCHAR hafızada girdiğiniz karakter kadar yer kaplar. 200 karakter yer kaplamaz.



-------------------------------------------------------------------------
--DATE FUNCTIONS---------------
-------------------------------------------------------------------------

----//////////////////////////////////////////////
---Data Types and getdate() function

SELECT GETDATE() --log kayıtlarının tutulmasında çok kullanılıyor. sistem tarihini döndürür.
-- 2023-01-29 17:02:10.190

CREATE TABLE t_date_time (
	A_time [time],
	A_date [date],
	A_smalldatetime [smalldatetime], -- 1900 yılına kadar girilir. 
	A_datetime [datetime], -- 1753 yılına kadar. 
	A_datetime2 [datetime2],
	A_datetimeoffset [datetimeoffset]
);

SELECT * FROM t_date_time

INSERT t_date_time 
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())


----//////////////////////////////////////////////
---Functions for return date or time parts

SELECT	A_date,
		DATENAME(DW, A_date) [weekday],             
		DATEPART(DW, A_date) [weekday_2],           
		DATENAME(M, A_date) [month],       --nvarchar döndürür.       
		DATEPART(month, A_date) [month_2], -- int döndürür. 
		DAY(A_date) [day],
		MONTH(A_date) [month_3],
		YEAR(A_date) [year],
		A_time,
		DATEPART (minute, A_time) [minute],
		DATEPART (NANOSECOND, A_time) [nanosecond]
FROM	t_date_time;

/*  YEAR / YYYY / YY
	QUARTER / QQ / Q 
	MONTH / MM / M
	DAYOFYEAR / DY / Y
	WEEK / WW / WK
	WEEKDAY / DW
	DAY / DD / D
	HOUR / HH
	MINUTE / MI / N
	SECOND / SS / S
	MILLISECOND / MS
	MICROSECOND / MCS
	NANOSECOND / NS  */


----//////////////////////////////////////////////
---Functions for return date or time differences

SELECT A_date,        
        A_datetime,
        GETDATE() AS [CurrentTime],
        DATEDIFF (DAY, '2020-11-30', A_date) Diff_day,
        DATEDIFF (MONTH, '2020-11-30', A_date) Diff_month,
        DATEDIFF (YEAR, '2020-11-30', A_date) Diff_year,
        DATEDIFF (HOUR, A_datetime, GETDATE()) Diff_Hour,
        DATEDIFF (MINUTE, A_datetime, GETDATE()) Diff_Min
FROM   t_date_time;


SELECT * FROM sale.orders

select	order_date, shipped_date,
		DATEDIFF(DAY, order_date, shipped_date) day_diff, 
		DATEDIFF(DAY, shipped_date, order_date) day_diff
from	sale.orders
where	order_id = 1;


----//////////////////////////////////////////////
---Functions for Modify date and time

SELECT	order_date,
		DATEADD(YEAR, 5, order_date), 
		DATEADD(DAY, 5, order_date),
		DATEADD(DAY, -5, order_date)		
FROM	sale.orders
where	order_id = 1

SELECT GETDATE(), DATEADD(HOUR, 5, GETDATE())

SELECT	order_date, EOMONTH(order_date) end_of_month, -- eomonth belirtilen tarihin sonuna gider.
		EOMONTH(order_date, 2) eomonth_next_two_months -- 2 ay sonrasının ay sonuna gider.
FROM	sale.orders
where	order_id = 1;


----//////////////////////////////////////////////
---Function for Validate date and time

SELECT ISDATE('123')  -- date mi değil mi?

SELECT ISDATE('20230114') --SQL server veri tipini kendisi çevirir. tarih formatına çevirebilirim derse SQL server onu tarih formatında okuyor. 

--SELECT 1 + '1' -- SQL server dolaylı çevirme yöntemi ile '1' string olarak değilde yorumlayarak int olarak alıyor. ve toplama işlemini yapıyor. 

SELECT ISDATE('2021-12-02')  --2021/12/02  ||| 2021.12.02  |||  20211202

SELECT ISDATE('02/12/2022')  --02-12-2022  |||  02.12.2022

SELECT ISDATE('02122022') --ERROR


----//////////////////////////////////////////////
---QUERY TIME

--Write a query returns orders that are shipped more than two days after the order date. 
--2 günden geç kargolanan siparişlerin bilgilerini getiriniz.

SELECT order_date, shipped_date, DATEDIFF(DAY, order_date, shipped_date) date_diff
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2
ORDER BY date_diff DESC

-------------------------------------------------------------------------
--STRING FUNCTIONS---------------
-------------------------------------------------------------------------

-----LEN

SELECT LEN('welcome') -- baştaki boşluğu sayar. sonraki boşluğu saymaz. 

SELECT LEN(' welcome')

SELECT LEN(' welcome ')

SELECT LEN(123456789)


--If there is a quote in the string

SELECT 'Jack''s Phone' -- escape karakteri


-----CHARINDEX
-- CHARINDEX()işlev, bağımsız değişken olarak bir dize ve bunun bir alt dizesini alır 
-- ve alt dizenin ilk karakteri olan alt dizenin konumunu gösteren bir tamsayı döndürür. 
-- CHARINDEX()işlev, alt dizenin ilk oluşumunu bulur ve tamsayı türünde bir değer döndürür.
-- CHARINDEX()işlevi büyük/küçük harfe duyarlı olarak çalışır. 
SELECT CHARINDEX('C', 'CHARACTER') -- karakter ararız. 

SELECT CHARINDEX('C', 'CHARACTER', 2)

SELECT CHARINDEX('CT', 'CHARACTER') 

SELECT CHARINDEX('ct', 'CHARACTER')


--PATINDEX()

-- PATINDEX(), belirtilen bir ifadede bir kalıbın ilk oluşumunun başlangıç ​​konumunu 
-- veya kalıp bulunamazsa tüm geçerli metin ve karakter veri türlerinde sıfırları döndürür.
-- Desen veya ifadeden biri ise NULL, PATINDEX()NULL döndürür.
-- PATINDEX() Başlangıç ​​pozisyonu 1'dir.
-- PATINDEX aynı LIKE şekilde çalışır , böylece herhangi bir joker karakter kullanabilirsiniz. 
-- Deseni  % (yüzde) ler arasına almak zorunda değilsiniz. 
-- PATINDEX(), LIKE'dan farklı olarak, CHARINDEX()'in yaptığına benzer bir konum döndürür.

SELECT PATINDEX ('%R','CHARACTER');  -- Sondaki R den onceki karakterleri al

SELECT PATINDEX ('R%','CHARACTER');   -- R den sonraki karakterleri getir

SELECT PATINDEX ('___R%','CHARACTER');  
SELECT PATINDEX('%R', 'CHARACTER') -- pattern ararız.

SELECT PATINDEX('R%', 'CHARACTER')

SELECT PATINDEX('%[RC]%', 'CHARACTER') -- [RC] sadece R veya C harfi olsun. başı sonu farklı olabilir. C harfi ilk sırada olduğu için 1 döndürür. 

SELECT PATINDEX('_H%' , 'CHARACTER')


--LEFT

SELECT LEFT('CHARACTER', 5) -- 5. karakteri döndürür. 

SELECT LEFT(' CHARACTER', 5)


--RIGHT

SELECT RIGHT('CHARACTER', 5)

SELECT RIGHT('CHARACTER ', 5)
SELECT RIGHT(12345, 5)


--SUBSTRING

SELECT SUBSTRING('CHARACTER', 3, 5)

SELECT SUBSTRING('CHARACTER', 0, 5) -- SQL server indeks pythondan farklı... 0 dediği için 4 karakter aldı. 

SELECT SUBSTRING('CHARACTER', -1, 5)

SELECT SUBSTRING(88888888, 3, 3) --error  numaeric değerlerle kullanılmaz. 


--LOWER

SELECT LOWER('CHARACTER')


--UPPER

SELECT UPPER('character')


--How to grow the first character of the 'character' word.
SELECT UPPER(LEFT('character',1))
SELECT LOWER(RIGHT('character', LEN('character')-1))

SELECT UPPER(LEFT('character',1)) + LOWER(RIGHT('character', LEN('character')-1))


------------------------------------------
---TRIM, LTRIM, RTRIM

SELECT TRIM('  CHARACTER   ')

SELECT TRIM('  CHARA CTER   ')

SELECT TRIM('?, ' FROM '    ?SQL Server,    ') AS TrimmedString;  -- karakterleri (boşluk dahil) belirt '?, ' şeklinde belirttik ve onları aldı. 

SELECT LTRIM('  CHARACTER   ')

SELECT RTRIM('  CHARACTER   ')
-- Trim yapmak istediğimiz birden fazla karakter var ise bunları aşağıdaki gibi belirtebiliriz.
-- Girdiğimiz ifadenin içindeki herhangi bir karakterle karşılaştığında bu karakter silinecektir. Ta ki bu karakterler dışında başka bir karakterle kaşılaşana kadar.
SELECT TRIM('ABC' FROM 'CCCCBBBAAAFRHGKDFKSLDFJKSDFACBBCACABACABCA')

---REPLACE

SELECT REPLACE('CHARACTER STRING', ' ', '/')

SELECT REPLACE(123456, 2, 0)


---CONCAT

SELECT first_name + ' ' + last_name
FROM sale.customer

SELECT CONCAT(first_name,' ',last_name)
FROM sale.customer


-------------------------------------------------------------------------
--OTHER FUNCTIONS---------------
-------------------------------------------------------------------------

---CAST

SELECT 1 + '1' --SQL server '1' i int olarak algılayıp int dönüştürüyor.
SELECT 1 + 'GG' --SQL server 'GG' yi integere çeviremediğinden hata veriyor.

SELECT CAST(12345 AS CHAR)

SELECT CAST(123.95 AS INT)

SELECT CAST(123.95 AS DEC(3,0)) --DECIMAL(3,0) -- sadece 3 karakter olsun ve kesirli birşey istemiyorum.


---CONVERT

SELECT CONVERT(int, 30.60)

SELECT CONVERT(VARCHAR(10), '2020-10-10')
SELECT CONVERT(DATETIME, '2020-10-10')

SELECT CAST(12 AS DECIMAL(5,2) ) AS decimal_value;
-- integer bir veriyi 5 rakamdan oluşan ve bunun virgülden sonrası 2 rakam olan decimal'e çevirdi.

---SQL Server Datetime Formatting
---Converting a Datetime to a Varchar

SELECT CONVERT(VARCHAR, GETDATE(), 7) 
SELECT CONVERT(NVARCHAR, GETDATE(), 100) --0 / 100
SELECT CONVERT(NVARCHAR, GETDATE(), 112)
SELECT CONVERT(NVARCHAR, GETDATE(), 113) --13 / 113

SELECT CAST('20201010' AS DATE)
SELECT CONVERT(NVARCHAR, CAST('20201010' AS DATE), 103) 


---Converting a Varchar to a Datetime

SELECT convert(DATE, '25 Oct 21', 6)
----
select convert(varchar, getdate(), 6)

https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/ 


---ROUND
-- Üçüncü parametre sonucun aşağıya mı yukarıya mı yuvarlanacağını belirlemek için kullanılmaktadır.
-- Default olarak 0 (yani yukarıya yuvarlama) atanmıştır. Aşağı değere yuvarlamak için 1 yazılmalıdır.
SELECT ROUND (432.368, 2, 0)
SELECT ROUND (432.368, 2, 1)
SELECT ROUND (432.368, 2)

SELECT ROUND(123.4567, 2) -- veri tipine göre dönüşüm yapar. yuvarlar ancak sondaki iki ondalıklı kısmı kaybetmiyor.

SELECT ROUND(123.4567, 2, 0) -- defaultu sıfır. 

SELECT ROUND(123.4567, 2, 1) -- 0 haricinde bir sayı yuvarlama yapmadan son ikisini sıfırlar. 

SELECT CONVERT(INT, 123.9999)
SELECT CONVERT(DECIMAL(18,2), 123.4567)

DECLARE @value float(10)
SET @value = .1234567890
SELECT ROUND(@value, 1)  -- 0.1
SELECT ROUND(@value, 2)  -- 0.12
SELECT ROUND(@value, 3)  -- 0.123
SELECT ROUND(@value, 4)  -- 0.1235
SELECT ROUND(@value, 5)  -- 0.12346
SELECT ROUND(@value, 6)  -- 0.123457
SELECT ROUND(@value, 7)  -- 0.1234568
SELECT ROUND(@value, 8)  -- 0.12345679
SELECT ROUND(@value, 9)  -- 0.123456791
SELECT ROUND(@value, 10) -- 0.123456791

---ISNUMERIC
---The ISNUMERIC() function checks whether a value can be converted
---to a numeric data type
-- Bir ifadenin geçerli bir sayısal tür olup olmadığını belirler.

-- Girdi ifadesi geçerli bir sayısal veri türü olarak değerlendirildiğinde 1 döndürür ; 
--aksi halde 0 döndürür . Geçerli sayısal veri türleri şunlardır: bigint, int, smallint, tinyint, bit, decimal, numeric, 
-- float, real, money, smallmoney .


SELECT ISNUMERIC(11111)
SELECT ISNUMERIC('11111')
SELECT ISNUMERIC('clarusway')


---COALESCE
---EĞER İLK İFADE NULL İSE BİR SONRAKİ DEĞERİ GETİRİR, O DA NULL İSE BİR SONRAKİNİ

SELECT COALESCE(NULL, 'Hi', 'Hello', NULL) result;

SELECT COALESCE(NULL, NULL ,'Hi', 'Hello', NULL) result;

SELECT COALESCE(NULL, NULL ,'Hi', 'Hello', 100, NULL) result;
---This function doesn't limit the number of arguments, but they must all be of the same data type.

SELECT COALESCE(NULL, NULL) result;

-- Argümanları sırayla değerlendirir ve başlangıçta NULL olarak değerlendirilmeyen ilk ifadenin geçerli değerini döndürür.
​
SELECT COALESCE (NULL, NULL ,'Hi', 'Hello', NULL) result;  -- Ilk non null degeri getirir

---ISNULL()
---replaces NULL with a specified value
-- ISNULL(check expression, replacement value)​: Belirtilen DEGERI,  NULLdeğeriyle değiştirir.

-- Boş değerleri belirli bir değerle doldurmak istiyorsanız ISNULL()işlevi kullanabilirsiniz.

SELECT ISNULL(NULL, 'Not null yet.') AS col;

SELECT ISNULL(1, 2) AS col;  -- Tablo değerleri üzerinde çalışıyorsanız, yukarıdaki sorguda "1" ve "2" yerine sütun adları yazabilirsiniz.

SELECT ISNULL(NULL, 1)

SELECT ISNULL(phone, 'no phone')
FROM sale.customer

---difference between coalesce and isnull

SELECT ISNULL(phone, 0)
FROM sale.customer

SELECT COALESCE(phone, 0) --ERROR string bir sütun olduğu için error verdi. 
FROM sale.customer


---NULLIF
---returns NULL if two arguments are equal. Otherwise, it returns the first expression.

SELECT NULLIF(10,10)

SELECT NULLIF('Hello', 'Hi') result;

SELECT NULLIF(2, '2')


-------------------------------------------------------------------------
--QUERY TIME FOR YOU---------------
-------------------------------------------------------------------------

-- How many customers have yahoo mail?
-- (yahoo mailine sahip kaç müşteri vardır?)

SELECT count(customer_id)
FROM sale.customer
WHERE PATINDEX('%yahoo%', email) > 0;


-------------------------------------------------------
---Write a query that returns the name of the streets, where the third character of the streets is numeric.
---(street sütununda soldan üçüncü karakterin rakam olduğu kayıtları getiriniz)

SELECT street, LEFT(street, 3)
FROM sale.customer
WHERE ISNUMERIC(LEFT(street, 3)) = 1; -- ilk üçü rakam ise döndür. 
--------------------------------------------------------
SELECT street, SUBSTRING(street, 3, 1) third_char
FROM sale.customer
WHERE ISNUMERIC(SUBSTRING(street, 3, 1)) = 1; -- soldan üçüncü rakamı döndür. 
-------------------------------------------------------
SELECT street, SUBSTRING(street, 3, 1) third_char
FROM sale.customer
WHERE street like '__[0-9]%'
-------------------------------------------------------
--Add a new column to the customers table that contains the customers' contact information. 
--If the phone is not null, the phone information will be printed, if not, the email information will be printed.

SELECT customer_id, first_name, last_name, ISNULL(phone, email) as contact_info, COALESCE(phone, email, street+city+state) --COALESCE phone null ise email her ikiside null ise street+city+state gir)
FROM sale.customer


--her müşteriye ulaşabileceğim telefon veya email bilgisini istiyorum.
--Müşterinin telefon bilgisi varsa email bilgisine gerek yok.
--telefon bilgisi yoksa email adresi iletişim bilgisi olarak gelsin.
--beklenen sütunlar: customer_id, first_name, last_name, contact





-------------------------------------------------------
--Split the mail addresses into two parts from ‘@’, and place them in separate columns.

--@ işareti ile mail sütununu ikiye ayırın. Örneğin
--ronna.butler@gmail.com	/ ronna.butler	/ gmail.com



SELECT LEFT(email, CHARINDEX('@', email) - 1) AS username,
       RIGHT(email, LEN(email) - CHARINDEX('@', email)) AS domain
FROM sale.customer;
-------------------------------
SELECT email, 
       SUBSTRING(email,1,(CHARINDEX('@', email)-1)) as email_name,
       SUBSTRING(email,(CHARINDEX('@', email)+1), (LEN(email) - (CHARINDEX('@', email)))) as email_provider 
FROM sale.customer;