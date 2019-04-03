#!/bin/bash
#安装SQL Server2017脚本 内存最少3.5G

chmod -R 777 /usr/local/src/*
#时间时区同步，修改主机名
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ntpdate cn.pool.ntp.org
hwclock --systohc
echo "*/30 * * * * root ntpdate -s 3.cn.poop.ntp.org" >> /etc/crontab

sed -i 's|SELINUX=.*|SELINUX=disabled|' /etc/selinux/config
sed -i 's|SELINUXTYPE=.*|#SELINUXTYPE=targeted|' /etc/selinux/config
sed -i 's|SELINUX=.*|SELINUX=disabled|' /etc/sysconfig/selinux 
sed -i 's|SELINUXTYPE=.*|#SELINUXTYPE=targeted|' /etc/sysconfig/selinux 
setenforce 0 && systemctl stop firewalld && systemctl disable firewalld

rm -rf /var/run/yum.pid 
rm -rf /var/run/yum.pid

#查看系统版本号 内存必须4G，否则初始化失败
cat /etc/redhat-release 
curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server.repo
#yum -y update 
yum -y install mssql-server
/opt/mssql/bin/mssql-conf setup
systemctl status mssql-server
# firewall-cmd –zone=public –add-port=1433/tcp –permanent
# firewall-cmd –reload
wget -O /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/7/prod.repo
yum -y install mssql-tools unixODBC-devel
echo 'export PATH=/opt/mssql-tools/bin:$PATH' >> /etc/profile.d/mssql.sh
source /etc/profile.d/mssql.sh
echo $PATH
sqlcmd -S localhost -U SA -P Admin123

