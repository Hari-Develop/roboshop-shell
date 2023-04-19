app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_msg (){
    echo -e "\e[32m.... $1 ....\e[0m"
}

schema_fun () {
    print_msg "adding the mongo.repo"
    cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

    print_msg "adding the mongo-shell-client"
    yum install mongodb-org-shell -y

    print_msg "adding loading scheme"
    mongo --host mongodb-dev.unlockers.online </app/schema/${component}.js
}

function_application () {
    echo -e "\e[32m.....installing the repo for the node.....\e[0m"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash

    echo -e "\e[32m.....installing the nodejs.....\e[0m"
    yum install nodejs -y

    echo -e "\e[32m.....add application user.....\e[0m"
    useradd roboshop

    echo -e "\e[32m.....making the directory.....\e[0m"
    rm -rf /app
    mkdir /app 

    echo -e "\e[32m.....Downloading the content.....\e[0m"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 

    echo -e "\e[32m.....changing the directory.....\e[0m"
    cd /app

    echo -e "\e[32m.....unzip the content in the app directory.....\e[0m"
    unzip /tmp/${component}.zip

    echo -e "\e[32m.....installing the npm install.....\e[0m"
    npm install

    echo -e "\e[32m.....adding the service file.....\e[0m"
    cp $script_path/${component}.service /etc/systemd/system/${component}.service

    echo -e "\e[32m.....starting the service file.....\e[0m"
    systemctl daemon-reload
    systemctl enable ${component} 
    systemctl start ${component}

}