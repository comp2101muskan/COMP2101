#!/bin/bash
#
# this script displays some host identification information for a Linux machine
#
# Sample output:
#   Hostname      : zubu
#   LAN Address   : 192.168.2.2
#   LAN Name      : net2-linux
#   External IP   : 1.2.3.4
#   External Name : some.name.from.our.isp

# the LAN info in this script uses a hardcoded interface name of "eno1"
#    - change eno1 to whatever interface you have and want to gather info about in order to test the script

# TASK 1: Accept options on the command line for verbose mode and an interface name
#         If the user includes the option -v on the command line, set the varaible $verbose to contain the string "yes"
#            e.g. network-config-expanded.sh -v
#         If the user includes one and only one string on the command line without any option letter in front of it, only show information for that interface
#            e.g. network-config-expanded.sh ens34
#         Your script must allow the user to specify both verbose mode and an interface name if they want
# TASK 2: Dynamically identify the list of interface names for the computer running the script, and use a for loop to generate the report for every interface except loopback

####################
## TASK 1
####################
echo "#######################"
echo "BASH LAB 4: TASK 1"
echo "#######################"

while [ $# -gt 0 ]; do
    case "$1" in
        -v )
      verbose="yes"
    ;;
    esac

    # If user enter -v
    if [ $1 = "-v" ]; then
        [ "$verbose" = "yes" ] && echo "Gathering host information"

        my_hostname=$(hostname)
        [ "$verbose" = "yes" ] && echo "Identifying default route"

        default_router_address=$(ip r s default| cut -d ' ' -f 3)
        default_router_name=$(getent hosts $default_router_address|awk '{print $2}')

        [ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"

        external_address=$(curl -s icanhazip.com)
        external_name=$(getent hosts $external_address | awk '{print $2}')

        cat <<EOF
System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name
EOF
        break
    fi

    # if user enters the interface name
    if [ "$1" != "-v" -a $# == 1 ]; then
        interface="$1"
        [ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"
        [ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"

        ipv4_address=$(ip a s $interface|awk -F '[/ ]+' '/inet /{print $3}')
        ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

        [ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"

        network_address=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
        network_number=$(cut -d / -f 1 <<<"$network_address")
        network_name=$(getent networks $network_number|awk '{print $1}')
        cat <<EOF
Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name
EOF
        break
    fi

    shift
done

####################
## TASK 2
####################
echo "#######################"
echo "BASH LAB 4: TASK 2"
echo "#######################"

everyInterface=$(ip a | awk '/: e/{print $2}')

# Determining number of interfaces
countInterface=$(ip a | awk '/: e/{print $2}' | wc -l )

for (( count=1; count <= $countInterface; count++ )); do
    interface=$( ip a | awk '/: e/{print $2}' | awk "NR==$count")

    echo "Reporting on interface: $interface"
    echo "Getting IPV4 address and name for interface $interface"

    ipv4Address=$(ip a s $interface| awk -F '[/ ]+' '/inet /{print $3}')
    ipv4Name=$(getent hosts $ipv4Address | awk '{print $2}')

    echo "Getting IPV4 network block info and name for interface $interface"
    networkAddress=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
    networkName=$(getent networks $(cut -d / -f 1 <<<"$networkAddress")|awk '{print $1}')

    cat <<EOF
Interface $interface:
===============
Address         : $ipv4Address
Name            : $ipv4Name
Network Address : $networkAddress
Network Name    : $networkName
EOF
done
