script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/comman.sh

stat_check_fuction $?

print_msg "installing the nginx server"
yum install nginx -y 

print_msg "configuring the roboshop file"
cp $script_path/roboshop.conf /etc/nginx/default.d/roboshop.conf

print_msg "set the system set up file"
systemctl enable nginx 
systemctl start nginx 

print_msg "remove the file existing the data"
rm -rf /usr/share/nginx/html/* 

print_msg "downlading the code file"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 

print_msg "unzip the code file"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
systemctl restart nginx
