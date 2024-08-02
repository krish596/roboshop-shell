log=/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Download Catalogue Service File<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Download Mongo Repo file<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Disable NodeJS<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Enable NodeJS<<<<<<<<<<<<<<<\e[0m"
dnf module enable nodejs:18 -y &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Install NodeJS<<<<<<<<<<<<<<<\e[0m"
dnf install nodejs -y &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Create Application User<<<<<<<<<<<<<<<\e[0m"
useradd roboshop &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Remove Application Directory<<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Create Application Directory<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
cd /app
echo -e "\e[32m>>>>>>>>>>>>>Extract Content<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Install NPM<<<<<<<<<<<<<<<\e[0m"
npm install &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Install Mongo Client<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Load Mongo Schema<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb.kr7348202.online </app/schema/catalogue.js &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Start Catalogue Service<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload &>>${log} | tee -a ${log}
systemctl enable catalogue &>>${log} | tee -a ${log}
systemctl restart catalogue &>>${log} | tee -a ${log}