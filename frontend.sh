script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/comman.sh

print_msg "installing the nginx server"
yum install nginx -y &>>$log_file


print_msg "configuring the roboshop file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file


print_msg "remove the file existing the data"
rm -rf /usr/share/nginx/html/* &>>$log_file


print_msg "downlading the code file"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file


print_msg "unzip the code file"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip

print_msg "set the system set up file"
systemctl enable nginx &>>$log_file
systemctl start nginx &>>$log_file
systemctl restart nginx &>>$log_file

