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


yum install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "installing python"


# useradd roboshop &>>$LOGFILE

# VALIDATE $? "useradd roboshop"

# mkdir /app  &>>$LOGFILE

# VALIDATE $? "move to app directory"

curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "downloading payment artifacts"


cd /app &>>$LOGFILE

VALIDATE $? "changing directory to app"


unzip -o /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "unzipping the payment file"

cd /app &>>$LOGFILE

VALIDATE $? "changing directory to app"

pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "installing python 6"

cp /root/roboshop-shell/payments.service  /etc/systemd/system/payments.service &>>$LOGFILE

VALIDATE $? "copying file to system location"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "demon reload"

systemctl enable payments  &>>$LOGFILE

VALIDATE $? "enable payments"

systemctl start payments &>>$LOGFILE

VALIDATE $? "start payments"

