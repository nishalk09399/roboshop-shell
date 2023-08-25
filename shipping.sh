#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

USER_ROBOSHOP=$(id roboshop)
if [ $? -ne 0 ];
then
    echo -e "$Y...USER roboshop is not present so creating now..$N"
    useradd roboshop &>>$LOGFILE
else
    echo -e "$G...USER roboshop is already present so skipping now.$N"
 fi

#checking the user app directory
VALIDATE_APP_DIR=$(cd /app)
if [ $? -ne 0 ];
then
    echo -e " $Y /app directory not there so creating now $N"
    mkdir /app &>>$LOGFILE  
else
    echo -e "$G /app directory already present so skipping now $N"
    fi

    


yum install maven -y &>>$LOGFILE

VALIDATE $? "install maven"

# useradd roboshop &>>$LOGFILE

# VALIDATE $? "add roboshop"

# mkdir /app &>>$LOGFILE

# VALIDATE $? "create app directory"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "download the shipping artcifact"

cd /app &>>$LOGFILE

VALIDATE $? "move to app directory"

unzip /tmp/shipping.zip &>>$LOGFILE

VALIDATE $? "unzipping the shipping file"

cd /app &>>$LOGFILE

VALIDATE $? "move to app directory"

mvn clean package &>>$LOGFILE

VALIDATE $? "clean maven"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE

VALIDATE $? "move the shipping file"

cp /root/roboshop-shell/shipping.service  /etc/systemd/system/shipping.service &>>$LOGFILE

VALIDATE $? "install maven"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "demon reload"

systemctl enable shipping &>>$LOGFILE

VALIDATE $? "enable shipping"

systemctl start shipping &>>$LOGFILE

VALIDATE $? "start the shipping"

yum install mysql -y &>>$LOGFILE

VALIDATE $? "install mysql"

mysql -h mysql.nishaldevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE

VALIDATE $? "install mysql artifacts"

systemctl restart shipping &>>$LOGFILE

VALIDATE $? "restart the shipping"


