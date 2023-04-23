script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/comman.sh
mysql_root_passwd=$1

if [ -z "$mysql_root_passwd" ]
then
    echo input mysql root password is not given
    exit
fi
component="shipping"
schema_fun=mysql
func_java
