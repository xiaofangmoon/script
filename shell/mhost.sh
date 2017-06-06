#! /bin/bash
sudo chmod 777 /etc/hosts
echo "xiaofang";

if [ $1 ]
then
	source=`cat /Users/xiaofang/bin/hosts.txt`
	front=`sed -n ${1}p /Users/xiaofang/bin/hosts-front.txt `

	sudo cat /Users/xiaofang/bin/hosts.txt > /etc/hosts
	sudo echo $front >> /etc/hosts

else
echo "no args"

fi

pwd
cat /etc/hosts
