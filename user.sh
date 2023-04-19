script=$(realpath "$0")
script_path=$(dirname "$script")

echo -e "\e[32m.....installing the repo for the node.....\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m.....installing the nodejs.....\e[0m"
yum install nodejs -y

echo -e "\e[32m.....add application user.....\e[0m"
useradd roboshop

echo -e "\e[32m.....making the directory.....\e[0m"
rm -rf /app
mkdir /app 

echo -e "\e[32m.....Downloading the content.....\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip 

echo -e "\e[32m.....changing the directory.....\e[0m"
cd /app

echo -e "\e[32m.....unzip the content in the app directory.....\e[0m"
unzip /tmp/user.zip

echo -e "\e[32m.....installing the npm install.....\e[0m"
npm install

echo -e "\e[32m.....adding the service file.....\e[0m"
cp $script_path/user.service /etc/systemd/system/user.service

echo -e "\e[32m.....starting the service file.....\e[0m"
systemctl daemon-reload
systemctl enable user 
systemctl start user

echo -e "\e[32m.....adding the mongo.repo.....\e[0m"
cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m.....adding the mongo-shell-client.....\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[32m.....adding loading scheme.....\e[0m"
mongo --host mongodb-dev.unlockers.online </app/schema/user.js



