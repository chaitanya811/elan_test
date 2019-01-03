#!/bin/bash

if [ -f /etc/pki/tls/misc/c_hash ] && [ -f /etc/openldap/cacerts/cacert.pem ];then
check=$(/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/cacert.pem | awk '{print $1}')

if [ -n "$check" ];then
echo "chash=$check"
else
echo "chash=notfound"
fi
else
echo "chash=notfound"
fi
