-- Loading data for book table

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
		
-- Loading data for customer table

INSERT INTO	customer (cno, name, address)
 VALUES (100001,'Paul Walker','ADD1'),
        (100002,'Sham Goar','ADD2'),
	    (100003,'Hang Wong','ADD3'),
	    (100004,'Gomesh Aggar','ADD4'),
        (100005,'Sachin Jain','ADD5');
		
-- Loading data for bookOrder table

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
		
