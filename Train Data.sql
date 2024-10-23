Set search_path to amazonia, public;

CREATE TABLE book(
bno INTEGER CHECK (bno >= 100000 AND bno <= 999999),
title VARCHAR(20) NOT NULL,
author VARCHAR(20) NOT NULL,
category CHAR(10) NOT NULL,
price DECIMAL(6,2) NOT NULL,
sales INTEGER DEFAULT 0  CHECK(sales >= 0),
CONSTRAINT bno_pk1 PRIMARY KEY(bno),
CONSTRAINT category_types CHECK (category IN ('Science', 'Lifestyle','Arts','Leisure')));

CREATE TABLE customer(
cno INTEGER CHECK (cno >= 100000 AND cno <= 999999),
name VARCHAR(20) NOT NULL,
address VARCHAR(30) NOT NULL,
balance DECIMAL(8,2) DEFAULT 0 CHECK (balance >= 0),
CONSTRAINT cno_pk2 PRIMARY KEY(cno));

CREATE TABLE bookOrder (
cno INTEGER,
bno INTEGER,
orderTime TIMESTAMP,
qty INTEGER CHECK (qty>0),
CONSTRAINT bno_fk2 FOREIGN KEY (bno) REFERENCES book(bno) ON DELETE CASCADE,
CONSTRAINT cno_fk1 FOREIGN KEY (cno) REFERENCES customer(cno) ON DELETE CASCADE);

CREATE TABLE record(
pay_user character(30) NOT NULL,
 pay_time timestamp without time zone NOT NULL,
 pay_cno integer NOT NULL,
 old_balance decimal(6,2),
 new_balance decimal(6,2));
 
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

CREATE TRIGGER total_sales_balance
AFTER UPDATE OR INSERT ON bookOrder
FOR EACH ROW
EXECUTE FUNCTION sales_balance_update();

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
 
CREATE TRIGGER record_payment
AFTER UPDATE ON customer
FOR EACH ROW
EXECUTE PROCEDURE record_payment();


INSERT INTO	customer (cno, name, address)
 VALUES (100001,'Paul Walker','ADD1'),
        (100002,'Sham Goar','ADD2'),
	    (100003,'Hang Wong','ADD3'),
	    (100004,'Gomesh Aggar','ADD4'),
        (100005,'Sachin Jain','ADD5');

select * from bookOrder;
select * from customer;
select * from book;

INSERT INTO book(bno, title, author, category, price)
 VALUES (100001,'History arts','Jon','Arts',14),
		(100002,'Widlife Treasury','Sam','Leisure',60),
		(100003,'Scific World','Karan','Science',45),
		(100004,'Trend Wear','John','Lifestyle',21),
		(100005,'World Form','Happy','Arts',67),
		(100006,'The Cannible','Kite','Leisure',33),
		(100007,'Theory Everything','Peter','Science',18),
		(100008,'Be Happy','Pie','Lifestyle',33),
		(100009,'Hola','Oman','Arts',56.5),
        (100010,'The Smack','Rocky','Leisure',18.2);

INSERT INTO bookOrder (cno,bno,orderTime,qty) 
 VALUES (100001,100001,current_timestamp,6),
		(100003,100002,current_timestamp,3),
		(100005,100004,current_timestamp,8),
		(100004,100006,current_timestamp,9),
		(100003,100008,current_timestamp,5),
		(100002,100010,current_timestamp,10),
		(100001,100001,current_timestamp,7),
		(100003,100003,current_timestamp,2),
		(100002,100005,current_timestamp,8),
		(100004,100007,current_timestamp,9),
		(100005,100009,current_timestamp,5),
		(100003,100004,current_timestamp,10),
		(100001,100007,current_timestamp,7);
		
---A----
--BNO: 100016, Title:'The Book Thief’, Author: 'Markus Zusak', Category`:'Leisure', Price: 3.58
INSERT INTO book
values (100016,'The Book Thief','Markus Zusak','Leisure',3.58);

Select * from book;	

--Delete book 
--BNO: ‘100016’
DELETE FROM book WHERE bno=100016;

Select * from book;	

--Insert customer
--CNO: 100011, name: 'Stuart Lynch', address: '1 Legoland, Windsor'
INSERT INTO	customer
VALUES (100011,'Stuart Lynch','1 Legoland, Windsor');

Select * from customer;	

--Delete customer
--CNO: '100011'
DELETE FROM customer WHERE cno=100011;

Select * from customer;	

--Place orders
--CNO: 100010, BNO: 100013, qty: 3
CREATE PROCEDURE place_order(cust_no INTEGER,book_no INTEGER, qty INTEGER)    
LANGUAGE plpgsql
AS $BODY$
BEGIN 
    IF (cust_no NOT IN(SELECT cno FROM customer WHERE cno = cust_no))THEN
	INSERT INTO customer (cno,name,address)  VALUES (cust_no,'False_Name','False_Address');
	END IF;
	IF (book_no NOT IN(SELECT bno FROM book WHERE bno = book_no)) THEN
	INSERT INTO book VALUES (book_no,'False_Title', 'False_Author','Lifestyle',24.12);
    END IF;
    INSERT INTO bookOrder VALUES (cust_no,book_no,current_timestamp,qty);
 END;
$BODY$;

CALL place_order(100010,100013,3);

Select * from bookOrder
where cno=100010 and bno= 100013;

Select * from customer
where cno=100010;

--Record a Payment by a customer
--CNO: 100001, Amount: £100
CREATE PROCEDURE transfer_amt(custno integer,amount numeric)
LANGUAGE SQL    
AS $$
UPDATE customer SET balance = balance - amount 
WHERE cno = custno;
$$;

CALL transfer_amt(100001,100);

Select * from record
where pay_cno = 100001;

--Find details of customers for books like 'Prejudice'/’prejudice’
CREATE VIEW title_check AS
SELECT DISTINCT bk.title,cu.name,cu.address FROM customer cu, book bk, bookOrder bO 
WHERE bk.bno=bO.bno AND cu.cno=bO.cno 
ORDER BY bk.title, cu.name;

SELECT * FROM title_check 
WHERE title LIKE '%The%';

--Books for customer CNO: 100006
CREATE VIEW cust_book AS
SELECT DISTINCT cu.name,bO.bno,bk.title,bk.author FROM customer cu, book bk, bookOrder bO 
WHERE bk.bno=bO.bno AND cu.cno=bO.cno 
ORDER BY bO.bno;

--Train Data consist customer till 100005 only
SELECT * FROM  cust_book
WHERE name = (select name from customer where cno = 100005);

Select * from customer
where cno = 100006;

--Book report
CREATE VIEW  book_report AS
SELECT bk.category, SUM(bO.qty) AS Total_Book_Sold, SUM(bO.qty*bk.price) AS 
Total_Book_Value FROM book bk JOIN bookOrder bO ON bk.bno=bO.bno 
GROUP BY bk.category;

Select * from book_report;

--Customer report
CREATE VIEW customer_report AS 
SELECT cu.cno,cu.name,SUM(bO.qty)
FROM customer cu JOIN  bookOrder bO ON cu.cno =bO.cno 
GROUP BY cu.cno ORDER BY cu.cno; 

Select * from customer_report;

-- 'INSERT' BNO: 100009, Title: 'Programming', Author: 'Donald Knuth', Cat: 'Science', Price: 70.89
Insert into book
 Values (100009,'Programming','Donald Knuth','Science',70.89);
 
 --'INSERT' BNO:100015, Title: 'Programming', Author: 'Donald Knuth', Cat: 'Computing', Price: 70.89 
 Insert into book
 Values (100015,'Programming','Donald Knuth','Computing',70.89);
 
--'DELETE' BNO: '100013';
Delete from book 
Where bno = 100013;

-- 'UPDATE' Update payment for customer CNO: 100017 with amount £100
Call transfer_amt(100017,100);

Select * from record
where pay_cno = 100017;

--Find books with fragment “Fish” in title.
SELECT * FROM title_check 
WHERE title LIKE '%Fish%';

-- 'DELETE' BNO: '100001'
Delete from book 
Where bno = 100001;

