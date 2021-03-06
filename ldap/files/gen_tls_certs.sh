#!/bin/bash
#Script Written by Rajesh Moturi.
#Script to generate TLS based server certificates for LDAP.
#CA Certs will be generated by gen_CA.sh(/root/CA) and distributed using Puppet.

# Certificate Details
COUNTRY="US"                                     # 2 letter country-code
STATE="Texas"                                    # state or province name
LOCALITY="Irving"                                # Locality Name (e.g. city)
ORGNAME="Elan Technologies Inc."                 # Organization Name (eg, company)
ORGUNIT="Software and Development Engineering"   # Organizational Unit Name (eg. section)
EMAIL="rajesh.moturi@elantecs.com"               # certificate's email address
SITE=$(hostname -i)
PASS="elantecs123"
CERTDIR="/root/LDAP_CERTS"

# Optional Extra Details
CHALLENGE=""                                     # challenge password
COMPANY=""                                       # company name

DAYS="-days 3650"                                # validity of cert

mkdir -p $CERTDIR
cd $CERTDIR
mkdir -p certs private newcerts
chmod 700 $CERTDIR
echo 1000 > serial
touch index.txt

echo -e "\nServer Certs will be generated in ${CERTDIR}.\n"

cp -rp /etc/pki/tls/openssl.cnf /etc/pki/tls/openssl.cnf.$$
SCERTDIR="${CERTDIR//\//\/}"
sed -i "s/\/etc\/pki\/CA/$SCERTDIR/g" /etc/pki/tls/openssl.cnf

if [ ! -f "$CERTDIR/private/slapd.key" ] || [ ! -f "$CERTDIR/slapd.crt" ];then
echo -e "\nGenerating and Self Sign a new server key/cert pair\n"
cd $CERTDIR

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

echo -e "\nSuccessfully Generated the $CERTDIR/private/slapd.key $CERTDIR/slapd.crt.\n" | tee /var/log/gen_tls.log
else
echo -e "$CERTDIR/private/slapd.key and slapd.crt already exist.\n"
fi

chash=$(/etc/pki/tls/misc/c_hash $CERTDIR/cacert.pem | awk '{print $1}')

mv /etc/pki/tls/openssl.cnf.$$ /etc/pki/tls/openssl.cnf

cp -rp $CERTDIR/private/cakey.pem /etc/openldap/cacerts/cakey.pem
cp -rp $CERTDIR/cacert.pem /etc/openldap/cacerts/cacert.pem
cp -rp $CERTDIR/slapd.csr /etc/openldap/certs/slapd.csr
cp -rp $CERTDIR/slapd.crt /etc/openldap/certs/slapd.crt
cp -rp $CERTDIR/private/slapd.key /etc/openldap/certs/slapd.key
