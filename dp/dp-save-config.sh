#!/bin/bash

export PATH=.:$PATH

source ../config-funcs.sh

dpcfg=$1
zomafile=$2

domain=$(strip_quotes $(jq '.Gateway.DatapowerDomain' $dpcfg))

echo writing file $zomafile

cat<<EOF > $zomafile
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request domain="$domain">
            <ma:do-action>
                <SaveConfig></SaveConfig>
            </ma:do-action>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF
