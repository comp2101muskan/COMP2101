#!/bin/bash
#
# This script is for the bash lab on variables, dynamic data, and user input
# Download the script, do the tasks described in the comments
# Test your script, run it on the production server, screenshot that
# Send your script to your github repo, and submit the URL with screenshot on Blackboard

echo "---------------------------------"
echo "Student: Muskan (200454885)"

# Get the current hostname using the hostname command and save it in a variable
hostNameVariable=`hostname` 
echo "---------------------------------"
echo 'Current Host: ' $hostNameVariable # Tell the user what the current hostname is in a human friendly way

# Ask for the user's student number using the read command
echo "---------------------------------"
echo 'Enter student number:'
read studentNumber 
echo "---------------------------------"
echo 'Your Student Number:'
echo $studentNumber

futureHostName='pc'
futureHostName+=$studentNumber # Use that to save the desired hostname of pcNNNNNNNNNN in a variable, where NNNNNNNNN is the student number entered by the user
echo "---------------------------------"
echo 'Which Hostname to set:'
echo $futureHostName

# If that hostname is not already in the /etc/hosts file,
# change the old hostname in that file to the new name using sed or something similar
# and tell the user you did that
#e.g. sed -i "s/$oldname/$newname/" /etc/hosts
echo "---------------------------------"
sed -i "s/$hostNameVariable/$futureHostName/" /etc/hosts && echo 'Changed HOSTNAME using sed command'

# If that hostname is not the current hostname, change it using the hostnamectl command and
#     tell the user you changed the current hostname and they should reboot to make sure the new name takes full effect
#e.g. hostnamectl set-hostname $newname
echo "---------------------------------"
echo 'Checking if the hostname is changed'
if [[ $hostname != $futureHostName ]]; then
  hostnamectl set-hostname $futureHostName && echo 'ELSE changing it using HOSTNAMECTL command'
fi

# Printing Hostname for Verification
echo "---------------------------------"
echo 'Now Hostname: ' `hostname` 
echo "---------------------------------"

