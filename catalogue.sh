echo -e "\e[32m.......installing nodejs package.......\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m.......installing nodejs.......\e[0m"
yum install nodejs -y

echo -e "\e[32m.......adding roboshop user.......\e[0m"
useradd roboshop

echo -e "\e[32m.......creating application directory.......\e[0m"
mkdir /app 

echo -e "\e[32m.......downloading the application code.......\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip 

echo -e "\e[32m.......changing to application directory.......\e[0m"
rm -rf /app
cd /app 

echo -e "\e[32m.......unzip the appication code.......\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[32m.......installing npm .......\e[0m"
npm install

echo -e "\e[32m.......copying the service file.......\e[0m"
cp /root/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[32m.......reloading the service of catalogue.......\e[0m"
systemctl daemon-reload
systemctl enable catalogue 

echo -e "\e[32m.......restarting the catalogue.......\e[0m"
systemctl restart catalogue

echo -e "\e[32m.......configuring the mongo.repo.......\e[0m"
cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m.......installing the mongodb shell.....\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[32m.......loading the scheme......\e[0m"
mongo --host mongodb-dev.unlockers.online </app/schema/catalogue.js


