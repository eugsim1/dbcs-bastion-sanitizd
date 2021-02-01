### eugene.simos@oracle.com leave the comments as such for future modifications
###
#!/bin/bash

ext_hostname=`curl -L http://169.254.169.254/opc/v1/instance/displayName`
echo $ext_hostname
start=`date +%s`
sudo su << EOF
whoami > /tmp/remote.txt
yum install git -y
yum install dos2unix -y


### firewall setting of the target
### disable firewall and SeLinux
systemctl stop firewalld
systemctl diasable firewalld
setenforce 0
sed s/SELINUX=enforcing/SELINUX=disabled/g -i /etc/selinux/config
sed s/SELINUXTYPE=targeted/SELINUXTYPE=minimum/g -i /etc/selinux/config
#firewall-cmd --permanent --zone=public --add-port=4443/tcp
#firewall-cmd --permanent --zone=public --add-port=1521/tcp
#firewall-cmd --reload


#create sudo user oracle opc
echo "opc ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "oracle ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "MY_PASSWORD" | passwd --stdin oracle
echo "MY_PASSWORD" | passwd --stdin opc
echo 'export TNS_ADMIN=\$ORACLE_HOME/network/admin'>> /home/oracle/.bashrc
echo "###end ====" >> /home/oracle/.bashrc
mkdir -p /home/oracle/.ssh
mkdir -p /home/oracle/scripts
mkdir -p /u02/app/oracle/oradata/pdb2
chown -R oracle:oinstall  /u02
cp /home/opc/.ssh/authorized_keys /home/oracle/.ssh/authorized_keys
chown -R oracle:oinstall  /home/oracle
EOF


