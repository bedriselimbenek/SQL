USE SampleRetail

CREATE TABLE t_date_time (
A_time [time],
A_date [date],
A_smalldatetime [smalldatetime],
A_datetime [datetime],
A_datetime2 [datetime2],
A_datetimeoffset [datetimeoffset]
);

SELECT * FROM t_date_time

INSERT t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

SELECT        A_date,
	DATENAME(DW, A_date) [weekday],            
	DATEPART(DW, A_date) [weekday_2],          
	DATENAME(M, A_date) [month],             
	DATEPART(month, A_date) [month_2],
	DAY (A_date) [day],
	MONTH(A_date) [month_3],
	YEAR (A_date) [year], A_time,
	DATEPART (minute, A_time) [minute],
	DATEPART (NANOSECOND, A_time) [nanosecond]
FROM t_date_time;

/* YEAR / YYYY / YY
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
NANOSECOND / NS */

SELECT A_date,       
       A_datetime,											-- þuanki zaman ile belirttiðimiz tarih arasýndaki isteðe baðlý zaman dilimini getirir. ay gün saat dakika
       GETDATE() AS [CurrentTime],
       DATEDIFF (DAY, '1985-07-28', A_date) Diff_day,
       DATEDIFF (MONTH, '1985-07-28', A_date) Diff_month,
       DATEDIFF (YEAR, '1985-07-28', A_date) Diff_year,
       DATEDIFF (HOUR, A_datetime, GETDATE()) Diff_Hour,
       DATEDIFF (MINUTE, A_datetime, GETDATE()) Diff_Min
FROM  t_date_time;

select      order_date, shipped_date,
			DATEDIFF(DAY, order_date, shipped_date) day_diff,
			DATEDIFF(DAY, shipped_date, order_date) day_diff
from        sale.orders
where       order_id = 1;

SELECT	order_date,
		DATEADD(YEAR, 5, order_date) next_year,
		DATEADD(DAY, 5, order_date) next_day,
		DATEADD(DAY, -5, order_date) previous_day		
FROM	sale.orders
where	order_id = 1

SELECT GETDATE(), DATEADD(HOUR, 5, GETDATE())

SELECT	order_date, EOMONTH(order_date) end_of_month,  --- verdiðin tarihin içine parametre alýr o tarihin sonuna gider.
		EOMONTH(order_date, 2) eomonth_next_two_months
FROM	sale.orders
where	order_id = 1;

SELECT ISDATE('123')
SELECT ISDATE('20230114')

SELECT ISDATE('2021-12-02') --2021/12/02 ||| 2021.12.02 ||| 20211202
 
SELECT ISDATE('02/12/2022') --02-12-2022 ||| 02.12.2022

SELECT ISDATE('02122022')

SELECT *
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2;


-----CHARINDEX
 
SELECT CHARINDEX('C', 'CHARACTER')
 
SELECT CHARINDEX('C', 'CHARACTER', 2)
 
SELECT CHARINDEX('CT', 'CHARACTER')
 
SELECT CHARINDEX('ct', 'CHARACTER')

--PATINDEX()
 
SELECT PATINDEX('%R', 'CHARACTER')

 
SELECT PATINDEX('R%', 'CHARACTER')
 
SELECT PATINDEX('%[RC]%', 'CHARACTER')
 
SELECT PATINDEX('_H%' , 'CHARACTER')

SELECT LEFT ('HASAN',2)


SELECT RIGHT ('HASAN',2)
--LEFT / RIGHT

SELECT LEFT('CHARACTER', 5)     --CHARA soldan baþlýyor 5 tane getiriyor
SELECT LEFT('CH ARACTER', 5)    --CH AR boþluðu sayar
SELECT RIGHT('CHARACTER', 5)    --ACTER soldan baþlýyor 5 tane getiriyor
SELECT RIGHT('CH ARACTER ', 5)  --CTER  boþluðu sayar


SELECT TRIM('?, ' FROM '   ?SQL Server,') AS TrimmedString;


SELECT REPLACE('CHARACTER STRING', ' ', '/')

SELECT CONVERT(VARCHAR, GETDATE(), 7)
SELECT CONVERT(NVARCHAR, GETDATE(), 100) --0 / 100
SELECT CONVERT(NVARCHAR, GETDATE(), 112)
SELECT CONVERT(NVARCHAR, GETDATE(), 113) --13 / 113
SELECT CAST('20201010' AS DATE)
SELECT CONVERT(NVARCHAR, CAST('20201010' AS DATE), 103)


SELECT CONVERT(varchar, '2017-08-25', 101);
SELECT CAST('2017-08-25' AS varchar);
-- date formatýndaki bir veriyi char'a çevirdi.
SELECT CONVERT(datetime, '2017-08-25');
SELECT CAST('2017-08-25' AS datetime);
-- char formatýndaki bir veriyi datetime'a çevirdi.
SELECT CONVERT(int, 25.65);
SELECT CAST(25.65 AS int);
-- decimal bir veriyi, integer'a (tam sayýya) çevirdi.
SELECT CONVERT(DECIMAL(5,2), 12) AS decimal_value;
SELECT CAST(12 AS DECIMAL(5,2) ) AS decimal_value;
-- integer bir veriyi 5 rakamdan oluþan ve bunun virgülden sonrasý 2 rakam olan decimal'e çevirdi.
SELECT CONVERT(DECIMAL(7,2), ' 5800.79 ') AS decimal_value;
SELECT CAST(' 5800.79 ' AS DECIMAL (7,2)) AS decimal_value;
-- char (string) olan ama rakamdan oluþan veriyi decimal'e çevirdi. (edited) 

SELECT *
FROM sale.customer