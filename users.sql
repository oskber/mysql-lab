DROP USER IF EXISTS 'developer'@'%';
DROP USER IF EXISTS 'webserver'@'%';

CREATE USER 'developer'@'%' IDENTIFIED BY 'password';
CREATE USER 'webserver'@'%' IDENTIFIED BY 'password';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON bookstore.* TO 'developer'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.* TO 'webserver'@'%';

REVOKE CREATE USER, CREATE, DROP ON *.* FROM 'developer'@'%';
REVOKE CREATE USER, CREATE, DROP ON *.* FROM 'webserver'@'%';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'developer'@'%';
SHOW GRANTS FOR 'webserver'@'%';



