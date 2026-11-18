#Args
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5
#confirm 5 args
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi
vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)

memory_free=$(echo "$vmstat_mb" | awk '{print $4}'| tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_mb" #todo
cpu_kernel=$(echo "$vmstat_mb" #todo
disk_io=$(vmstat -d | awk '{print $10}' #todo
disk_available=$(df -BM / ...

timestamp=$(date -u +%Y'-'%m'-'%d' '%H':'%M':'%S)

host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";

insert_stmt="INSERT INTO host_usage(timestamp, ...) VALUES('$timestamp', #todo....

#set up env var for psql cmd
export PGPASSWORD=$psql_password
#Insert date into a database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?