echo -e "\e[32m....installing the maven....\e[0m"
yum install maven -y

echo -e "\e[32m....adding the application user....\e[0m"
useradd roboshop

echo -e "\e[32m....creating the directory....\e[0m"
rm -rf /app
mkdir /app 

echo -e "\e[32m....downloading the application code....\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip 

echo -e "\e[32m....changing the app directory....\e[0m"
cd /app 

echo -e "\e[32m....unzip the content....\e[0m"
unzip /tmp/shipping.zip

echo -e "\e[32m....cleaning the maven....\e[0m"
mvn clean package 
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[32m....loading the service file....\e[0m"
cp /root/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[32m....start the shipping service file....\e[0m"
systemctl daemon-reload
systemctl enable shipping 
systemctl start shipping

echo -e "\e[32m....installing the mysql....\e[0m"
yum install mysql -y 

echo -e "\e[32m....loading the scheme....\e[0m"
mysql -h mysql-dev.unlockers.online -uroot -pRoboShop@1 < /app/schema/shipping.sql 

systemctl restart shipping

