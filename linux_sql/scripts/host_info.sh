#!/bin/sh

#Args
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

#Script
#Obtain data
lscpu_out=$(lscpu)
cpu_number=$(echo "$lscpu_out" | awk '/^CPU\(s\):/ {print $2}')
cpu_architecture=$(echo "$lscpu_out" | awk '/^Architecture:/ {print $2}')
cpu_model=$(echo "$lscpu_out" | awk -F': +' '/^Model name:/ {print $2}')
cpu_mhz=$(awk -F': ' '/cpu MHz/ {print $2; exit}' /proc/cpuinfo)
l2_cache=$(echo "$lscpu_out" | egrep "L2 cache:" | awk '{print $3}' | xargs)
total_mem=$(free -k | awk '/^Mem:/ {print $2}')
timestamp=$(date -u +%Y'-'%m'-'%d' '%H':'%M':'%S)

insert_stmt="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, timestamp, total_mem) VALUES('$psql_host', $cpu_number, '$cpu_architecture', '$cpu_model', $cpu_mhz, '$l2_cache', '$timestamp', '$total_mem');"
PGPASSWORD="$psql_password" psql -h "$psql_host" -U "$psql_user" -d "$db_name" -c "$insert_stmt"

#echo "$lscpu_out"
echo "$insert_stmt"