DROP TABLE IF EXISTS card_holder CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS merchant_category CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;
DROP TABLE IF EXISTS transaction CASCADE;

CREATE TABLE card_holder (
	id INT,
	name VARCHAR(50),
	PRIMARY KEY (id)
);

CREATE TABLE credit_card (
	card VARCHAR(30) NOT NULL,
	id_card_holder INT NOT NULL,
	FOREIGN KEY (id_card_holder) REFERENCES card_holder(id)
);

CREATE TABLE merchant_category (
	id INT,
	name VARCHAR(20),
	PRIMARY KEY (id)
);

CREATE TABLE merchant (
	id INT PRIMARY KEY,
	name VARCHAR(50),
	id_merchant_category INT NOT NULL,
	FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id)
);

CREATE TABLE transaction (
	id INT,
	date TIMESTAMP,
	amount FLOAT(2),
	card VARCHAR(30) NOT NULL,
	id_merchant INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id_merchant) REFERENCES merchant(id)
);

