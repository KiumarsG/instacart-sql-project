USE instacart;

-- Finding costumers with highest order activity
SELECT user_id, COUNT(*) as number_of_orders
FROM orders
GROUP BY user_id
ORDER BY number_of_orders DESC;

-- finding costumers trying the most unique products:
-- 1. finding the most unique products
DROP TABLE IF EXISTS unique_products;
CREATE TABLE unique_products AS
SELECT product_id, SUM(occurence) AS occurence
FROM (
	SELECT product_id, COUNT(*) AS occurence
    FROM order_products_train
    GROUP BY product_id
    
    UNION ALL
    
    SELECT product_id, COUNT(*) AS occurence
    FROM order_products_prior
    WHERE order_id % 3 = 0
    GROUP BY product_id
) AS combined_tables
GROUP BY product_id;

SELECT * FROM unique_products;

-- 2. finding costumers that try these products
WITH rarest_products AS (
	SELECT product_id, occurence
    FROM unique_products
    ORDER BY occurence ASC
    LIMIT 2000
)
SELECT o.user_id, uc.order_id, uc.product_id, uc.occurence
FROM orders AS o
INNER JOIN	(
	SELECT ot.order_id, u.product_id, u.occurence
	FROM order_products_train as ot
	INNER JOIN rarest_products as u
	ON ot.product_id = u.product_id

	UNION ALL 

	SELECT op.order_id, u.product_id, u.occurence
	FROM order_products_prior as op
	INNER JOIN rarest_products as u
	ON op.product_id = u.product_id
    WHERE op.order_id % 3 = 0
) AS uc
ON o.order_id = uc.order_id
ORDER BY uc.occurence ASC;