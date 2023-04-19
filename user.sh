script=$(realpath "$0")
script_path=$(dirname "$script")
source/comman.sh

print_msg "installing the repo for the node"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_msg "installing the nodejs"
yum install nodejs -y

print_msg "add application user"
useradd roboshop

print_msg "making the directory"
rm -rf /app
mkdir /app 

print_msg "Downloading the content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip 

print_msg "changing the directory"
cd /app

print_msg "unzip the content in the app directory"
unzip /tmp/user.zip

print_msg "installing the npm install"
npm install

print_msg "adding the service file"
cp $script_path/user.service /etc/systemd/system/user.service

print_msg "starting the service file"
systemctl daemon-reload
systemctl enable user 
systemctl start user

print_msg "adding the mongo.repo"
cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

print_msg "adding the mongo-shell-client"
yum install mongodb-org-shell -y

print_msg "adding loading scheme"
mongo --host mongodb-dev.unlockers.online </app/schema/user.js



