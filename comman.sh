app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_msg (){
    echo -e "\e[32m.... $1 ....\e[0m"
}



schema_fun () {
    if ["$schema_fun" == "mongo"]
    then
        print_msg "adding the mongo.repo"
        cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

        print_msg "adding the mongo-shell-client"
        yum install mongodb-org-shell -y

        print_msg "adding loading scheme"
        mongo --host mongodb-dev.unlockers.online </app/schema/${component}.js
    fi

    if ["$schema_fun" == "mysql"]
    then
        print_msg "installing the mysql"
        yum install mysql -y 

        print_msg "loading the scheme"
        mysql -h mysql-dev.unlockers.online -uroot -p${mysql_root_passwd} < /app/schema/shipping.sql 
    fi
}



funct_prereq () {
    print_msg "add application user"  
    useradd ${app_user}

    print_msg "making the directory"
    rm -rf /app
    mkdir /app 

    print_msg "Downloading the content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 

    print_msg "changing the directory"
    cd /app

    print_msg "unzip the content in the app directory"
    unzip /tmp/${component}.zip 
}

func_systemd_setup () {
    print_msg "adding the service file"
    cp $script_path/${component}.service /etc/systemd/system/${component}.service

    print_msg "starting the system"
    systemctl daemon-reload
    systemctl enable ${component} 
    systemctl start ${component}
    systemctl restart shipping
}

function_nodejs () {
    print_msg "installing the repo for the node"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash

    print_msg "installing the nodejs"
    yum install nodejs -y

    funct_prereq

    print_msg "installing the npm install"
    npm install

    schema_fun

    func_systemd_setup
}



func_java () {
    print_msg "installing the maven"
    yum install maven -y

    if [$? -eq 0]
    then 
        echo -e "\e[32m...SUCCESS...\e[0m"
    else
        echo -e "\e[31m...failuer...\e[0m"
    fi

    funct_prereq

    print_msg "cleaning the maven"
    mvn clean package 
    mv target/${component}-1.0.jar ${component}.jar 

    schema_fun

    func_systemd_setup
}