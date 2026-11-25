-- Lab 5 - Problem 2: the SQL of the new pages F2.1 - F2.6
-- Run: mysql -u root -p library < problem2_Queries.sql
-- F2.1 and F2.3 use the bonus view book_details (see problem2_DDL.sql).
-- The website reads this file: every query starts with a "-- F2.x" comment.

USE library;

-- F2.1  Above the average (scalar subquery): books that cost more than the library average, most expensive first
SELECT title, price,
       (SELECT ROUND(AVG(price), 2) FROM book_details) AS avg_price
FROM book_details
WHERE price > (SELECT AVG(price) FROM book_details)
ORDER BY price DESC, title;

-- F2.2 (a)  Never borrowed: the books that were never borrowed (NOT EXISTS)
SELECT b.book_id, b.title, b.price
FROM book b
WHERE NOT EXISTS (SELECT * FROM loan l WHERE l.book_id = b.book_id)
ORDER BY b.title;

-- F2.2 (b)  Never borrowed: the members who never borrowed a book (NOT EXISTS)
SELECT m.member_id, m.name, m.email
FROM member m
WHERE NOT EXISTS (SELECT * FROM loan l WHERE l.member_id = m.member_id)
ORDER BY m.name;

-- F2.2 (c)  Check of (a) with the LEFT JOIN of Lab 4: the same books
SELECT b.book_id, b.title, b.price
FROM book b LEFT JOIN loan l ON l.book_id = b.book_id
WHERE l.loan_id IS NULL
ORDER BY b.title;

-- F2.2 (d)  Check of (b) with the LEFT JOIN of Lab 4: the same members
SELECT m.member_id, m.name, m.email
FROM member m LEFT JOIN loan l ON l.member_id = m.member_id
WHERE l.loan_id IS NULL
ORDER BY m.name;

-- F2.3 (a)  Best of the category (correlated subquery): the most expensive book of each category
SELECT d.category, d.title, d.price
FROM book_details d
WHERE d.price = (SELECT MAX(x.price)
                 FROM book_details x
                 WHERE x.category_id = d.category_id)
ORDER BY d.category, d.title;

-- F2.3 (b)  Best of the category (correlated subquery): books that cost more than the average price of their own category
SELECT d.category, d.title, d.price,
       (SELECT ROUND(AVG(x.price), 2)
        FROM book_details x
        WHERE x.category_id = d.category_id) AS category_avg
FROM book_details d
WHERE d.price > (SELECT AVG(x.price)
                 FROM book_details x
                 WHERE x.category_id = d.category_id)
ORDER BY d.category, d.price DESC;

-- F2.4 (a)  Active members (derived table): members with more loans than the average per member (members with 0 loans count too)
SELECT t.member_id, t.name, t.loans, ROUND(a.avg_loans, 2) AS avg_loans
FROM (SELECT m.member_id, m.name, COUNT(l.loan_id) AS loans
      FROM member m LEFT JOIN loan l ON l.member_id = m.member_id
      GROUP BY m.member_id, m.name) t
CROSS JOIN (SELECT AVG(c.loans) AS avg_loans
            FROM (SELECT COUNT(l.loan_id) AS loans
                  FROM member m LEFT JOIN loan l ON l.member_id = m.member_id
                  GROUP BY m.member_id) c) a
WHERE t.loans > a.avg_loans
ORDER BY t.loans DESC, t.name;

-- F2.4 (b)  Active members (EXISTS): authors who have at least one book that was borrowed
SELECT a.author_id, a.name, a.country
FROM author a
WHERE EXISTS (SELECT *
              FROM book b JOIN loan l ON l.book_id = b.book_id
              WHERE b.author_id = a.author_id)
ORDER BY a.name;

-- F2.5 (a)  Reviews (LEFT JOIN, CASE, COALESCE): every book with its number of reviews, its average rating (0 if none) and a label
SELECT b.book_id, b.title,
       COUNT(r.review_id) AS reviews,
       ROUND(COALESCE(AVG(r.rating), 0), 2) AS avg_rating,
       CASE
           WHEN COUNT(r.review_id) = 0 THEN 'No review'
           WHEN AVG(r.rating) >= 4.5   THEN 'Excellent'
           WHEN AVG(r.rating) >= 3.5   THEN 'Good'
           ELSE 'Fair'
       END AS label
FROM book b LEFT JOIN review r ON r.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY avg_rating DESC, b.title;

-- F2.5 (b)  Reviews (HAVING): books whose average rating is higher than the average of all the ratings
SELECT b.book_id, b.title,
       COUNT(r.review_id) AS reviews,
       ROUND(AVG(r.rating), 2) AS avg_rating,
       (SELECT ROUND(AVG(rating), 2) FROM review) AS all_ratings_avg
FROM book b JOIN review r ON r.book_id = b.book_id
GROUP BY b.book_id, b.title
HAVING AVG(r.rating) > (SELECT AVG(rating) FROM review)
ORDER BY avg_rating DESC, b.title;

-- F2.6 (a)  Countries and people (UNION): the countries of the authors and of the publishers, each country once
SELECT country FROM author
UNION
SELECT country FROM publisher
ORDER BY country;

-- F2.6 (b)  Countries and people (INTERSECT): the countries that have both an author and a publisher
SELECT country FROM author
INTERSECT
SELECT country FROM publisher
ORDER BY country;

-- F2.6 (c)  Countries and people (EXCEPT): the countries that have an author but no publisher
SELECT country FROM author
EXCEPT
SELECT country FROM publisher
ORDER BY country;

-- F2.6 (d)  Countries and people (UNION): one list with the names of the authors and of the members
SELECT name, 'Author' AS type FROM author
UNION
SELECT name, 'Member' AS type FROM member
ORDER BY name;
