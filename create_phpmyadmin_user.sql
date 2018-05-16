/**********Allow access from localhost********/
use mysql;
CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY 'mysql_passwd';
GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
/******************************************/

/**********Allow access from remote********
* use mysql;
* CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY 'mysql_passwd';
* GRANT ALL PRIVILEGES ON \*.\* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION;
* FLUSH PRIVILEGES;
*/
