cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
rm -rf /app
unzip /tmp/catalogue.zip
cd /app
npm install
dnf install mongodb-org-shell -y
mongo --host 172.31.89.76 </app/schema/catalogue.js

systemctl daemon-reload

systemctl enable catalogue
systemctl restart catalogue