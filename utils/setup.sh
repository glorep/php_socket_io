#!/bin/bash
apt-get install language-pack-en-base -y
locale-gen "en_US.UTF-8"
dpkg-reconfigure locales
LC_ALL=en_US.UTF-8
add-apt-repository ppa:ondrej/php-zts
apt-get update
rm /var/cache/apt/archives/lock
apt-get install php7.0-zts -y
apt-get install php7.0-zts-dev -y
apt-get install git -y
apt-get rm $1/pthreads -fr
git clone https://github.com/krakjoe/pthreads.git $1/pthreads
cd $1/pthreads
phpize
./configure
make -j8
make install
mkdir -p /etc/php/7.0-zts/conf.d/
rm pthreads.ini
touch pthreads.ini
echo "extension=pthreads.so" > /etc/php/7.0-zts/conf.d/pthreads.ini
cd /etc/php/7.0-zts/cli/conf.d
ln -s ../../conf.d/pthreads.ini
rm /var/cache/apt/archives/lock
apt-get install mysql-server -y
mysql_secure_installation
apt-get install php7.0-zts-mysql -y
apt-get install php7.0-zts-odbc -y
apt-get install php7.0-gd -y
apt-get install php7.0-dom -y
apt-get install php7.0-mysql -y
apt-get install php7.0-mbstring -y
rm $1/php_socket_io -fr
git clone https://github.com/glorep/php_socket_io.git $1/php_socket_io
mkdir $1/php_socket_io/utils/logs
chmod 777 $1/php_socket_io/* -R
mysql < $1/php_socket_io/utils/database/dump/localrep.sql -u root -p
cp $1/php_socket_io/utils/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart
apt-get install apache2 -y
apt-get install libapache2-mod-php7.0 -y
rm /var/www/html/glorep -fr
git clone https://github.com/glorep/glorep.git /var/www/html/glorep
mkdir /var/www/html/glorep/sites/default/files
mkdir /var/www/html/glorep/sites/default/files/collabrep
mkdir /var/www/html/glorep/sites/default/files/collabrep/cache
cp /var/www/html/glorep/sites/default/default.settings.php /var/www/html/glorep/sites/default/settings.php
chmod 777 /var/www/html/glorep/* -R
service apache2 restart
cp $1/php_socket_io/utils/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart

