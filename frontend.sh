source common.sh
echo -e "\e[32m>>>>>>>>>>>>>Install Nginx<<<<<<<<<<<<<<<\e[0m"
dnf install nginx -y &>>${log}
func_exit_status
echo -e "\e[32m>>>>>>>>>>>>>Create Roboshop Conf file<<<<<<<<<<<<<<<\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status
echo -e "\e[32m>>>>>>>>>>>>>Remove Existing Content<<<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status
echo -e "\e[32m>>>>>>>>>>>>>Download Application Content<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
func_exit_status
cd /usr/share/nginx/html
echo -e "\e[32m>>>>>>>>>>>>>Extract Content<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip &>>${log}
func_exit_status
echo -e "\e[32m>>>>>>>>>>>>>Start frontend service<<<<<<<<<<<<<<<\e[0m"
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
func_exit_status