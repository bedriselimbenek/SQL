USE SampleRetail


-- PRECLASS Let's Practice
-- "Sony - 5.1-Ch. 3D / Smart Blu-ray Ev Sinema Sistemi - Siyah" adl� �r�n�n sipari� tarihini d�nd�ren bir sorgu yaz�n.

SELECT o.order_date 
FROM product.product pp
INNER JOIN sale.order_item oi
	ON  pp.product_id = oi.product_id
INNER JOIN sale.orders o
	ON oi.order_id = o.order_id
WHERE pp.product_name = 'Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black'

-- "Seagate" markal� �r�nlerin sipari�lerini d�nd�ren bir sorgu yaz�n. Sipari� edilen veya edilmeyen t�m �r�nlerin �r�n adlar� ve sipari� kimlikleri listelenmelidir. (artan d�zende order_id)

SELECT A.product_name, B.order_id
FROM product.product A
LEFT JOIN sale.order_item B
	ON A.product_id = B.product_id
INNER JOIN product.brand C
	ON A.brand_id = C.brand_id
WHERE C.brand_name LIKE '%seagate%'
ORDER BY B.order_id;