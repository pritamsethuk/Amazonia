Set search_path to amazonia, public;

-- Creating Tables

-- Creating table book

CREATE TABLE book(
bno INTEGER CHECK (bno >= 100000 AND bno <= 999999),
title VARCHAR(20) NOT NULL,
author VARCHAR(20) NOT NULL,
category CHAR(10) NOT NULL,
price DECIMAL(6,2) NOT NULL,
sales INTEGER DEFAULT 0  CHECK(sales >= 0),
CONSTRAINT bno_pk1 PRIMARY KEY(bno),
CONSTRAINT category_types CHECK (category IN ('Science', 'Lifestyle','Arts','Leisure')));

-- Creating table customer

CREATE TABLE customer(
cno INTEGER CHECK (cno >= 100000 AND cno <= 999999),
name VARCHAR(20) NOT NULL,
address VARCHAR(30) NOT NULL,
balance DECIMAL(8,2) DEFAULT 0 CHECK (balance >= 0),
CONSTRAINT cno_pk2 PRIMARY KEY(cno));

-- Creating table bookOrder

CREATE TABLE bookOrder (
cno INTEGER,
bno INTEGER,
orderTime TIMESTAMP,
qty INTEGER CHECK (qty > 0),
CONSTRAINT bno_fk2 FOREIGN KEY (bno) REFERENCES book(bno) ON DELETE CASCADE,
CONSTRAINT cno_fk1 FOREIGN KEY (cno) REFERENCES customer(cno) ON DELETE CASCADE);

-- Creating table record

CREATE TABLE record(
pay_user character(30) NOT NULL,
 pay_time timestamp without time zone NOT NULL,
 pay_cno integer NOT NULL,
 old_balance decimal(6,2),
 new_balance decimal(6,2));

-- Creating Functions sales_balance_update()

CREATE OR REPLACE FUNCTION sales_balance_update()
  RETURNS trigger AS 
  $$ 
  DECLARE
  book_price DECIMAL(6,2);
  BEGIN 
	SELECT (NEW.qty*price) INTO book_price FROM book where bno=NEW.bno;
	UPDATE book set sales = sales+NEW.qty where bno=NEW.bno;
	UPDATE customer set balance = balance+book_price where cno=NEW.cno;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Creating Functions record_payment()

CREATE OR REPLACE FUNCTION record_payment()
 RETURNS trigger AS
$BODY$
BEGIN
INSERT INTO record VALUES
(USER,
CURRENT_TIMESTAMP,OLD.cno,OLD.balance,new.balance);
RETURN NEW;
END
$BODY$
 LANGUAGE plpgsql;


-- Creating Trigger total_sales_balance

CREATE TRIGGER total_sales_balance
AFTER UPDATE OR INSERT ON bookOrder
FOR EACH ROW
EXECUTE FUNCTION sales_balance_update();


-- Creating Trigger record_payment

CREATE TRIGGER record_payment
AFTER UPDATE ON customer
FOR EACH ROW
EXECUTE PROCEDURE record_payment();

