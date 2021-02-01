sleep 60s
####### --cp hosts scripts/.
####### --cp priv.txt scripts/.
cd scripts
ansible servers  -m ping -i hosts
ansible-playbook -vv -i hosts 01-configure_dbcs.yml
ansible-playbook -vv -i hosts 02-copy-files-dbcs.yml