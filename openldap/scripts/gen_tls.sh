#!/bin/bash
#Script Written by Rajesh Moturi
#Script to genrate TLS based certificates for LDAP

# Certificate Details
COUNTRY="US"                     # 2 letter country-code
STATE="Texas"                    # state or province name
LOCALITY="Irving"                # Locality Name (e.g. city)
ORGNAME="Elan Technologies Inc." # Organization Name (eg, company)
ORGUNIT="Software and Development Engineering"                  # Organizational Unit Name (eg. section)
EMAIL="rajesh.moturi@elantecs.com"    # certificate's email address
SITE=$(hostname -f)
PASS="elantecs123"
CADIR="/root/CA"

# Optional Extra Details
CHALLENGE=""                # challenge password
COMPANY=""                  # company name

DAYS="-days 3650"

mkdir -p $CADIR
cd $CADIR
mkdir certs private newcerts
chmod 700 $CADIR
echo 1000 > serial
touch index.txt

echo -e "\nAll Certs will be generated in $CADIR\n"

cp -rp /etc/pki/tls/openssl.cnf /etc/pki/tls/openssl.cnf.$$
SCADIR="${CADIR//\//\/}"
sed -i "s/\/etc\/pki\/CA/$SCADIR/g" /etc/pki/tls/openssl.cnf

if [ ! -f "$CADIR/private/cakey.pem" ];then
echo -e "\nGenerating CA in $CADIR directory\n"
cat <<__EOF__ | openssl req -new -x509 $DAYS -extensions v3_ca -keyout private/cakey.pem -passout pass:$PASS -out cacert.pem -config /etc/pki/tls/openssl.cnf
$COUNTRY
$STATE
$LOCALITY
$ORGNAME
$ORGUNIT
$SITE
$EMAIL
$CHALLENGE
$COMPANY
__EOF__
else
echo -e "\nprivate/cakey.pem already exist\n"
fi

if [ ! -f "$CADIR/private/slapd.key" ] || [ ! -f "$CADIR/slapd.crt" ];then
echo -e "\nGenerating and Self Sign a new server key/cert pair\n"
cd $CADIR

cat <<__EOF__ | openssl req -new -nodes $DAYS -out slapd.csr -passout pass:$PASS -keyout private/slapd.key
$COUNTRY
$STATE
$LOCALITY
$ORGNAME
$ORGUNIT
$SITE
$EMAIL
$CHALLENGE
$COMPANY
__EOF__

cat <<__EOF__ | openssl ca -passin pass:$PASS $DAYS -in slapd.csr -out slapd.crt
y
y
__EOF__

echo -e "\nSuccessfully Generated the $CADIR/private/slapd.key $CADIR/slapd.crt\n" | tee /var/log/gen_tls.log
else
echo -e "\n$CADIR/private/slapd.key and slapd.crt already exist\n"
fi

chash=$(/etc/pki/tls/misc/c_hash $CADIR/cacert.pem | awk '{print $1}')

cp -rp $CADIR/cacert.pem $CADIR/$chash

mv /etc/pki/tls/openssl.cnf.$$ /etc/pki/tls/openssl.cnf

echo -e "C_HASH value is $chash\n"
