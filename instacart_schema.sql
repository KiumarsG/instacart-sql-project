USE instacart;
DROP TABLE IF EXISTS aisles;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS order_products_prior;
DROP TABLE IF EXISTS order_products_train;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;


CREATE TABLE orders (
order_id int,
user_id int,
eval_set VARCHAR(50),
order_number int,
order_dow int,
order_hour_of_day int,
days_since_prior_order float
);
CREATE TABLE aisles (
aisles_id int,
aisle VARCHAR(50)
);
CREATE TABLE products (
product_id int,
product_name VARCHAR(50),
aisle_id int,
department_id int
);
CREATE TABLE departments (
department_id int,
department VARCHAR(50)
);
CREATE TABLE order_products_prior (
order_id int,
product_id int,
add_to_cart_order int,
reordered int
);
CREATE TABLE order_products_train (
order_id int,
product_id int,
add_to_cart_order int,
reordered int
);