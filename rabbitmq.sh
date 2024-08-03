rabbitmq_root_password=$1

if [ -z "${rabbitmq_root_password}" ]; then
  echo Input RabbitMQ Password is Missing
  exit 1

fi

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
dnf install rabbitmq-server -y
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
rabbitmqctl add_user roboshop ${rabbitmq_root_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"