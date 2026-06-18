#!/bin/bash

export PATH=.:$PATH

source ../config-funcs.sh

set -x

dpcfg=$1
zomafile=$2

# input: compute with jq
datapower_domain=$(strip_quotes $(jq '.Gateway.DatapowerDomain' $dpcfg))

echo writing file $zomafile

cat<<EOF > $zomafile
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request>
            <ma:set-config>
                <Domain name="$datapower_domain">
                    <mAdminState>enabled</mAdminState>
                    <UserSummary>api connect domain</UserSummary>
                    <NeighborDomain>default</NeighborDomain>
                </Domain>
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF
