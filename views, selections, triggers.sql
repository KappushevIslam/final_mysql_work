-- ************************* Feature selections *************************

-- How many times every user was added to favorite sellers
SELECT users.id, first_name, last_name, COUNT(users.id)
FROM users JOIN favorite_sellers
ON
users.id = favorite_sellers.seller_user_id
GROUP BY users.id ORDER BY id;

SELECT id,
  first_name,
  last_name,
  (SELECT COUNT(*) FROM favorite_sellers WHERE favorite_sellers.seller_user_id = users.id)
FROM users;

-- All the products that were posted in 2021
SELECT * FROM products
WHERE DATE_FORMAT(created_at,'%Y') in (2021);

SELECT COUNT(user_id) AS 'male_products', COUNT(user_id) AS 'female_products' FROM profiles JOIN products
ON profiles.user_id = products.SELLER_USER_ID AND gender = 'M'
ON profiles.user_id = products.SELLER_USER_ID AND gender = 'F';

-- Number of products posted by males and females
SELECT
  profiles.gender AS gender,
  COUNT(products.id) AS total
FROM profiles
JOIN products
ON 
  profiles.user_id = products.SELLER_USER_ID
GROUP BY gender;

-- Number of photoes for each product
SELECT products.id, products.name, COUNT(photoes.product_id) AS 'total' FROM photoes RIGHT JOIN products ON photoes.product_id = products.id GROUP BY products.id; 

-- Select id of user, his name, product he posted that doesn't have avito delivery, has the type of real estate and was posted in 2021
SELECT 
users.id AS 'id_of_user', first_name, last_name, products.id AS 'id_of_product', products.name as 'name_of_product', products.product_cathegory_id AS 'cathegory_of_product' 
FROM USERS
RIGHT JOIN products
ON products.seller_user_id = users.id AND products.avito_delivery = 0 AND DATE_FORMAT(products.created_at,'%Y') in (2021)
JOIN product_cathegories
JOIN product_types
ON products.product_cathegory_id = product_cathegories.id AND product_cathegories.product_type_id = 1
GROUP BY id_of_user;

-- ************************* Indexes *************************
CREATE INDEX user_fullname ON users(first_name, last_name);
CREATE INDEX products_name ON products(name);
CREATE INDEX users_cities ON profiles(city_id);

-- ************************* Views *************************

-- All the products in a definite city
CREATE VIEW products_in_lionelberg
   AS SELECT products.*
FROM products
JOIN profiles
ON profiles.user_id = products.seller_user_id AND profiles.city_id = 1;

-- Citizens of definite region
CREATE VIEW users_from_oregon
AS SELECT users.*, cities.id AS 'city'
FROM users 
JOIN profiles
ON users.id = profiles.user_id
JOIN regions
JOIN cities
ON profiles.city_id = cities.id AND cities.region_id = 1 GROUP BY id;


CREATE VIEW full_info_aout_products_by_text
AS SELECT products.id, users.first_name,
users.last_name, products.name,
products.description, products.price,
products.address, product_cathegories.name AS 'product_cathegory',
products.avito_delivery, products.created_at, products.updated_at
FROM products
LEFT JOIN users 
ON products.seller_user_id = users.id 
LEFT JOIN product_cathegories
ON products.product_cathegory_id = product_cathegories.id;

-- ************************* Triggers *************************

CREATE TRIGGER phone_and_email_null_check BEFORE INSERT ON users FOR EACH ROW
BEGIN
  IF NEW.phone IS NULL AND NEW.email IS NULL
    THEN SIGNAL sqlstate '45001' SET message_text = "phone and email cannot be both NULL"; 
  END IF;
END //

CREATE TRIGGER target_of_message_is_the_same_check BEFORE INSERT ON messages FOR EACH ROW
BEGIN
  IF NEW.from_user_id = NEW.to_user_id
    THEN SIGNAL sqlstate '45000' SET message_text = "sending messages to yourself is impossible"; 
  END IF;
END //

DELIMITER ;
