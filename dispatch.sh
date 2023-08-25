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


yum install golang -y &>>LOGFILE

VALIDATE $? "installing goland"


useradd roboshop &>>LOGFILE

VALIDATE $? "installing goland"

mkdir /app &>>LOGFILE

VALIDATE $? "installing goland"

curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>LOGFILE

VALIDATE $? "installing goland"


cd /app &>>LOGFILE

VALIDATE $? "installing goland"


unzip /tmp/dispatch.zip &>>LOGFILE

VALIDATE $? "installing goland"


cd /app &>>LOGFILE

VALIDATE $? "installing goland"


go mod init dispatch &>>LOGFILE

VALIDATE $? "installing goland"


go get &>>LOGFILE

VALIDATE $? "installing goland"


go build &>>LOGFILE

VALIDATE $? "installing goland"


vim /etc/systemd/system/dispatch.service &>>LOGFILE

VALIDATE $? "installing goland"


systemctl daemon-reload &>>LOGFILE

VALIDATE $? "installing goland"


systemctl enable dispatch &>>LOGFILE

VALIDATE $? "installing goland"

 
systemctl start dispatch &>>LOGFILE

VALIDATE $? "installing goland"