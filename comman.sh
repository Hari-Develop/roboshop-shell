app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log


print_msg (){
    echo -e "\e[33m.... $1 ....\e[0m"
    echo -e "\e[33m.... $1 ....\e[0m" &>>$log_file
}


stat_check_fuction () {
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m...SUCCESS...\e[0m"
    else
        echo -e "\e[31m...failuer...\e[0m"
        echo "please refer to the /tmp/roboshop.log file for more information"
        exit 1
    fi
}


schema_fun () {
    if [ "$schema_fun" == "mongo" ]; then
        print_msg "adding the mongo.repo"
        cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
        stat_check_fuction $?

        print_msg "adding the mongo-shell-client"
        yum install mongodb-org-shell -y &>>$log_file
        stat_check_fuction $?

        print_msg "adding loading scheme"
        mongo --host mongodb-dev.unlockers.online </app/schema/${component}.js &>>$log_file
        stat_check_fuction $?
    fi

    if [ "$schema_fun" == "mysql" ]; then
        print_msg "installing the mysql"
        yum install mysql -y &>>$log_file
        stat_check_fuction $?

        print_msg "loading the scheme"
        mysql -h mysql-dev.unlockers.online -uroot -p${mysql_root_passwd} < /app/schema/shipping.sql &>>$log_file
        stat_check_fuction $?
    fi

}


funct_prereq () {

    print_msg "add application user"  
    useradd ${app_user} &>>$log_file
    stat_check_fuction $?

    print_msg "making the directory"
    rm -rf /app &>>$log_file
    mkdir /app &>>$log_file 
    stat_check_fuction $?

    print_msg "Downloading the content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip&>>$log_file
    stat_check_fuction $?

    print_msg "changing the directory"
    cd /app &>>$log_file
    stat_check_fuction $?

    print_msg "unzip the content in the app directory"
    unzip /tmp/${component}.zip &>>$log_file 
    stat_check_fuction $?

}

func_systemd_setup () {
    print_msg "adding the service file"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    stat_check_fuction $?

    print_msg "starting the system"
    systemctl daemon-reload &>>$log_file
    systemctl enable ${component} &>>$log_file 
    systemctl start ${component} &>>$log_file
    systemctl restart ${component} &>>$log_file
    stat_check_fuction $?

}

function_nodejs () {
    print_msg "installing the repo for the node"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
    stat_check_fuction $?

    print_msg "installing the nodejs"
    yum install nodejs -y &>>$log_file
    stat_check_fuction $?

    funct_prereq

    print_msg "installing the npm install"
    npm install &>>$log_file
    stat_check_fuction $?

    schema_fun
    func_systemd_setup
}

func_java () {
    print_msg "installing the maven"
    yum install maven -y >/tmp/roboshop.log &>>$log_file
    stat_check_fuction $?

    funct_prereq

    print_msg "cleaning the maven" &>>$log_file
    mvn clean package &>>$log_file
    stat_check_fuction $?
    mv target/${component}-1.0.jar ${component}.jar &>>$log_file
    stat_check_fuction $?

    schema_fun
    func_systemd_setup
}

fun_python () {

    print_msg "installing the python package"
    yum install python36 gcc python3-devel -y &>>$log_file
    stat_check_fuction $?

    funct_prereq

    print_msg "installing the pip3.6 "
    pip3.6 install -r requirements.txt &>>$log_file
    stat_check_fuction $?

    print_msg "changing the rabbit_password"
    sed -i -e "s|rabbit_user_passwd|$rabbit_user_passwd|" ${script_path}/payment.service &>>$log_file
    stat_check_fuction $?

    func_systemd_setup

}