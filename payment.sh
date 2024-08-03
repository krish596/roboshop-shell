rabbitmq_root_password=$1

if [ -z "${rabbitmq_root_password}" ]; then
  echo Input RabbitMQ Password is Missing
  exit 1

fi
component=payment
source common.sh
func_python