echo -e "\e[32m.....installing the repo for the redis.....\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[32m.....enabling the redis server.....\e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[32m.....installing the redis.....\e[0m"
yum install redis -y 

echo -e "\e[32m.....chnaging the port.....\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf

echo -e "\e[32m.....starting the redis server.....\e[0m"
systemctl enable redis 
systemctl start redis 

