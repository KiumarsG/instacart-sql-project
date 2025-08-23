USE instacart;

-- Doing the same thing as with in customer behavior to find the top 10 most popular products
DROP TABLE IF EXISTS frequency_of_products;
CREATE TABLE frequency_of_products AS
SELECT product_id, number_of_appearance
FROM (
	SELECT product_id, SUM(cnt) as number_of_appearance
    FROM (
		SELECT product_id, COUNT(*) as cnt
		FROM instacart.order_products_train
		GROUP BY product_id
		
		UNION ALL
		
		SELECT product_id, COUNT(*) as cnt
		FROM instacart.order_products_prior
		WHERE order_id % 3 = 0
		GROUP BY product_id
		) AS product_counts
	GROUP BY product_id
) AS final_result;

SELECT p.product_name
FROM products AS p
JOIN (
	SELECT product_id, number_of_appearance
    FROM frequency_of_products
    ORDER BY number_of_appearance DESC
    LIMIT 10
) AS f
ON p.product_id = f.product_id
ORDER BY f.number_of_appearance DESC;

-- now we want to identify the top 5 departments by sales volume and we use the products table with 
-- the help of most popular products we just obtained
SELECT d.department, q.number_of_appearance
FROM departments as d
JOIN (
	SELECT p.department_id, f.number_of_appearance
	FROM products AS p
	JOIN (
		SELECT product_id, number_of_appearance
		FROM frequency_of_products
		ORDER BY number_of_appearance DESC
		LIMIT 5
	) AS f
	ON p.product_id = f.product_id
) as q
ON d.department_id = q.department_id
ORDER BY q.number_of_appearance DESC;

-- finding the top 10 aisles with the highest reorder rate
SELECT a.aisle, o.num_reordered
FROM aisles AS a
JOIN (
	SELECT p.product_id, p.aisle_id, r.num_reordered
	FROM (
		SELECT product_id, SUM(reordered) as num_reordered
		FROM order_products_train
		GROUP BY product_id
		
		UNION ALL
		
		SELECT product_id, SUM(reordered) as num_reordered
		FROM order_products_prior
		WHERE order_id % 3 = 0
		GROUP BY product_id
	) AS r
	JOIN (
		SELECT product_id, aisle_id
		FROM products
	) AS p
	ON p.product_id = r.product_id
	ORDER BY r.num_reordered DESC
	LIMIT 10
) as o
ON o.aisle_id = a.aisles_id;

    
