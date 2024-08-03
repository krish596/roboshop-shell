log=/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>Download cart Service File<<<<<<<<<<<<<<<\e[0m"
cp cart.service /etc/systemd/system/cart.service &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Disable NodeJS<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Enable NodeJS<<<<<<<<<<<<<<<\e[0m"
dnf module enable nodejs:18 -y &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Install NodeJS<<<<<<<<<<<<<<<\e[0m"
dnf install nodejs -y &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Create Application cart<<<<<<<<<<<<<<<\e[0m"
usertadd roboshop &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Remove Application Directory<<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Create Application Directory<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>${log}
cd /app
echo -e "\e[32m>>>>>>>>>>>>>Extract Content<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/cart.zip &>>${log}
echo -e "\e[32m>>>>>>>>>>>>>Install NPM<<<<<<<<<<<<<<<\e[0m"
npm install &>>${log}
systemctl daemon-reload &>>${log} | tee -a ${log}
systemctl enable cart &>>${log} | tee -a ${log}
systemctl restart cart &>>${log} | tee -a ${log}