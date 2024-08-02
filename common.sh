log=/tmp/roboshop.log

func_apppreq() {
  echo -e "\e[32m>>>>>>>>>>>>>Download ${component} Service File<<<<<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  echo -e "\e[32m>>>>>>>>>>>>>Create Application User<<<<<<<<<<<<<<<\e[0m"
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

function_systemd() {
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
  echo -e "\e[32m>>>>>>>>>>>>>Install NPM<<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}
  func_apppreq
  echo -e "\e[32m>>>>>>>>>>>>>Install Mongo Client<<<<<<<<<<<<<<<\e[0m"
  dnf install mongodb-org-shell -y &>>${log}
  echo -e "\e[32m>>>>>>>>>>>>>Load Mongo Schema<<<<<<<<<<<<<<<\e[0m"
  mongo --host mongodb.kr7348202.online </app/schema/${component}.js &>>${log}
  function_systemd
  
}

func_java() {
  dnf install maven -y &>>${log}
  func_apppreq
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  dnf install mysql -y &>>${log}
  mysql -h mysql.kr7348202.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
  function_systemd
}
