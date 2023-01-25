USE SampleRetail


-- PRECLASS Let's Practice
-- "Sony - 5.1-Ch. 3D / Smart Blu-ray Ev Sinema Sistemi - Siyah" adlý ürünün sipariþ tarihini döndüren bir sorgu yazýn.

SELECT o.order_date 
FROM product.product pp
INNER JOIN sale.order_item oi
	ON  pp.product_id = oi.product_id
INNER JOIN sale.orders o
	ON oi.order_id = o.order_id
WHERE pp.product_name = 'Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black'

-- "Seagate" markalý ürünlerin sipariþlerini döndüren bir sorgu yazýn. Sipariþ edilen veya edilmeyen tüm ürünlerin Ürün adlarý ve sipariþ kimlikleri listelenmelidir. (artan düzende order_id)

SELECT A.product_name, B.order_id
FROM product.product A
LEFT JOIN sale.order_item B
	ON A.product_id = B.product_id
INNER JOIN product.brand C
	ON A.brand_id = C.brand_id
WHERE C.brand_name LIKE '%seagate%'
ORDER BY B.order_id;