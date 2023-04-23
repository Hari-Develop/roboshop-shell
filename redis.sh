script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/comman.sh


print_msg "installing the repo for the redis"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
stat_check_fuction $?

print_msg "enabling the redis server"
dnf module enable redis:remi-6.2 -y &>>$log_file
stat_check_fuction $?

print_msg "installing the redis"
yum install redis -y &>>$log_file
stat_check_fuction $?


print_msg "chnaging the port"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf &>>$log_file
stat_check_fuction $?


print_msg "starting the redis server"
systemctl enable redis &>>$log_file
systemctl start redis &>>$log_file
stat_check_fuction $? 

