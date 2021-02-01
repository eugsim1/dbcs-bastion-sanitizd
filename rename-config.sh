#!/bin/bash
ext_hostname=`curl -L http://169.254.169.254/opc/v1/instance/displayName`
echo $ext_hostname

sed "s/bastion/$ext_hostname/g" -i /home/opc/.ssh/config
sudo su << EOF
cp /home/opc/.ssh/config /home/oracle/.ssh/config
chown oracle:oinstall /home/oracle/.ssh/config
EOF