USE library;

-- BONUS: the view book_details (created in problem2_DDL.sql) joins book, author, publisher and
-- category, so it shows the rows inserted below: 10 books, each with its author, publisher and category.
-- Run this file after problem2_DDL.sql.

-- 5 authors: two from Egypt, two from the UK; author 5 has no books
-- (Japan has an author and no publisher -> F2.6 (c))
INSERT INTO author (author_id, name, country) VALUES
    (1, 'Naguib Mahfouz',  'Egypt'),
    (2, 'Taha Hussein',    'Egypt'),
    (3, 'Agatha Christie', 'United Kingdom'),
    (4, 'George Orwell',   'United Kingdom'),
    (5, 'Haruki Murakami', 'Japan');

-- 3 publishers (Egypt and United Kingdom match some authors)
INSERT INTO publisher (publisher_id, name, country) VALUES
    (1, 'Dar El Shorouk', 'Egypt'),
    (2, 'Penguin Books',  'United Kingdom'),
    (3, 'Harper Collins', 'United States');

-- 3 categories
INSERT INTO category (category_id, name) VALUES
    (1, 'Fiction'),
    (2, 'Mystery'),
    (3, 'History');

-- 10 books (book 6 costs 18.25 -> between 15 and 20; books 7 and 10 are never borrowed)
-- Lab 5: the average price is 13.75 -> books 1, 3, 4, 6 and 10 cost more than the average;
--        the categories have books of different prices (Fiction: 9.99 .. 16.75)
INSERT INTO book (book_id, title, price, publish_year, author_id, publisher_id, category_id) VALUES
    (1,  'Palace Walk',                  14.50, 1956, 1, 1, 1),
    (2,  'Midaq Alley',                  12.00, 1947, 1, 1, 1),
    (3,  'Children of Gebelawi',         16.75, 1959, 1, 1, 1),
    (4,  'The Days',                     15.50, 1929, 2, 1, 3),
    (5,  'Murder on the Orient Express', 11.99, 1934, 3, 2, 2),
    (6,  'And Then There Were None',     18.25, 1939, 3, 2, 2),
    (7,  'The ABC Murders',              10.50, 1936, 3, 3, 2),
    (8,  '1984',                         13.00, 1949, 4, 2, 1),
    (9,  'Animal Farm',                   9.99, 1945, 4, 2, 1),
    (10, 'Homage to Catalonia',          14.99, 1938, 4, 3, 3);

-- 5 members (member 5 has no loans)
INSERT INTO member (member_id, name, email, join_date) VALUES
    (1, 'Sara Ali',     'sara@mail.com',    '2026-01-10'),
    (2, 'Omar Hassan',  'omar@mail.com',    '2026-02-15'),
    (3, 'Mona Said',    'mona@mail.com',    '2026-03-20'),
    (4, 'Youssef Adel', 'youssef@mail.com', '2026-05-05'),
    (5, 'Laila Karim',  'laila@mail.com',   '2026-06-30');

-- 12 loans (return_date NULL = not returned yet: loans 3, 7, 9, 12)
-- Lab 5: the average is 12 / 5 = 2.4 loans per member -> members 1 (5 loans) and 2 (3 loans) are above it
INSERT INTO loan (loan_id, book_id, member_id, loan_date, return_date) VALUES
    (1,  1, 1, '2026-09-01', '2026-09-10'),
    (2,  1, 2, '2026-09-12', '2026-09-20'),
    (3,  1, 3, '2026-10-01', NULL),
    (4,  5, 1, '2026-09-05', '2026-09-15'),
    (5,  5, 2, '2026-09-25', '2026-10-02'),
    (6,  8, 1, '2026-09-15', '2026-09-22'),
    (7,  8, 4, '2026-10-03', NULL),
    (8,  2, 2, '2026-09-18', '2026-09-30'),
    (9,  6, 3, '2026-10-05', NULL),
    (10, 3, 1, '2026-10-08', '2026-10-15'),
    (11, 4, 4, '2026-10-10', '2026-10-20'),
    (12, 9, 1, '2026-10-12', NULL);

-- Lab 5: 10 reviews (at least 8 required); every reviewer borrowed the book.
--  * books 4, 7 and 10 have no review (label 'No review')
--  * books with 2 reviews of different ratings: book 1 (5, 4), book 5 (5, 4), book 8 (4, 3)
--  * the average of all the ratings is 37 / 10 = 3.70 -> books 1 (4.5), 5 (4.5) and 3 (4.0) are above it
--  * labels: Excellent = books 1, 5 | Good = books 3, 8 | Fair = books 2, 6, 9
INSERT INTO review (review_id, book_id, member_id, rating, review_date) VALUES
    (1,  1, 1, 5, '2026-09-12'),
    (2,  1, 2, 4, '2026-09-22'),
    (3,  5, 1, 5, '2026-09-17'),
    (4,  5, 2, 4, '2026-10-04'),
    (5,  8, 1, 4, '2026-09-24'),
    (6,  8, 4, 3, '2026-10-06'),
    (7,  2, 2, 3, '2026-10-01'),
    (8,  6, 3, 2, '2026-10-08'),
    (9,  3, 1, 4, '2026-10-16'),
    (10, 9, 1, 3, '2026-10-20');
