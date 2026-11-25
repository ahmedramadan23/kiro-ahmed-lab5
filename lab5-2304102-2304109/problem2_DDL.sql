-- Lab 5 - Problem 2: database library (Lab 4 tables + REVIEW + bonus view book_details)
-- Run: mysql -u root -p < problem2_DDL.sql      (MySQL 8.0.31 or later)

DROP DATABASE IF EXISTS library;
CREATE DATABASE library;
USE library;

CREATE TABLE author (
    author_id INT          NOT NULL AUTO_INCREMENT,
    name      VARCHAR(100) NOT NULL,
    country   VARCHAR(50),
    PRIMARY KEY (author_id)
);

CREATE TABLE publisher (
    publisher_id INT          NOT NULL AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL,
    country      VARCHAR(50),
    PRIMARY KEY (publisher_id)
);
CREATE TABLE category (
    category_id INT         NOT NULL AUTO_INCREMENT,
    name        VARCHAR(50) NOT NULL,
    PRIMARY KEY (category_id)
);

CREATE TABLE book (
    book_id      INT           NOT NULL AUTO_INCREMENT,
    title        VARCHAR(200)  NOT NULL,
    price        DECIMAL(10,2) NOT NULL,
    publish_year INT,
    author_id    INT           NOT NULL,
    publisher_id INT           NOT NULL,
    category_id  INT           NOT NULL,
    PRIMARY KEY (book_id),
    FOREIGN KEY (author_id)    REFERENCES author (author_id)
        ON DELETE CASCADE,
    FOREIGN KEY (publisher_id) REFERENCES publisher (publisher_id),
    FOREIGN KEY (category_id)  REFERENCES category (category_id)
);

CREATE TABLE member (
    member_id INT          NOT NULL AUTO_INCREMENT,
    name      VARCHAR(100) NOT NULL,
    email     VARCHAR(255) NOT NULL,
    join_date DATE         NOT NULL,
    PRIMARY KEY (member_id),
    UNIQUE (email)
);

CREATE TABLE loan (
    loan_id     INT  NOT NULL AUTO_INCREMENT,
    book_id     INT  NOT NULL,
    member_id   INT  NOT NULL,
    loan_date   DATE NOT NULL,
    return_date DATE,                      -- NULL while the book is borrowed
    PRIMARY KEY (loan_id),
    FOREIGN KEY (book_id)   REFERENCES book (book_id)
        ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES member (member_id)
);

-- New in Lab 5: a member gives a book a rating from 1 to 5 (once per book)
CREATE TABLE review (
    review_id   INT     NOT NULL AUTO_INCREMENT,
    book_id     INT     NOT NULL,
    member_id   INT     NOT NULL,
    rating      TINYINT NOT NULL,
    review_date DATE    NOT NULL,
    PRIMARY KEY (review_id),
    FOREIGN KEY (book_id)   REFERENCES book (book_id)
        ON DELETE CASCADE,                 -- a deleted book loses its reviews
    FOREIGN KEY (member_id) REFERENCES member (member_id),
    CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT uq_review_book_member UNIQUE (book_id, member_id)
);

-- BONUS: view book_details = BOOK + AUTHOR + PUBLISHER + CATEGORY (the catalogue of Lab 4).
-- It is used by F2.1 and F2.3 in problem2_Queries.sql instead of repeating the joins.
CREATE VIEW book_details AS
SELECT b.book_id, b.title, b.price, b.publish_year,
       a.author_id,    a.name AS author,    a.country AS author_country,
       p.publisher_id, p.name AS publisher, p.country AS publisher_country,
       c.category_id,  c.name AS category
FROM book b
JOIN author a    ON b.author_id    = a.author_id
JOIN publisher p ON b.publisher_id = p.publisher_id
JOIN category c  ON b.category_id  = c.category_id;
