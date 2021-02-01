### eugene.simos@oracle.com leave the comments as such for future modifications
###
#!/bin/bash
sudo su << EOF
yum install -y oracle-rdbms-server-12cR1-preinstall
yum install -y wget curl git 
#create sudo user oracle opc

sed s/SELINUX=enforcing/SELINUX=disabled/g -i /etc/selinux/config

echo "opc ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "oracle ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "MY_PASSWORD" | passwd --stdin oracle
echo "MY_PASSWORD" | passwd --stdin opc

mkdir -p /home/oracle/.ssh
cp /home/opc/*.sh                  /home/oracle
cp /home/opc/.ssh/authorized_keys /home/oracle/.ssh/authorized_keys
cp /home/opc/.ssh/config          /home/oracle/.ssh/config
cp /home/opc/.ssh/priv.txt        /home/oracle/.ssh/priv.txt
chmod -R og-rwx /home/oracle/.ssh
chown -R oracle:oinstall  /home/oracle
EOF