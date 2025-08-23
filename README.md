# instacart-sql-project
This is a project for analyzing the instacart market basket using MySQL.

##Goals
- understanding costumer ordering behaviour.
- identifying top products and departments.
- identifying reordering patterns.

##Example Query
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

#Notes
- Since the order_products__prior.csv file is too large I often took a part of it in my queries (for example you will see order_id % 3 = 0)

Dataset : https://www.kaggle.com/datasets/psparks/instacart-market-basket-analysis
Author : KiumarsG (https://github.com/KiumarsG)
