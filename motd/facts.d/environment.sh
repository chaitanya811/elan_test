#!/bin/bash

fqdn=$(hostname -f)
short=$(echo ${fqdn%%.*})

case $short in
edal???p* ) echo "environment=production";;
edal???t* ) echo "environment=test";;
edal???d* ) echo "environment=development";;
esac
