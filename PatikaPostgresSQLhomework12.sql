-- 1.film tablosunda film uzunluğu length sütununda gösterilmektedir. 
--   Uzunluğu ortalama film uzunluğundan fazla kaç tane film vardır?

SELECT COUNT(film_id)
FROM film
WHERE length > 
(
SELECT AVG(length)
FROM film
)

-- 2.film tablosunda en yüksek rental_rate değerine sahip kaç tane film vardır?

SELECT COUNT(film_id)
FROM film
WHERE rental_rate = 
(
SELECT MAX(rental_rate)
FROM film
); 

-- 3.film tablosunda en düşük rental_rate ve en düşün replacement_cost değerlerine sahip filmleri sıralayınız.

SELECT title, rental_rate, replacement_cost
FROM film
WHERE rental_rate =
( 
SELECT min(rental_rate)
FROM film
)
AND replacement_cost = 
(
SELECT min(replacement_cost)
FROM film
)
ORDER BY title DESC;
------------------------------------------------
SELECT title, rental_rate, replacement_cost 
FROM film 
WHERE (rental_rate, replacement_cost) = 
(
	SELECT MIN(rental_rate), MIN(replacement_cost) 
	FROM film
);
------------------------------------------------


-- 4.payment tablosunda en fazla sayıda alışveriş yapan müşterileri(customer) sıralayınız.

SELECT c.first_name, c.last_name, p.customer_id, COUNT(p.customer_id)
FROM payment p
JOIN customer c
	ON p.customer_id = c.customer_id
GROUP BY c.first_name, c.last_name, p.customer_id
ORDER BY COUNT(p.customer_id) DESC;
----------------------------------
SELECT c.first_name, c.last_name, p.customer_id, COUNT(p.customer_id)
FROM payment p, customer c
WHERE c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name, p.customer_id
ORDER BY COUNT(p.customer_id) DESC;
----------------------------------













































