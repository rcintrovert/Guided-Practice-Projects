USE instagram_clone; 
SELECT DATABASE();

/* Want to reward users who have been around 
the longest. Find the 5 oldest users.*/
SELECT 
    username, created_at
FROM
    users
ORDER BY created_at
LIMIT 5;

/* What day of the week do most users register on?
We need to figure out when to schedule an ad
campaign.*/
SELECT 
    DAYNAME(created_at) AS day,
    COUNT(*) AS total
FROM
    users
GROUP BY day
ORDER BY total DESC
LIMIT 2;

/* We want to target our inactive users with an
email campaign. Find the users who have never 
posted a photo.*/
SELECT 
    username
FROM
    users
        LEFT JOIN
    photos ON users.id = photos.user_id
WHERE photos.user_id IS NULL;

/* We're running a new contest to see who can
get the most likes on a single photo. Who won?*/
SELECT 
    username, photos.id, photos.image_url, COUNT(*) AS total
FROM
    photos
        INNER JOIN
    likes ON likes.photo_id = photos.id
        INNER JOIN
    users ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 5;

/* Investors want to know how many times does
the average user post?*/
SELECT 
    ((SELECT 
            COUNT(*)
        FROM
            photos) / (SELECT 
            COUNT(*)
        FROM
            users)) AS avg;
            
SELECT 
    (COUNT(image_url) / COUNT(DISTINCT username)) AS avg
FROM
    users
        LEFT JOIN
    photos ON users.id = photos.user_id;

/* A brand wants to know which hashtags to use in a post.
What are the top 5 most commonly used hashtags?*/
SELECT 
    tag_name, COUNT(*) AS amt_photos_tagged
FROM
    photo_tags
        JOIN
    tags ON photo_tags.tag_id = tags.id
GROUP BY tag_name
ORDER BY amt_photos_tagged DESC
LIMIT 5;

SELECT tags.tag_name, 
       Count(*) AS total 
FROM   photo_tags 
       JOIN tags 
         ON photo_tags.tag_id = tags.id 
GROUP  BY tags.id 
ORDER  BY total DESC 
LIMIT  5; 

/* We have a small problem with bots on our site.
Find the users who have liked every single photo on 
the site.*/
SELECT username, 
       Count(*) AS num_likes 
FROM   users 
       INNER JOIN likes 
               ON users.id = likes.user_id 
GROUP  BY likes.user_id 
HAVING num_likes = (SELECT Count(*) 
                    FROM   photos); 
