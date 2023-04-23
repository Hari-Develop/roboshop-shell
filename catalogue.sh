script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/comman.sh

component=catalogue
schema_fun=mongo
function_nodejs
