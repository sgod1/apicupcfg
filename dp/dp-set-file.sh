#!/bin/bash

export PATH=.:$PATH

source ../config-funcs.sh

dpcfg=$1
inpath=$2
zomapath=$3
dppath=$4

# input domain, jq
domain=$(strip_quotes $(jq '.Gateway.DatapowerDomain' $dpcfg))

b64data=$(cat $inpath | base64)

echo writing file $zomapath

cat<<EOF > $zomapath
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request domain="$domain">
            <ma:set-file name="$dppath">$b64data</ma:set-file>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF

