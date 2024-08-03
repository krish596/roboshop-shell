mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo Input MySQL Password is Missing
  exit

fi


dnf module disable mysql -y
cp mysql.repo /etc/yum.repos.d/mysql.repo
dnf install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass ${mysql_root_password}