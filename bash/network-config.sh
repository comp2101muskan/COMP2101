#!/bin/bash
#
# this script displays some host identification information for a simple Linux machine
#
# Sample output:
#   Hostname        : hostname
#   LAN Address     : 192.168.2.2
#   LAN Hostname    : host-name-from-hosts-file
#   External IP     : 1.2.3.4
#   External Name   : some.name.from.our.isp

echo "---------------------------------"
echo "Student: Muskan (200454885)"

# Task 1:
echo "---------------------------------"
echo "Task 1"

commandPartOne=$(ip a |awk '/: e/{gsub(/:/,"");print $2}')
lanaddress=$(ip a s $commandPartOne |awk '/inet /{gsub(/\/.*/,"");print $2}')
lanname=$(getent hosts $lanaddress | awk '{print $2}')
externaladdress=$(curl -s icanhazip.com)
externalname=$(getent hosts $externaladdress | awk '{print $2}')

cat <<EOF
Hostname        : $(hostname)
LAN Address     : $lanaddress
LAN Hostname    : $lanname
External IP     : $externaladdress
External Name   : $externalname
EOF


# Task 2:
echo "---------------------------------"
echo "Task 2"

routerraddress=$(echo $lanaddress | awk -F "." '{print $1 "." $2 "." $3 ".1"}')
routerrname=$(getent hosts $routerraddress | awk '{print $2}')

cat <<EOF
Router Address  : $routerraddress
Router Hostname : $routerrname
EOF

echo "---------------------------------"
