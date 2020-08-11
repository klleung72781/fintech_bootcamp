-- -- How can you isolate (or group) the transactions of each cardholder?
SELECT	MAX(CH.name) AS CUSTOMER_NAME,
		COUNT(T.id) AS NUMBER_OF_TRANSACTION,
		COUNT(DISTINCT T.card) AS NUMBER_OF_CARD,
		SUM(T.amount) AS TOTAL_SPENDING,
		MIN(T.date) AS FIRST_TRANSACTION,
		MAX(T.date) AS LAST_TRANSACTION
FROM transaction T
INNER JOIN credit_card CC ON T.card = CC.card
INNER JOIN card_holder CH ON CC.id_card_holder = CH.id
INNER JOIN merchant M ON T.id_merchant = M.id
INNER JOIN merchant_category MC ON M.id_merchant_category = MC.id
GROUP BY CH.id;

-- Consider the time period 7:00 a.m. to 9:00 a.m.
-- -- What are the 100 highest transactions during this time period?
SELECT 	T.date AS TRANSACTION_DATE,
		T.card AS CARD_NUMBER,
		T.amount AS TRANSACTION_AMOUNT,
		CH.name AS CARD_HOLDER_NAME,
		M.name AS MERCHANT_NAME,
		MC.name AS MERCHANT_CATEGORY
FROM transaction T
INNER JOIN credit_card CC ON T.card = CC.card
INNER JOIN card_holder CH ON CC.id_card_holder = CH.id
INNER JOIN merchant M ON T.id_merchant = M.id
INNER JOIN merchant_category MC ON M.id_merchant_category = MC.id
WHERE DATE_PART('hour', T.date) BETWEEN 7 AND 9
ORDER BY T.amount DESC
LIMIT 100;

-- -- Do you see any fraudulent or anomalous transactions?
-- -- If you answered yes to the previous question,
-- -- explain why you think there might be fraudulent transactions during this time frame.

-- Some fraudsters hack a credit card by making several small payments (generally less than $2.00),
-- which are typically ignored by cardholders. Count the transactions that are less than $2.00 per cardholder.
-- Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.
SELECT 	MAX(CH.name) AS CARD_HOLDER_NAME,
		COUNT(T.id) AS NUMBER_OF_TRANSACTION
FROM transaction T
INNER JOIN credit_card CC ON T.card = CC.card
INNER JOIN card_holder CH ON CC.id_card_holder = CH.id
INNER JOIN merchant M ON T.id_merchant = M.id
INNER JOIN merchant_category MC ON M.id_merchant_category = MC.id
WHERE T.amount < 2
GROUP BY CH.name
ORDER BY NUMBER_OF_TRANSACTION DESC;

-- What are the top five merchants prone to being hacked using small transactions?
SELECT 	MAX(M.name) AS MERCHANT,
		COUNT(T.id) AS NUMBER_OF_TRANSACTION
FROM transaction T
INNER JOIN credit_card CC ON T.card = CC.card
INNER JOIN card_holder CH ON CC.id_card_holder = CH.id
INNER JOIN merchant M ON T.id_merchant = M.id
INNER JOIN merchant_category MC ON M.id_merchant_category = MC.id
WHERE T.amount < 2
GROUP BY T.id_merchant
ORDER BY NUMBER_OF_TRANSACTION DESC;

-- Once you have a query that can be reused, create a view for each of the previous queries.
-- -- card_holder_transaction
DROP VIEW IF EXISTS card_holder_transaction;
CREATE VIEW card_holder_transaction AS (
	SELECT	MAX(CH.name) AS CUSTOMER_NAME,
			MAX(CH.id) AS CUSTOMER_ID,
			COUNT(T.id) AS NUMBER_OF_TRANSACTION,
			COUNT(DISTINCT T.card) AS NUMBER_OF_CARD,
			SUM(T.amount) AS TOTAL_SPENDING,
			MIN(T.date) AS FIRST_TRANSACTION,
			MAX(T.date) AS LAST_TRANSACTION
	FROM transaction T
	INNER JOIN credit_card CC ON T.card = CC.card
	INNER JOIN card_holder CH ON CC.id_card_holder = CH.id
	INNER JOIN merchant M ON T.id_merchant = M.id
	INNER JOIN merchant_category MC ON M.id_merchant_category = MC.id
	GROUP BY CH.id
);

-- -- top 100 transactions between 7-9am
DROP VIEW IF EXISTS top_100_7_to_9am;
CREATE VIEW top_100_7_to_9am AS (
	SELECT 	T.date AS TRANSACTION_DATE,
			T.card AS CARD_NUMBER,
			T.amount AS TRANSACTION_AMOUNT,
			CH.name AS CARD_HOLDER_NAME,
			M.name AS MERCHANT_NAME,
			MC.name AS MERCHANT_CATEGORY
	FROM transaction T
	INNER JOIN credit_card CC ON T.card = CC.card
	INNER JOIN card_holder CH ON CC.id_card_holder = CH.id
	INNER JOIN merchant M ON T.id_merchant = M.id
	INNER JOIN merchant_category MC ON M.id_merchant_category = MC.id
	WHERE DATE_PART('hour', T.date) BETWEEN 7 AND 9
	ORDER BY T.amount DESC
	LIMIT 100
);

-- -- customers with most sub-$2 transactions
DROP VIEW IF EXISTS customer_sub_2_trans;
CREATE VIEW customer_sub_2_trans AS (
	SELECT 	MAX(CH.name) AS CARD_HOLDER_NAME,
			COUNT(T.id) AS NUMBER_OF_TRANSACTION
	FROM transaction T
	INNER JOIN credit_card CC ON T.card = CC.card
	INNER JOIN card_holder CH ON CC.id_card_holder = CH.id
	INNER JOIN merchant M ON T.id_merchant = M.id
	INNER JOIN merchant_category MC ON M.id_merchant_category = MC.id
	WHERE T.amount < 2
	GROUP BY CH.name
	ORDER BY NUMBER_OF_TRANSACTION DESC
);

-- -- merchants most vulnerable to hacks
DROP VIEW IF EXISTS merchant_prone_to_hacks;
CREATE VIEW merchant_prone_to_hacks AS (
	SELECT 	MAX(M.name) AS MERCHANT,
			COUNT(T.id) AS NUMBER_OF_TRANSACTION
	FROM transaction T
	INNER JOIN credit_card CC ON T.card = CC.card
	INNER JOIN card_holder CH ON CC.id_card_holder = CH.id
	INNER JOIN merchant M ON T.id_merchant = M.id
	INNER JOIN merchant_category MC ON M.id_merchant_category = MC.id
	WHERE T.amount < 2
	GROUP BY T.id_merchant
	ORDER BY NUMBER_OF_TRANSACTION DESC
);
