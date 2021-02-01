for i in $(ls -d */); 
do 
 echo ${i%%/}; 
 zip -rm ${i%%/}.zip ${i%%/}
# ./ping_all_hosts.sh ${i%%/}
done