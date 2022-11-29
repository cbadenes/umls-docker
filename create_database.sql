DROP DATABASE IF EXISTS umls;
DROP DATABASE IF EXISTS umlsinterfaceindex;
CREATE DATABASE IF NOT EXISTS umls CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE DATABASE IF NOT EXISTS umlsinterfaceindex CHARACTER SET utf8 COLLATE utf8_unicode_ci;
# CREATE USER ‘root’@‘localhost’ IDENTIFIED BY '';
#GRANT ALL PRIVILEGES ON umls.* TO 'root'@'localhost' IDENTIFIED BY '';
#GRANT ALL PRIVILEGES ON umlsinterfaceindex.* TO 'root'@'localhost' IDENTIFIED BY '';
USE umls;
