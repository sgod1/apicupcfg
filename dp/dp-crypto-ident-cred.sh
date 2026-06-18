#!/bin/bash

source ../config-funcs.sh

dpcfg=$1
prefix=$2
keyname=$3
certname=$4
zomafile=$5

# jq input
domain=$(strip_quotes $(jq '.Gateway.DatapowerDomain' $dpcfg))

echo writing file $zomafile

cat<<EOF > $zomafile
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request domain="$domain">
            <ma:set-config>
                <CryptoIdentCred name="$prefix">
                    <mAdminState>enabled</mAdminState>
                    <Key>$keyname</Key>
                    <Certificate>$certname</Certificate>
                </CryptoIdentCred>
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF

