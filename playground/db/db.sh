#!bin/sh
#稼働はalpinの上

# make a directory where mariadb can acces the mysqld.sock socket file
# change the ownership, because we will run the daemon as the mysql user
mkdir /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

# change the config file so TCP/IP is no longer disabled
#
sed -i "s/skip-networking/skip-networking=0/g" /etc/my.cnf.d/mariadb-server.cnf

# change the config file so that bind-address=0.0.0.0 is no longer commented out (this means mariadb can now bind to any address)
sed -i "s/#bind-address/bind-address/g" /ect/my.cnf.d/mariadb-server.cnf
#ect/my.cnf.d/mariadb-server.cnf ここにあるバインドアドレスの設定を変更するようなコード

# check if the system tables where already created, in which case the directory /var/lib/mysql/mysql will exist.
# If it does not exist, install the system tables and store the data in /var/lib/mysql
#/var/lib/mysql/mysql が存在しない場合＝データベースが初期化されていない場合
if [ ! -d "/var/lib/mysql/mysql" ]; then

        # init database
        mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql

fi
#データベースがない場合に行うことである、つまり/var/lib/mysqlこいつがバインドされていればデータベースの情報が存在し続ける

# check if the wordpress database exists. If not yet, create a temporary create_db.sql script to (1) secure the database and (2) add the wordpress database.
if [ ! -d "/var/lib/mysql/wordpress" ]; then

        cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM     mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';
GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
        # run the mysql daemon with bootstrap so that it executes the .sql file
        /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql

        # remove the .sql file that contains the credentials
        rm -f /tmp/create_db.sql
fi