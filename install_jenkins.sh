#!/bin/bash
sudo yum -y update


echo "Install git"
yum install -y git

echo "Install Docker engine"
yum update -y
yum install docker -y
#sudo usermod -a -G docker jenkins
#sudo service docker start
sudo chkconfig docker on

#!/bin/bash 
#Download the java
cd /tmp 
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
#install java by using the rpm command
rpm -ivh jdk-8u131-linux-x64.rpm
#delete the rpm after java installatin
rm -f jdk-8u131-linux-x64.rpm
 
#jenkins installatin
#Enable EPEL
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
#installing jenkins with rpm 
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
#update
yum update -y
#install jenkins 
yum install jenkins -y 
#start 
systemctl start jenkins 
#enable the OS level service
systemctl enable jenkins 
#check status