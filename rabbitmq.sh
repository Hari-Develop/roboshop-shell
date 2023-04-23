script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/comman.sh
rabbit_user_passwd=$1

if [ -z "$rabbit_user_passwd" ]
then
    echo "input password is not provided"
    exit
fi

print_msg "adding the rpm package"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file

print_msg "adding the installing the erlang"
yum install erlang -y &>>$log_file

print_msg "installing the package of rabbit mq server"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file

print_msg "installing the rabbit mq server"
yum install rabbitmq-server -y &>>$log_file

print_msg "enabling the rabbit mq server usong the system ctl"
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file

print_msg "adding user and setupping the permission"
rabbitmqctl add_user ${app_user} ${rabbit_user_passwd} &>>$log_file
rabbitmqctl set_permissions -p / ${app_user} ".*" ".*" ".*" &>>$log_file
