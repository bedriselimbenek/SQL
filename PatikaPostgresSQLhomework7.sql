-- 1.film tablosunda bulunan filmleri rating değerlerine göre gruplayınız.

SELECT rating, COUNT(film_id)
FROM film 
GROUP BY rating;

-- 2.film tablosunda bulunan filmleri replacement_cost sütununa göre grupladığımızda 
--   film sayısı 50 den fazla olan replacement_cost değerini ve karşılık gelen film sayısını sıralayınız.

SELECT replacement_cost, COUNT(film_id) as num_of_film
FROM film 
GROUP BY replacement_cost
HAVING COUNT(film_id) > 50
ORDER BY num_of_film;

-- 3. customer tablosunda bulunan store_id değerlerine karşılık gelen müşteri sayılarını nelerdir?

SELECT store_id, COUNT(customer_id)
FROM customer
GROUP BY store_id

-- 4.city tablosunda bulunan şehir verilerini country_id sütununa göre gruplandırdıktan sonra 
--   en fazla şehir sayısı barındıran country_id bilgisini ve şehir sayısını paylaşınız.


SELECT country_id, COUNT(city) num_of_city
FROM city
GROUP BY country_id
ORDER BY num_of_city DESC
LIMIT 1;










