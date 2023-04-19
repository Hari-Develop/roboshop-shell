script=$(realpath "$0")
script_path=$(dirname "$script")

yum install golang -y
useradd roboshop
rm -rf /app
mkdir /app 
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip 
cd /app 
unzip /tmp/dispatch.zip
go mod init dispatch
go get 
go build
cp $script_path/dispatch.service /etc/systemd/system/dispatch.service
systemctl daemon-reload
systemctl enable dispatch 
systemctl start dispatch
