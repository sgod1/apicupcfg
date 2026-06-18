#!/bin/bash

export PATH=.:$PATH

dpcfg=$1
zomafile=$2

# default domain
datapower_domain="default"

echo writing file $zomafile

cat<<EOF > $zomafile
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request domain="$datapower_domain">
            <ma:do-action>
                <SaveConfig></SaveConfig>
            </ma:do-action>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF
