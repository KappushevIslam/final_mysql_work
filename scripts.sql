CREATE DATABASE avito;
USE avito;

CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(100) UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Main info about users';

CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY, 
  gender CHAR(1) NOT NULL,
  city_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
); COMMENT 'extra info about users'

CREATE TABLE cities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE,
  region_id INT UNSIGNED
  );

CREATE TABLE regions (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE
  );
 
CREATE TABLE favorite_products (
  user_id INT UNSIGNED NOT NULL COMMENT 'who added the product to favorites',
  product_id INT UNSIGNED NOT NULL COMMENT 'what product was added to favorites',
  PRIMARY KEY (user_id, product_id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
  
CREATE TABLE favorite_searches (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL COMMENT 'owner of the current search',
  name VARCHAR(120) NOT NULL COMMENT 'the text of search',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
  
CREATE TABLE favorite_sellers (
  user_id INT UNSIGNED NOT NULL COMMENT 'who added seller to favorites',
  seller_user_id INT NOT NULL COMMENT 'seller\'s ID',
  PRIMARY KEY (user_id, seller_user_id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );

CREATE TABLE product_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
 );

CREATE TABLE product_cathegories (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  product_type_id INT UNSIGNED NOT NULL,
  name VARCHAR(100) NOT NULL
  );

CREATE TABLE products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL COMMENT 'head of the product',
  description VARCHAR(255) NOT NULL COMMENT 'description of the product',
  price INT NOT NULL,
  seller_user_id INT UNSIGNED NOT NULL COMMENT 'ID of seller',
  address VARCHAR(255) NOT NULL,
  product_cathegory_id INT UNSIGNED NOT NULL COMMENT 'product\'s cathegory',
  avito_delivery BOOLEAN NOT NULL COMMENT 'presence of opportunity to sent by avito delivery',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
 
CREATE TABLE photoes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  product_id INT UNSIGNED NOT NULL COMMENT 'what product\'s photo it is',
  filename VARCHAR(255) NOT NULL COMMENT 'placement of file and its name',
  size INT NOT NULL
  ) COMMENT 'photoes of the products';
  
CREATE TABLE orders (
  user_id INT UNSIGNED NOT NULL COMMENT 'who made the order',
  product_id INT UNSIGNED NOT NULL COMMENT 'what product was ordered',
  PRIMARY KEY (user_id, product_id)
  );
  
CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  from_user_id INT UNSIGNED NOT NULL COMMENT 'who sent the message',
  to_user_id INT UNSIGNED NOT NULL COMMENT 'who gets the message',
  body TEXT NOT NULL,
  is_delivered BOOLEAN,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );

CREATE TABLE reviews (
  body TEXT NOT NULL,
  user_id INT UNSIGNED NOT NULL COMMENT 'author of feedback',
  product_id INT UNSIGNED NOT NULL COMMENT 'product on which the feedback was made',
  PRIMARY KEY (user_id, product_id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) COMMENT 'Feedbacks from users';

  -- some DB modifications
SELECT * FROM users;
 -- Giving a correct look
UPDATE photoes SET filename = CONCAT( 'http://dropbox.net/avito/', filename, '.jpg');

-- Using this command in every table where needed
UPDATE profiles SET updated_at = NOW() WHERE updated_at < created_at;

-- There was useless column that was deleted
ALTER TABLE product_types DROP COLUMN updated_at;

-- Generated data incorrectly, fixing
UPDATE favorite_products SET user_id = FLOOR(1 + RAND() * 400);
UPDATE favorite_searches SET user_id = FLOOR(1 + RAND() * 400);
UPDATE favorite_sellers SET user_id = FLOOR(1 + RAND() * 400);

-- Fixing too big prices
UPDATE products SET price = 10000000 WHERE price > 10000000;

