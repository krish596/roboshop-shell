log=/tmp/roboshop.log

func_exit_status() {
  if [ $? -nt 0 ]; then
    echo -e "\e[31mSUCCESS\e[0m"
  else
    echo -e "\e[32mFAILURE\e[0m"
  fi 
}
func_apppreq() {
  echo -e "\e[32m>>>>>>>>>>>>>Download ${component} Service File<<<<<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  func_exit_status
  echo -e "\e[32m>>>>>>>>>>>>>Create Application ${component}<<<<<<<<<<<<<<<\e[0m"
  id roboshop &>>${log}
  if [ $? -nt 0 ]; then
    useradd roboshop &>>${log}
  fi

  func_exit_status
  echo -e "\e[32m>>>>>>>>>>>>>Remove Application Directory<<<<<<<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  func_exit_status
  echo -e "\e[32m>>>>>>>>>>>>>Create Application Directory<<<<<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  func_exit_status
  echo -e "\e[32m>>>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  func_exit_status
  cd /app
  echo -e "\e[32m>>>>>>>>>>>>>Extract Content<<<<<<<<<<<<<<<\e[0m"
  unzip /tmp/${component}.zip &>>${log}
  func_exit_status
}

func_systemd() {
  echo -e "\e[32m>>>>>>>>>>>>>Start ${component} Service<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
  func_exit_status
}

func_schema_setup() {
  if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[32m>>>>>>>>>>>>>Install Mongo Client<<<<<<<<<<<<<<<\e[0m"
    dnf install mongodb-org-shell -y &>>${log}
    func_exit_status
    echo -e "\e[32m>>>>>>>>>>>>>Load Mongo Schema<<<<<<<<<<<<<<<\e[0m"
    mongo --host mongodb.kr7348202.online </app/schema/${component}.js &>>${log}
    func_exit_status

  fi

  if [ "${schema_type}" == "mysql" ]; then
    echo -e "\e[32m>>>>>>>>>>>>>Install MySQL<<<<<<<<<<<<<<<\e[0m"
    dnf install mysql -y &>>${log}
    func_exit_status
    echo -e "\e[32m>>>>>>>>>>>>>load schema<<<<<<<<<<<<<<<\e[0m"
    mysql -h mysql.kr7348202.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
    func_exit_status
  fi

}
func_nodejs() {
  
  
  echo -e "\e[32m>>>>>>>>>>>>>Download Mongo Repo file<<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  func_exit_status
  echo -e "\e[32m>>>>>>>>>>>>>Disable NodeJS<<<<<<<<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  func_exit_status
  echo -e "\e[32m>>>>>>>>>>>>>Enable NodeJS<<<<<<<<<<<<<<<\e[0m"
  dnf module enable nodejs:18 -y &>>${log}
  func_exit_status
  echo -e "\e[32m>>>>>>>>>>>>>Install NodeJS<<<<<<<<<<<<<<<\e[0m"
  dnf install nodejs -y &>>${log}
  func_exit_status
  func_apppreq
  echo -e "\e[32m>>>>>>>>>>>>>Install NPM<<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}
  func_exit_status
  func_schema_setup
  func_systemd
}

func_java() {
  echo -e "\e[32m>>>>>>>>>>>>>Download ${component} Service File<<<<<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  func_exit_status
  echo -e "\e[32m>>>>>>>>>>>>>Install Maven<<<<<<<<<<<<<<<\e[0m"
  dnf install maven -y &>>${log}
  func_exit_status
  func_apppreq
  echo -e "\e[32m>>>>>>>>>>>>>Build ${component} Service  <<<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  func_exit_status
  func_schema_setup
  func_systemd
}

func_python() {
  echo -e "\e[32m>>>>>>>>>>>>>Build ${component} Service<<<<<<<<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y &>>${log}
  func_exit_status
  func_apppreq
  echo -e "\e[32m>>>>>>>>>>>>>Install PIP Package<<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_status
  func_systemd
}


