USE SampleRetail
/* 
1- Product Sales 
You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not. 
 
a. 'Polk Audio - 50 W Woofer - Black' -- (other_product) 
To generate this report, you are required to use the appropriate SQL Server Built-in functions or expressions as well as basic SQL knowledge. 
 
*/ 
 
WITH T1 AS 
( 
SELECT	DISTINCT PP.product_name, SC.customer_id, SC.first_name, SC.last_name 
FROM	product.product PP, sale.order_item oi, sale.orders SO, sale.customer SC 
WHERE	PP.product_id = oi.product_id
AND		oi.order_id = SO.order_id
AND		SO.customer_id = SC.customer_id
AND		PP.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
), T2 AS 
( 
SELECT	DISTINCT PP.product_name, SC.customer_id, SC.first_name, SC.last_name
FROM	product.product PP, sale.order_item oi, sale.orders SO, sale.customer SC
WHERE	PP.product_id = oi.product_id
AND		oi.order_id = SO.order_id
AND		SO.customer_id = SC.customer_id
AND		PP.product_name = 'Polk Audio - 50 W Woofer - Black'
) 
SELECT	T1.customer_id, T1.first_name, T1.last_name, 
		ISNULL (NULLIF (ISNULL(T2.first_name, 'No'), T2.first_name) , 'Yes') as Other_Product
FROM	T1 
		LEFT JOIN  
		T2 
		ON	T1.customer_id = T2.customer_id;
		 
/*  
2- Conversion Rate 
Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements given by an E-Commerce company. Write a query to return the conversion rate for each Advertisement type. 
 
a.    Create above table (Actions) and insert values, 
 
b.    Retrieve count of total Actions and Orders for each Advertisement Type, 
 
c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.
 
*/ 

/*
CREATE TABLE ECommerce (Visitor_ID INT IDENTITY (1, 1) PRIMARY KEY,	Adv_Type VARCHAR (255) NOT NULL, Action1 VARCHAR (255) NOT NULL);
INSERT INTO ECommerce (Adv_Type, Action1)VALUES ('A', 'Left'),('A', 'Order'),('B', 'Left'),('A', 'Order'),('A', 'Review'),('A', 'Left'),('B', 'Left'),('B', 'Order'),('B', 'Review'),('A', 'Review');
*/

SELECT * INTO #TABLE1 
FROM 
( VALUES 		 	
				(1,'A', 'Left'), 
				(2,'A', 'Order'), 
				(3,'B', 'Left'), 
				(4,'A', 'Order'), 
				(5,'A', 'Review'), 
				(6,'A', 'Left'), 
				(7,'B', 'Left'), 
				(8,'B', 'Order'), 
				(9,'B', 'Review'), 
				(10,'A', 'Review') 
			) A (visitor_id, adv_type, actions);
WITH T1 AS 
( 
SELECT	adv_type, COUNT (*) cnt_action 
FROM	#TABLE1 
GROUP BY 
		adv_type  
), T2 AS
( 
SELECT	adv_type, COUNT (actions) cnt_order_actions 
FROM	#TABLE1 
WHERE	actions = 'Order' 
GROUP BY 
		adv_type 
) 
SELECT	T1.adv_type, CAST (ROUND (1.0*T2.cnt_order_actions / T1.cnt_action, 2) AS numeric (3,2)) AS Conversion_Rate 
FROM	T1, T2 
WHERE	T1.adv_type = T2.adv_type; 