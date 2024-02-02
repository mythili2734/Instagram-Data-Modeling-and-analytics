SELECT *FROM comments;

CREATE TABLE posts(
	post_id SERIAL PRIMARY KEY,
	user_id INTEGER NOT NULL,
	caption TEXT,
	image_url VARCHAR(200),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(user_id)REFERENCES users(user_id)
);

-- Inserting into posts table
INSERT INTO posts(user_id,caption,image_url)
VALUES(1,'Beautiful sunset','<http://www.example.com/sunset.jpg>'),
       (2,'My new puppy','<http://www.example.com/puppy.jpg>'),
	   (3,'Delicious pizza','<http://www.example.com/pizza.jpg>'),
	   (4,'Throwback to my vacation','<http://www.example.com/vacation.jpg>'),
	   (5,'Amazing concert','<http://www.example.com/concert.jpg>');

-- Inserting into comments table
INSERT INTO comments(post_id,user_id,comment_text)
VALUES(1,2,'wow'),
       (1,3,'nice'),
	   (2,1,'super'),
	   (2,4,'beautiful pic'),
	   (3,5,'mind blowinng'),
	   (4,1,'looking nyc'),
	   (5,3,'soo pritty');
	   
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
	   
SELECT *FROM users;	   

-- updating the caption of post_id 3
SELECT *FROM posts;

UPDATE  posts
SET caption='best pizza ever'
WHERE post_id=3;

-- selecting all the posts where user_id is 1
SELECT *FROM posts WHERE user_id=1;

--selecting all the post and ordering them by created_at in descending order
SELECT *FROM posts
ORDER  BY created_at DESC;

--counting the number of likes for each post and 
--showing only the posts with more than 2 likes
SELECT p.post_id,count(l.like_id)FROM posts as p
JOIN likes as l ON p.post_id = l.post_id
GROUP BY p.post_id
HAVING count(l.like_id) >=2
;

-- finding the total number of likes for all the posts
SELECT sum(number_likes) FROM (
SELECT p.post_id,count(l.like_id)number_likes FROM posts as p
JOIN likes as l ON p.post_id = l.post_id
GROUP BY p.post_id) as likes_by_post
;

--finding all the users who have commented on post_id 1
SELECT name FROM users WHERE user_id IN(
SELECT user_id FROM comments WHERE post_id=1);

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

--Finding all the posts and their comments  using a cte(common table expression)
WITH cte as(
SELECT p.post_id,p.caption,c.comment_text FROM posts p
LEFT JOIN comments c ON p.post_id=c.post_id
)
SELECT *FROM cte;

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










	   