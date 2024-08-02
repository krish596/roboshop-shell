echo -e "\e[32m>>>>>>>>>>>>>Download Catalogue Service File<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Download Mongo Repo file<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Disable NodeJS<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Enable NodeJS<<<<<<<<<<<<<<<\e[0m"
dnf module enable nodejs:18 -y &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Install NodeJS<<<<<<<<<<<<<<<\e[0m"
dnf install nodejs -y &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Create Application User<<<<<<<<<<<<<<<\e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Remove Application Directory<<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Create Application Directory<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[32m>>>>>>>>>>>>>Extract Content<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Install NPM<<<<<<<<<<<<<<<\e[0m"
npm install &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Install Mongo Client<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Load Mongo Schema<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb.kr7348202.online </app/schema/catalogue.js &>>/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Start Catalogue Service<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log