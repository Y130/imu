#!/bin/sh
[ ! -d './ssl' ] && mkdir ./ssl && echo "$(date +'%F %T') Created ssl/."

# This may take a while, conisder 2048 if appropriate.
if [ ! -f ssl/dhparam.pem ] ; then
	echo "$(date +'%F %T') Generating ssl/dhparam.pem. This will take a while."
	openssl dhparam -out ssl/dhparam.pem 3072 >/dev/null 2>&1
	echo "$(date +'%F %T') Finished ssl/dhparam.pem."
fi

# Used only to deny client queries that do not match any defined server.
if [ ! -f ssl/default.key ] ; then
	echo "$(date +'%F %T') Generating ssl/default.key and certificate."
	openssl req -x509 -nodes -subj '/C=XX/ST=Al Amarja/L=The Edge/CN=domain.invalid' \
		-days 3650 -newkey rsa:3072 -new -out ssl/default.crt -keyout ssl/default.key \
		>/dev/null 2>&1
	echo "$(date +'%F %T') Finished ssl/default.key and certificate."
fi

# If an argument is provided, generate a certificate request. Arguments are
# either 'www.domain.com' or 'wild.domain.com' in the event of requesting
# wildcard certificates. Generates 'www.domain.com.csr.$YEAR' or
# 'domain.com.csr.$YEAR' in 'ssl/', the latter being a wildcard CSR.
if [ -n "$1" ]; then
	basename=`echo $1 |cut -d'.' -f2-`
	case `echo $1 |cut -d'.' -f1` in
		"www") filename="$1";;
		"wild") filename="$basename";;
		*)
			echo "Argument must be either 'www.domain.com' or 'wild.domain.com'!"
			exit 1
		;;
	esac
	year=`date +'%Y'`
	crt="ssl/$filename.crt.$year"
	csr="ssl/$filename.csr.$year"
	key="ssl/$filename.key.$year"
	conf="ssl/$filename.conf.$year"

	echo "$(date +'%F %T') Generating $key and $csr."
	while true; do
		read -p "# Country Name (2 letter code) > " country
		read -p "# State or Province Name (full name) > " state
		read -p "# Locality Name (eg, city) > " city
		read -p "# Organization Name (eg, company) > " company
		read -p "# Organizational Unit Name (eg, section) > " organization
		echo -e "Country: $country\nState: $state\nCity: $city\nCompany: $company\nOrganization: $organization"
		read -p "# Is this correct? ([y]es/[n]o) > " yn
		case $yn in
		[Yy]* ) cat <<-EOF > $conf && break
			[ req ]
			default_bits = 3072
			default_keyfile = privkey.pem
			distinguished_name = req_distinguished_name
			req_extensions = req_ext 
			[ req_distinguished_name ]
			countryName =
			countryName_default = $country
			stateOrProvinceName = 
			stateOrProvinceName_default = $state
			localityName =
			localityName_default = $city
			organizationName =
			organizationName_default = $company
			organizationalUnitName =
			organizationalUnitName_default = $orangization
			commonName =
			commonName_default = $1
			commonName_max = 64
			[ req_ext ]
			subjectAltName = @alt_names
			[alt_names]
			DNS.1 = $1
			DNS.2 = $basename
			EOF
		;;
		[Nn]* ) continue;;
		* ) echo "# Please answer yes or no.";;
		esac
	done
	openssl req -nodes -newkey rsa:3072 -keyout $key -config $conf -out $csr -batch >/dev/null 2>&1
	echo "$(date +'%F %T') Finished $key and $csr."
	if [ "$2" == "--sign" ]; then
		openssl x509 -req -days 365 -in $csr -signkey $key -out $crt >/dev/null 2>&1
		echo "$(date +'%F %T') Self-signed $crt."
	fi
fi
