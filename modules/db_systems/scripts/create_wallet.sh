serverFQDN=`hostname -f` 
server=$(echo $serverFQDN | sed 's/\..*//')
echo $server

export ORACLE_HOSTNAME=$server
export ORACLE_BASE=/u01/app/oracle
export ORACLE_SID=$server
export ORACLE_HOME=$ORACLE_BASE/product/19.0.0/dbhome_1
export TNS_ADMIN=${ORACLE_HOME}/network/admin

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ORACLE_HOME}/lib
export ORACLE_HOME PATH ORACLE_SID TNS_ADMIN LD_LIBRARY_PATH
export ORA_INVENTORY=/u01/app/oraInventory
export PATH=$ORACLE_HOME/bin:$PATH
export WALLET_DIR=$ORACLE_BASE/admin/wallet_dir
export DB_WALLET_DIR=$ORACLE_BASE/admin/$server

cd $ORACLE_BASE/admin	
rm -rf 	$DB_WALLET_DIR $WALLET_DIR
mkdir -p $WALLET_DIR
mkdir -p $DB_WALLET_DIR


orapki wallet create -wallet  $WALLET_DIR/root_ca -pwd MY_PASSWORD  -auto_login
orapki wallet add -wallet $WALLET_DIR/root_ca -dn "CN=RootCA" -keysize 2048 -self_signed -validity 7300 -sign_alg sha256  -pwd MY_PASSWORD
orapki wallet display -wallet $WALLET_DIR/root_ca -pwd MY_PASSWORD
orapki wallet export -wallet $WALLET_DIR/root_ca  -dn "CN=RootCA" -cert $WALLET_DIR/rootCA_Cert.pem -pwd MY_PASSWORD
rm -rf $ORACLE_BASE/admin/wallet_dir/root_ca/*.lck
ls -la $ORACLE_BASE/admin/wallet_dir/root_ca
orapki wallet display -wallet $WALLET_DIR/root_ca -pwd MY_PASSWORD

orapki wallet create -wallet $DB_WALLET_DIR/$server -auto_login -pwd MY_PASSWORD
orapki wallet add -wallet $DB_WALLET_DIR/$server -dn "CN=$server" -keysize 2048 -pwd MY_PASSWORD -sign_alg sha256
orapki wallet export -wallet $DB_WALLET_DIR/$server -pwd MY_PASSWORD  -dn "CN=$server"  -request $DB_WALLET_DIR/${server}_req.pem
orapki wallet display -wallet $DB_WALLET_DIR/$server -pwd MY_PASSWORD

orapki cert create -wallet $WALLET_DIR/root_ca -request $DB_WALLET_DIR/${server}_req.pem -cert $DB_WALLET_DIR/${server}_Cert.pem -serial_num 20 -validity 365 -pwd MY_PASSWORD
orapki wallet add -wallet $DB_WALLET_DIR/$server -trusted_cert -cert $WALLET_DIR/rootCA_Cert.pem -pwd MY_PASSWORD
orapki wallet add -wallet $DB_WALLET_DIR/$server -user_cert  -cert $DB_WALLET_DIR/${server}_Cert.pem -pwd MY_PASSWORD
cp $WALLET_DIR/rootCA_Cert.pem $DB_WALLET_DIR/$server
rm -rf $ORACLE_BASE/admin/wallet_dir/root_ca/*.lck
ls -la $DB_WALLET_DIR/$server
orapki wallet display -wallet $DB_WALLET_DIR/$server -pwd MY_PASSWORD
