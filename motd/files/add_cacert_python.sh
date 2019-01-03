#!/bin/bash

cacert_path=$(python -c "from requests.utils import DEFAULT_CA_BUNDLE_PATH; print (DEFAULT_CA_BUNDLE_PATH)")

if [ -z $cacert_path ];then
cacert_path=/usr/lib/python2.7/site-packages/certifi/cacert.pem
fi

if [ -f /etc/redhat-release ];then
cafile=/etc/pki/ca-trust/source/anchors/edallinp01_ca.pem
else
cafile=/usr/local/share/ca-certificates/edallinp01_ca.crt
fi

sed -e '/-BEGIN CERTIFICATE-/d' -e '/-END CERTIFICATE-/d' $cafile > /tmp/file.$$

grep -f /tmp/file.$$ $cacert_path &>/dev/null

if [ $? != 0 ] && [ -f $cacert_path ];then
echo -e "\nAdding cacert to $cacert_path ..\n"
cat $cafile >> $cacert_path
else
echo -e "\ncacert already added to $cacert_path ..\n"
fi

rm -f /tmp/file.$$
