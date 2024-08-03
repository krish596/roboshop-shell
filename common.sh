log=/tmp/roboshop.log

func_apppreq() {
  echo -e "\e[32m>>>>>>>>>>>>>Download ${component} Service File<<<<<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Create Application ${component}<<<<<<<<<<<<<<<\e[0m"
  useradd roboshop &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Remove Application Directory<<<<<<<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Create Application Directory<<<<<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  cd /app
  echo -e "\e[32m>>>>>>>>>>>>>Extract Content<<<<<<<<<<<<<<<\e[0m"
  unzip /tmp/${component}.zip &>>${log}  
}

func_systemd() {
  echo -e "\e[32m>>>>>>>>>>>>>Start ${component} Service<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}  
}
func_nodejs() {
  
  
  echo -e "\e[32m>>>>>>>>>>>>>Download Mongo Repo file<<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Disable NodeJS<<<<<<<<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Enable NodeJS<<<<<<<<<<<<<<<\e[0m"
  dnf module enable nodejs:18 -y &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Install NodeJS<<<<<<<<<<<<<<<\e[0m"
  dnf install nodejs -y &>>${log}
  func_apppreq
  echo -e "\e[32m>>>>>>>>>>>>>Install NPM<<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Install Mongo Client<<<<<<<<<<<<<<<\e[0m"
  dnf install mongodb-org-shell -y &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Load Mongo Schema<<<<<<<<<<<<<<<\e[0m"
  mongo --host mongodb.kr7348202.online </app/schema/${component}.js &>>${log}
  func_systemd
}

func_java() {
  echo -e "\e[32m>>>>>>>>>>>>>Install Maven<<<<<<<<<<<<<<<\e[0m"
  dnf install maven -y &>>${log}
  
  func_apppreq
  echo -e "\e[32m>>>>>>>>>>>>>Clean Maven Package<<<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Replace Maven Package<<<<<<<<<<<<<<<\e[0m"
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Install MySQL<<<<<<<<<<<<<<<\e[0m"
  dnf install mysql -y &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Load MySQL Schema<<<<<<<<<<<<<<<\e[0m"
  mysql -h mysql.kr7348202.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
  func_systemd
}

func_python() {
  echo -e "\e[32m>>>>>>>>>>>>>Install Python Package<<<<<<<<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y &>>${log}
  func_apppreq
  echo -e "\e[32m>>>>>>>>>>>>>Install PIP Package<<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_systemd
}
