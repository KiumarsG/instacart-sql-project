USE instacart;

-- Finding the busiest hours of the day
SELECT order_hour_of_day, COUNT(*) AS num_orders_per_hour
FROM orders
GROUP BY order_hour_of_day
ORDER BY num_orders_per_hour DESC;

-- finding the busiest days of the week with reorder activity
DROP TABLE IF EXISTS reordered_and_dow;
CREATE TABLE reordered_and_dow AS
SELECT order_dow, COUNT(*) AS number_of_occurence
FROM (
SELECT r.order_id, r.product_id, o.order_dow
FROM (
	SELECT order_id, product_id
    FROM order_products_train
    WHERE reordered = 1
    
    UNION ALL
    
    SELECT order_id, product_id
    FROM order_products_prior
    WHERE reordered = 1
		AND order_id % 7 = 0
) AS r
INNER JOIN (
SELECT order_id, order_dow
FROM orders
) AS o
ON r.order_id = o.order_id
) AS final_result
GROUP BY order_dow;

SELECT * FROM reordered_and_dow;
