echo -e "\e[32m >>>>>...downloading the nodejs pacakage....>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m >>>>>...installing nodejs pacakage....>>>>\e[0m"
yum install nodejs -y

echo -e "\e[32m >>>>>...adding the application user....>>>>\e[0m"
useradd roboshop

echo -e "\e[32m >>>>>...creating the directory....>>>>\e[0m"
mkdir /app 

echo -e "\e[32m >>>>>...downloading the app code....>>>>\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip 

echo -e "\e[32m >>>>>...changing the into app directory....>>>>\e[0m"
cd /app 

echo -e "\e[32m >>>>>...unziping the content....>>>>\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[32m >>>>>...installing npm....>>>>\e[0m"
npm install

echo -e "\e[32m >>>>>...loading the service file....>>>>\e[0m"
cp /root/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[32m >>>>>...starting the catalogue....>>>>\e[0m"
systemctl daemon-reload
systemctl enable catalogue 
systemctl restart catalogue

echo -e "\e[32m >>>>>...installing mongo client repo....>>>>\e[0m"
cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m >>>>>...installing mongo client....>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[32m >>>>>...loading the scheme....>>>>\e[0m"
mongo --host mongodb-dev.unlockers.online </app/schema/catalogue.js