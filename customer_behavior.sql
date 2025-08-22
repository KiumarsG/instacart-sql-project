-- there is no need for the prior and train distinction since we are not doing machine learning 
SET @col_exists =  (
SELECT COUNT(*)
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = 'instacart'
		AND TABLE_NAME = 'orders'
		AND COLUMN_NAME = 'eval_set'
);

SET @sql = IF(
@col_exists>0,
'ALTER TABLE instacart.orders DROP COLUMN eval_set;',
'SELECT "column does not exist";'
);

-- this will get rid of the eval_set column if it exists
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- to calculate the average number of products per order we need to first combine the two tables order_products_train
-- and order_products_prior since we do not distinguish between them for our task
DROP TABLE IF EXISTS products_per_order;
CREATE TABLE products_per_order AS
SELECT order_id, SUM(num_products_per_order) AS num_products_per_order
FROM (
	SELECT order_id, SUM(cnt) AS num_products_per_order
	FROM (
		SELECT order_id, COUNT(*) AS cnt 
		FROM instacart.order_products_train
		GROUP BY order_id

		UNION ALL

		SELECT order_id, COUNT(*) AS cnt 
		FROM instacart.order_products_prior
			WHERE order_id % 3 = 0
		GROUP BY order_id
		) AS combined_orders
	GROUP BY order_id
) AS final_result
GROUP BY order_id;
        
-- finally we calculate the scalar representing the average number of products ordered
SELECT AVG(num_products_per_order) AS average_number_of_products_ordered
FROM  products_per_order;

-- now we want to find the most frequently ordered product, for this we could use the product_id used in the order_products_train
-- and order_products_prior
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

-- now that we have the product_id we will use the products table to find the product name
SELECT product_name
FROM instacart.products 
WHERE product_id = ( -- this will take the product_id corresponding to the maximum number of appearance
	SELECT product_id
	FROM frequency_of_products
	ORDER BY number_of_appearance DESC
	LIMIT 1
);

-- now we will caculate the percentage of orders with reorders
DROP TABLE IF EXISTS reorder_vs_order;
CREATE TABLE reorder_vs_order AS
SELECT COUNT(*) AS number_of_orders, SUM(reordered_indicator) AS total_reordered
FROM (
	SELECT order_id, 
		CASE 
			WHEN SUM(total_reordered) > 0 THEN 1
			ELSE 0
		END AS reordered_indicator
	FROM (
		SELECT order_id, SUM(reordered) AS total_reordered
		FROM instacart.order_products_train
		GROUP BY order_id
		
		UNION ALL
		
		SELECT order_id, SUM(reordered) AS total_reordered
		FROM instacart.order_products_prior
		WHERE order_id % 3 = 0
		GROUP BY order_id
	) AS grouped_reorder
	GROUP BY order_id
) AS final_result;

-- finally, we calculate the percentage
SELECT ROUND(total_reordered / number_of_orders * 100, 2) AS percentage_of_reorders
FROM reorder_vs_order;