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
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip 

echo -e "\e[32m.....changing the directory.....\e[0m"
cd /app

echo -e "\e[32m.....unzip the content in the app directory.....\e[0m"
unzip /tmp/cart.zip

echo -e "\e[32m.....installing the npm install.....\e[0m"
npm install

echo -e "\e[32m.....adding the service file.....\e[0m"
cp $script_path/cart.service /etc/systemd/system/cart.service

echo -e "\e[32m.....starting the service file.....\e[0m"
systemctl daemon-reload
systemctl enable cart 
systemctl start cart


