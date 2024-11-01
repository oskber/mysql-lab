-- Bookstore database

DROP DATABASE IF EXISTS bookstore;
CREATE DATABASE bookstore;
USE bookstore;
DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS language;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS bookstore;
DROP TABLE IF EXISTS inventory;
DROP VIEW IF EXISTS total_author_book_value;


CREATE TABLE author
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name  VARCHAR(255) NOT NULL,
    birth_date DATE         NOT NULL
);
CREATE TABLE language
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL
);
CREATE TABLE book
(
    isbn             VARCHAR(13) PRIMARY KEY,
    title            VARCHAR(255)   NOT NULL,
    language_id      INT            NOT NULL,
    price            DECIMAL(10, 2) NOT NULL,
    publication_date DATE           NOT NULL,
    author_id        INT            NOT NULL,
    FOREIGN KEY (author_id) REFERENCES author (id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES language (id)
);

CREATE TABLE bookstore
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL
);
CREATE TABLE inventory
(
    store_id INT         NOT NULL,
    isbn     VARCHAR(13) NOT NULL,
    amount   INT         NOT NULL,
    PRIMARY KEY (store_id, isbn),
    FOREIGN KEY (store_id) REFERENCES bookstore (id),
    FOREIGN KEY (isbn) REFERENCES book (isbn)
);

CREATE TABLE IF NOT EXISTS inventory_log
(
    log_id      INT PRIMARY KEY AUTO_INCREMENT,
    store_id    INT         NOT NULL,
    isbn        VARCHAR(13) NOT NULL,
    amount      INT         NOT NULL,
    inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER after_inventory_insert_log
    AFTER INSERT
    ON inventory
    FOR EACH ROW
BEGIN
    INSERT INTO inventory_log (store_id, isbn, amount)
    VALUES (NEW.store_id, NEW.isbn, NEW.amount);
END //

DELIMITER ;

INSERT INTO bookstore(name, city)
VALUES ('Akademibokhandeln', 'Luleå'),
       ('Hedengrens bokhandel', 'Stockholm'),
       ('Bokus', 'Göteborg');

INSERT INTO author(first_name, last_name, birth_date)
VALUES ('Sally', 'Rooney', '1991-02-20'),
       ('Colleen', 'Hoover', '1979-12-11'),
       ('Taylor', 'Jenkins Reid', '1983-12-20'),
       ('Delia', 'Owens', '1949-04-04'),
       ('Matt', 'Haig', '1975-07-03'),
        ('Jenny', 'Hedström', '1987-03-06');

INSERT INTO language(name)
VALUES ('English'),
       ('Swedish');

INSERT INTO book(isbn, title, language_id, price, publication_date, author_id)
VALUES ('9780571334650', 'Normal People', 1, 150.00, '2018-08-28', 1),
       ('9781501171345', 'It Ends with Us', 1, 160.00, '2016-08-02', 2),
       ('9781524798628', 'Daisy Jones & The Six', 1, 170.00, '2019-03-05', 3),
       ('9780735219090', 'Where the Crawdads Sing', 1, 180.00, '2018-08-14', 4),
       ('9781786892737', 'The Midnight Library', 1, 190.00, '2020-08-13', 5),
       ('9781142132132', 'Intermezzo', 2, 200.00, '2024-09-01', 1),
       ('9712345677898', 'Laimo och Raggis och det färgsprakande godisträdet', 2, 200.00, '2024-09-01', 6);



INSERT INTO inventory(store_id, isbn, amount)
VALUES (1, '9780571334650', 100), -- Normal People
       (1, '9781501171345', 150), -- It Ends with Us
       (2, '9781524798628', 200), -- Daisy Jones & The Six
       (2, '9780735219090', 180), -- Where the Crawdads Sing
       (3, '9781786892737', 140), -- The Midnight Library
       (1, '9781142132132', 100), -- Intermezzo
       (1, '9712345677898', 100); -- Laimo och Raggis Det färgsprakande godisträdet

DROP VIEW IF EXISTS total_author_book_value;

CREATE VIEW total_author_book_value AS
SELECT CONCAT(author.first_name, ' ', author.last_name)  AS name,
       YEAR(CURDATE()) - YEAR(author.birth_date)         AS age,
       COUNT(book.isbn)                                  AS book_title_count,
       CONCAT(SUM(book.price * inventory.amount), ' kr') AS inventory_value
FROM author
         JOIN
     book ON author.id = book.author_id
         JOIN
     inventory ON book.isbn = inventory.isbn
GROUP BY author.id;


