script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/comman.sh
mysql_root_passwd=$1

if [ -z "$mysql_root_passwd" ] ; then
    echo "input of mysql password is missing"
    exit
fi

print_msg "disable the my sql"
dnf module disable mysql -y 
stat_check_fuction $?

print_msg "adding the mysql repo"
cp $script_path/mysql.repo /etc/yum.repos.d/mysql.repo
stat_check_fuction $?


print_msg "installing the community-server"
yum install mysql-community-server -y
stat_check_fuction $?


print_msg "starting the mysql server"
systemctl enable mysqld
systemctl start mysqld
stat_check_fuction $?


print_msg "changing the default passwd"
mysql_secure_installation --set-root-pass ${mysql_root_passwd}
stat_check_fuction $?


print_msg "checking the passwd"
mysql -uroot -p${mysql_root_passwd}
stat_check_fuction $?
