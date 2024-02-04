--In this project,we will design a data model for instagram using postgresql.
--we will create different tables and build the data model,generate SQL create 
--table statements,insert data shown example of updating data and add analytic
--example using where condition,orderby,groupby,having clause etc.


--creating tables
CREATE TABLE users(
	user_id SERIAL PRIMARY KEY, // SERIAL is a datatype ,PRIMARY KEY is a constraint
	name VARCHAR(50) NOT NULL,
	email  VARCHAR(50) UNIQUE NOT NULL,
	phone_number  VARCHAR(50) UNIQUE
);

CREATE TABLE posts(
	post_id SERIAL PRIMARY KEY,
	user_id INTEGER NOT NULL,
	caption TEXT,
	image_url VARCHAR(200),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(user_id)REFERENCES users(user_id)
);

CREATE TABLE comments(
	comment_id  SERIAL PRIMARY KEY,
	post_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,
	comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(post_id)REFERENCES posts(post_id),
	FOREIGN KEY(user_id)REFERENCES users(user_id)
);

CREATE TABLE likes(
	like_id SERIAL PRIMARY KEY,
	post_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(post_id)REFERENCES posts(post_id),
	FOREIGN KEY(user_id)REFERENCES users(user_id)
);

CREATE TABLE followers(
	follower_id SERIAL PRIMARY KEY,
	user_id INTEGER NOT NULL,
	follower_user_id INTEGER NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(user_id) REFERENCES posts(post_id),
	FOREIGN KEY(follower_user_id) REFERENCES users(user_id)
);

--Inserting into users table
INSERT INTO users(name,email,phone_number)
VALUES('john','john@gmail.com','9010897654'),
       ('shiva','shiva@gmail.com','7092876542'),
	   ('ramu','ramu@gmail.com','8773268353'),
	   ('ram','ram@gmail.com','7663632939'),
	   ('rani','rani@gmail.com','9896763322');

SELECT *FROM users;

-- Inserting into posts table
INSERT INTO posts(user_id,caption,image_url)
VALUES(1,'Beautiful sunset','<http://www.example.com/sunset.jpg>'),
       (2,'My new puppy','<http://www.example.com/puppy.jpg>'),
	   (3,'Delicious pizza','<http://www.example.com/pizza.jpg>'),
	   (4,'Throwback to my vacation','<http://www.example.com/vacation.jpg>'),
	   (5,'Amazing concert','<http://www.example.com/concert.jpg>');
	   
SELECT *FROM posts; 

-- Inserting into comments table
INSERT INTO comments(post_id,user_id,comment_text)
VALUES(1,2,'wow'),
       (1,3,'nice'),
	   (2,1,'super'),
	   (2,4,'beautiful pic'),
	   (3,5,'mind blowinng'),
	   (4,1,'looking nyc'),
	   (5,3,'soo pritty');
	   
SELECT *FROM comments; 	   
	   
-- Inserting into likes table
INSERT INTO likes(post_id,user_id)
VALUES (1,2),
        (1,4),
		(2,1),
		(2,3),
		(3,5),
		(4,1),
		(4,2),
		(4,3),
		(5,4),
		(5,5);		

SELECT *FROM likes; 

-- Inserting into followers table
INSERT INTO followers(user_id,follower_user_id)
VALUES(1,2),
       (2,1),
	   (1,3),
	   (3,1),
	   (1,4),
	   (4,1),
	   (1,5),
	   (5,1);
	   
SELECT *FROM followers;	   

--update query
-- updating the caption of post_id 3
UPDATE  posts
SET caption='best pizza ever'
WHERE post_id=3;

SELECT *FROM posts; 

--joins
-- selecting all the posts where user_id is 1
SELECT *FROM posts WHERE user_id=1;

--ORDER BY
--selecting all the post and ordering them by created_at in descending order
SELECT *FROM posts
ORDER  BY created_at DESC;

--GROUP BY and HAVING 
--counting the number of likes for each post and 
--showing only the posts with more than 2 likes
SELECT p.post_id,count(l.like_id)FROM posts as p
JOIN likes as l ON p.post_id = l.post_id
GROUP BY p.post_id
HAVING count(l.like_id) >=2
;


--Aggregation Functions 
-- finding the total number of likes for all the posts
SELECT SUM(number_likes) as total_likes FROM(
SELECT p.post_id,count(l.like_id) number_likes FROM posts as p
JOIN likes as l ON p.post_id=l.post_id
GROUP BY p.post_id) AS likes_by_post;


--Subquery
--finding all the users who have commented on post_id 1
SELECT name
FROM users
WHERE user_id IN(
        SELECT user_id
	    FROM comments 
	    WHERE post_id=1
);


--Window function  
--ranking the posts based on the number of likes
WITH cte as (
SELECT p.post_id,count(l.like_id)number_likes FROM posts as p
JOIN likes as l ON p.post_id=l.post_id
GROUP BY p.post_id	
)
SELECT 
post_id,
number_likes,
RANK()OVER (ORDER BY number_likes ASC)as rank_by_likes
FROM cte;

--CTE 
--Finding all the posts and their comments  using a cte(common table expression)
WITH cte as(
SELECT p.post_id,p.caption,c.comment_text FROM posts p
LEFT JOIN comments c ON p.post_id=c.post_id
)
SELECT *FROM cte;

--Case Statement
--categorizing the posts based on the number of likes
WITH cte as(
SELECT p.post_id,count(l.like_id) number_likes FROM posts p
JOIN likes as l ON p.post_id=l.post_id
GROUP BY p.post_id	
)
SELECT
post_id,
number_likes,
CASE WHEN number_likes < 2 THEN 'low_likes'
      WHEN number_likes = 2 THEN 'few likes'
	   WHEN number_likes > 2 THEN 'lot oflikes'
ELSE 'no data'
END like_category
FROM cte;

--Date Casting and Working with Dates
--finding all the posts created in the last month
SELECT *
FROM posts
WHERE created_at >=CAST(DATE_TRUNC ('month',CURRENT_TIMESTAMP-INTERVAL '1 month') 
						AS DATE);

--Alter query
--to modify existing table  the users table and the column email to email_to
ALTER TABLE users RENAME column email To email_to;
SELECT *FROM users;

-- finding the total number of likes for all the posts
SELECT max(number_likes) as total_likes FROM(
SELECT p.post_id,count(l.like_id) number_likes FROM posts as p
JOIN likes as l ON p.post_id=l.post_id
GROUP BY p.post_id) AS likes_by_post;

--join two tables by using cte
WITH comment_cte as(
	SELECT *FROM comments WHERE post_id=1
)
SELECT*FROM comment_cte c
JOIN posts p on c.post_id=p.post_id;

--casting datatype
SELECT post_id,user_id::int FROM comments;

	   