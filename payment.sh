script=$(realpath "$0")
script_path=$(dirname "$script")

rabbit_user_passwd=$1

yum install python36 gcc python3-devel -y
useradd roboshop
rm -rf /app
mkdir /app 
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip 
cd /app 
unzip /tmp/payment.zip
pip3.6 install -r requirements.txt
sed -i -e "s|rabbit_user_passwd|$rabbit_user_passwd|"
cp $script_path/payment.service /etc/systemd/system/payment.service
systemctl daemon-reload
systemctl enable payment 
systemctl start payment