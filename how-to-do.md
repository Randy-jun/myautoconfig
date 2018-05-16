# 环境配置
## 1.软件版本
+ MariaDB (Distrib 10.1.24-MariaDB)
+ Nginx (nginx/1.13.3)
+ PHP7 (7.1.6-2 (cli))
+ VUE
+ bootstrap 
+ Deepin [deepin-15.5-amd64.iso](https://mirrors.tuna.tsinghua.edu.cn/deepin-cd/15.5/deepin-15.5-amd64.iso)

## 2. Deepin15.5安装完成
+ //sudo password root(设置root用户密码)
+ //sudo apt update && sudo apt -full upgrade(更新系统)
+ 使用系统自带工具更新
+   sudo apt install git(下载安装git)
  
## 3. MariaDB数据库安装
+ sudo apt install mariadb-server-10.1 mariadb-client-10.1
+ 启动数据库
+ sudo systemctl start mariadb
+ 设置开机启动
+ sudo systemctl enable mariadb
+ 配置数据库
+ sudo mysql_secure_installation
+ （Mariadb 和 Mysql 5.7之后root只能通过sudo mysql -uroot -p 登录）


## 4. Nginx服务器安装
+ sudo apt install nginx
+ 启动WEB服务器
+ sudo systemctl start nginx
+ 设置开机启动
+ sudo systemctl enable nginx

### Nginx配置
+ sudo vim /etc/nginx/sites-available/default 
+ 1. 添加index.php
+ 2. 修改
```
	#location ~ \.php$ {\n
	#        include snippets/fastcgi-php.conf;
	#        # With php-fpm (or other unix sockets):
	#        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
	#        # With php-cgi (or other tcp sockets):
	#        fastcgi_pass 127.0.0.1:9000;
	#    }
```
成为

```
    location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            # With php-fpm (or other unix sockets):
            fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
            # With php-cgi (or other tcp sockets):
            # fastcgi_pass 127.0.0.1:9000;
        }
```
+ 3. 添加虚拟域名

## 5. php7安装
+ sudo apt install php7.1-dev php7.1-fpm curl(用来安装composer) php7.1-mbstring php7.1-mysql

### php配置
+ sudo vim /etc/php/7.1/cli/php.ini
+ ***; cgi.fix_pathinfo=1*** 改为 ***cgi.fix_pathinfo=0***

### php-fpm
+ 启动php-fpm
+ sudo systemctl start php7.1-fpm
+ 设置开机启动
+ sudo systemctl enable php7.1-fpm

+ php插件composer安装
+ curl -sS https://getcomposer.org/installer | php
+ sudo mv composer.phar /usr/local/bin/composer
+ 配置composer使用国内镜像
+ composer config -g repo.packagist composer https://packagist.phpcomposer.com
+ 更新composer
+ composer self-update


## 6. Thinkphp5安装
```
cd ~
composer create-project topthink/think=5.1.* $HOME/tp5  --prefer-dist;
sudo ln -s ~/tp5/ /var/www/;
```

## 7. phpmyadmin安装
1. 先安装必装软件sudo apt install php7.1-xml php7.1-curl phpunit phpunit-selenium
2. 再安装推荐软件sudo apt install php-invoker php-bz2 php-zip php-opcache php-gd php-gmp php-libsodium php-xdebug php-soap
3. composer create-project phpmyadmin/phpmyadmin $HOME/phpmyadmin;
4. sudo ln -s $HOME/phpmyadmin/ /var/www/;
5. 为Mariadb添加phpmyadmin用户并分配权限
```
sudo $HOME/myautoconfig/mariadb.sh;
```
+ mariadb.sh
```
#!/bin/bash
# sudo mysql_secure_installation; -- (设置mysql可以先不用)
sudo mysql --user=root < ./create_phpmyadmin_user.sql;
create_phpmyadmin_user.sql
```
```
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
```
## 7. 修改/etc/hosts文件
```
sudo $HOME/myautoconfig/host_wrtie.sh;
```
+ host_write.sh
```
#!/bin/bash
echo "127.0.0.1 tp5.io" >> /etc/hosts
echo "127.0.0.1 phpmyadmin.io" >> /etc/hosts
echo "127.0.0.1 test.io" >> /etc/hosts
```

## CentOS安装后部分配置
### 安装SSH
	yum update && yum install openssh
### 网络自动连接
	vi /etc/sysconfig/network-scripts/ifcfg-eth0（类似）
修改ONBOOT=yes

### 开启SSHD
	systemctl enable sshd 
	systemctl start sshd 
	sshd 防护墙 22
	firewall-cmd --zone=public --add-port=22/tcp --permanent  
	service firewalld restart  
### 无图型界面
	systemctl set-default multi-user.target