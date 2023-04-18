echo -e "\e[32m....disable the my sql....\e[0m"
dnf module disable mysql -y 

echo -e "\e[32m....adding the mysql repo...\e[0m"
cp /root/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[32m....installing the community-server....\e[0m"
yum install mysql-community-server -y

echo -e "\e[32m....starting the mysql server....\e[0m"
systemctl enable mysqld
systemctl start mysqld  

echo -e "\e[32m....changing the default passwd....\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1

echo -e "\e[32m....checking the passwd....\e[0m"
mysql -uroot -pRoboShop@1
