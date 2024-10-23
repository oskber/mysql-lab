-- Book store database

DROP DATABASE IF EXISTS bookstore;
CREATE DATABASE bookstore;
USE bookstore;

CREATE TABLE author
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name  VARCHAR(255),
    birth_date DATE
);
CREATE TABLE language
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255)
);
CREATE TABLE book
(
    isbn             VARCHAR(13) PRIMARY KEY,
    title            VARCHAR(255),
    language_id      INT,
    price            DECIMAL(10, 2),
    publication_date DATE,
    author_id        INT,
    FOREIGN KEY (author_id) REFERENCES author (id),
    FOREIGN KEY (language_id) REFERENCES language (id)
);
CREATE TABLE bookstore
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    city VARCHAR(255)
);
CREATE TABLE inventory
(
    store_id INT,
    isbn     VARCHAR(13),
    amount   INT,
    PRIMARY KEY (store_id, isbn),
    FOREIGN KEY (store_id) REFERENCES bookstore (id),
    FOREIGN KEY (isbn) REFERENCES book (isbn)
);

INSERT INTO author(first_name, last_name, birth_date)
VALUES ('Sally', 'Rooney', '1991-02-20'),
       ('Colleen', 'Hoover', '1979-12-11'),
       ('Taylor', 'Jenkins Reid', '1983-12-20'),
       ('Delia', 'Owens', '1949-04-04'),
       ('Matt', 'Haig', '1975-07-03');

INSERT INTO language(name)
VALUES ('English'),
       ('Swedish');

INSERT INTO book(isbn, title, language_id, price, publication_date, author_id)
VALUES ('9780571334650', 'Normal People', 1, 150.00, '2018-08-28', 1),
       ('9781501171345', 'It Ends with Us', 1, 160.00, '2016-08-02', 2),
       ('9781524798628', 'Daisy Jones & The Six', 1, 170.00, '2019-03-05', 3),
       ('9780735219090', 'Where the Crawdads Sing', 1, 180.00, '2018-08-14', 4),
       ('9781786892737', 'The Midnight Library', 1, 190.00, '2020-08-13', 5),
        ('9781142132132', 'Intermezzo', 2, 200.00, '2024-09-01', 1);

INSERT INTO bookstore(name, city)
VALUES ('Akademibokhandeln', 'Luleå'),
       ('Hedengrens bokhandel', 'Stockholm'),
       ('Bokus', 'Göteborg');

INSERT INTO inventory(store_id, isbn, amount)
VALUES (1, '9780571334650', 100),  -- Normal People
       (1, '9781501171345', 150),  -- It Ends with Us
       (2, '9781524798628', 200),  -- Daisy Jones & The Six
       (2, '9780735219090', 180),  -- Where the Crawdads Sing
       (3, '9781786892737', 140),  -- The Midnight Library
        (1, '9781142132132', 100);  -- Intermezzo

CREATE VIEW total_author_book_value AS
SELECT CONCAT(a.first_name, ' ', a.last_name) AS name,
       YEAR(CURDATE()) - YEAR(a.birth_date)   AS age,
       COUNT(b.isbn)                          AS book_title_count,
       CONCAT(SUM(b.price * i.amount), ' kr') AS inventory_value
FROM author a
         JOIN book b ON a.id = b.author_id
         JOIN inventory i ON b.isbn = i.isbn
GROUP BY a.id;

