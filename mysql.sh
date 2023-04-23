script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/comman.sh
mysql_root_passwd=$1

if [ -z "$mysql_root_passwd" ] ; then
    echo "input of mysql password is missing"
    exit
fi

print_msg "disable the my sql"
dnf module disable mysql -y &>>$log_file
stat_check_fuction $?

print_msg "adding the mysql repo"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
stat_check_fuction $?


print_msg "installing the community-server"
yum install mysql-community-server -y &>>$log_file
stat_check_fuction $?


print_msg "starting the mysql server"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
stat_check_fuction $?


print_msg "changing the default passwd"
mysql_secure_installation --set-root-pass ${mysql_root_passwd} &>>$log_file 
stat_check_fuction $?


