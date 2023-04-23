script=$(realpath "$0")
script_path=$(dirname "$script")
rabbit_user_passwd=$1

if [ -z "$rabbit_user_passwd" ]
then
    echo "input od passwd is not provided"
    exit
fi

component=payment
fun_python
