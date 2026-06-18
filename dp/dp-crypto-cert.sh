#!/bin/bash

source ../config-funcs.sh

dpcfg=$1
certname=$2
dpcertfile=$3
zomafile=$4

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
                <CryptoCertificate name="$certname">
                    <mAdminState>enabled</mAdminState>
                    <Filename>$dpcertfile</Filename>
                    <Password></Password>
                    <PasswordAlias>off</PasswordAlias>
                    <Alias></Alias>
                    <IgnoreExpiration>off</IgnoreExpiration>
                </CryptoCertificate>
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF

