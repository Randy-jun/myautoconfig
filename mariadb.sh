#!/bin/bash
sudo mysql_secure_installation; 
sudo mysql --user=root < ./create_phpmyadmin_user.sql;

