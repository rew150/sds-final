#!/bin/bash
# fail the pipeline if fail only once
set -euxo pipefail

mysql -sfu root <<EOS
-- delete anonymous user
DELETE FROM mysql.user WHERE User='';
-- delete remote root
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- drop database test
DROP DATABASE IF EXISTS test;
-- purge other resources
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
-- create database user
GRANT ALL PRIVILEGES ON ${database_name}.* TO '${database_user}'@'localhost' IDENTIFIED BY '${database_pass}';
GRANT ALL PRIVILEGES ON ${database_name}.* TO '${database_user}'@'%'         IDENTIFIED BY '${database_pass}';
-- flush
FLUSH PRIVILEGES;
EOS

export MYSQL_PWD=${database_pass}

mysql -sfu ${database_user} <<EOS
-- create database
CREATE DATABASE IF NOT EXISTS ${database_name} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
EOS

cat <<EOS >> /etc/mysql/my.cnf
[mysqld]
skip-networking=0
skip-bind-address
EOS

systemctl restart mariadb
