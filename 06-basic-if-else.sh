#!/bin/bash
#testing the else condition

testuser=$1

if grep $testuser /etc/passwd
then
    echo " $1 user exist"
    ls -R /home/$testuser
else
    echo "user doesnt exist"
fi
