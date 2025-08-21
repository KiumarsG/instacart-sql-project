USE instacart;

LOAD DATA LOCAL INFILE '/path/to/archive/aisles.csv'
INTO TABLE aisles
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(aisle_id, aisle);

LOAD DATA LOCAL INFILE '/path/to/archive/departments.csv'
INTO TABLE departments
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(department_id, department);

LOAD DATA LOCAL INFILE '/path/to/archive/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_name, aisle_id, department_id);

LOAD DATA LOCAL INFILE '/path/to/archive/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, user_id, eval_set, order_number, order_dow, order_hour_of_day, days_since_prior_order);

LOAD DATA LOCAL INFILE '/path/to/archive/order_products__prior.csv'
INTO TABLE order_products_prior
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, product_id, add_to_cart_order, reordered);

LOAD DATA LOCAL INFILE '/path/to/archive/order_products__train.csv'
INTO TABLE order_products_train
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, product_id, add_to_cart_order, reordered);