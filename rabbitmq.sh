script=$(realpath "$0")
script_path=$(dirname "$script")

rabbit_user_passwd=$1

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
yum install erlang -y
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
yum install rabbitmq-server -y 
systemctl enable rabbitmq-server 
systemctl start rabbitmq-server 
rabbitmqctl add_user roboshop ${rabbit_user_passwd}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"