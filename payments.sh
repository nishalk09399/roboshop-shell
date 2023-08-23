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


yum install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "installing python"


useradd roboshop &>>$LOGFILE

VALIDATE $? "useradd roboshop"

mkdir /app  &>>$LOGFILE

VALIDATE $? "move to app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "downloading payment artifacts"


cd /app &>>$LOGFILE

VALIDATE $? "changing directory to app"


unzip /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "unzipping the payment file"

cd /app &>>$LOGFILE

VALIDATE $? "changing directory to app"

pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "installing python 6"

cp /root/roboshop-shell/payments.service  /etc/systemd/system/payments.service &>>$LOGFILE

VALIDATE $? "copying file to system location"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "demon reload"

systemctl enable payment  &>>$LOGFILE

VALIDATE $? "enable payment"

systemctl start payment &>>$LOGFILE

VALIDATE $? "start payment"

