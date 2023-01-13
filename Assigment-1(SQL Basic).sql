USE SampleRetail

-- Questions:

-- 1. How many customers are in each city? Your solution should include the city name and the number of customers sorted from highest to lowest.

SELECT city, COUNT(*) as num_customers 
FROM sale.customer
GROUP BY city
ORDER BY num_customers DESC;

-- 2. Find the total product quantity of the orders. Your solution should include order ids and quantity of products.

SELECT order_id, SUM(quantity) tot_quant
FROM sale.order_item
GROUP BY order_id;

-- 3. Find the first order date for each customer_id.

SELECT customer_id, MIN(order_date) first_order_date
FROM sale.orders
GROUP BY customer_id


-- 4. Find the total amount of each order. Your solution should include order id and total amount sorted from highest to lowest.

SELECT order_id, SUM(list_price * quantity - discount) total_amount
FROM sale.order_item
GROUP BY order_id
ORDER BY total_amount DESC;

-- 5. Find the order id that has the maximum average product price. Your solution should include only one row with the order id and average product price

SELECT TOP 1 order_id, AVG(list_price) AS avg_pro_price
FROM sale.order_item
GROUP BY order_id
ORDER BY avg_pro_price DESC;


-- 6. Write a query that displays brand_id, product_id and list_price sorted first by brand_id (in ascending order), and then by list_price (in descending order).

SELECT brand_id, product_id, list_price
FROM product.product
ORDER BY brand_id ASC, list_price DESC;

-- 7. Write a query that displays brand_id, product_id and list_price, but this time sorted first by list_price (in descending order), and then by brand_id (in ascending order).

SELECT brand_id, product_id, list_price
FROM product.product
ORDER BY list_price DESC, brand_id ASC;

-- 8. Compare the results of these two queries above. How are the results different when you switch the column you sort on first? (Explain it in your own words.)

/*
ilk statement de önce kategorik bir deðiþken olan brand_id ye göre sýralama yapýp numerik deðiþken olan list_price brand_id ye baðlý olarak azalan þeklinde sýralandý. Beklenen bir sýralama gözlendi. Ancak ikinci statement te sýralama numerik deðiþken olan list_price göre yapýlýnca brand_id deki hiyerarþik yapý bozuldu ve tablonun anlaþýlmasý zorlaþtý. Galiba sýralama yapýlýrken kategorik, numerik ayrýmýna dikkat edilip sýralam yapýlýrsa daha anlaþýlýr tablo elde edilir. 
*/

-- 9. Write a query to pull the first 10 rows and all columns from the product table that have a list_price greater than or equal to 3000.

SELECT TOP 10 *
FROM product.product
WHERE list_price >= 3000;

-- 10. Write a query to pull the first 5 rows and all columns from the product table that have a list_price less than 3000.

SELECT TOP (5) *
FROM product.product
WHERE list_price < 3000;

-- 11. Find all customer last names that start with 'B' and end with 's'.

SELECT last_name
FROM sale.customer
WHERE last_name LIKE 'B%s';

-- 12. Use the customer table to find all information regarding customers whose address is Allen or Buffalo or Boston or Berkeley.

SELECT *
FROM sale.customer
WHERE city = 'Allen' 
	OR city = 'Buffalo'
	OR city = 'Boston' 
ORDER BY city ASC;


SELECT *
FROM sale.customer
WHERE city IN ('Allen', 'Buffalo', 'Boston')
ORDER BY city ASC;