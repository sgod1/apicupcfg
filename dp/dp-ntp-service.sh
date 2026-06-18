#!/bin/bash

export PATH=.:$PATH

source ../config-funcs.sh
source ../config-funcs.sh

dpcfg=$1
zomafile=$2

ntp_server=$(strip_quotes $(jq '.NTPServer' $dpcfg))
subsys_ntp_server=$(strip_quotes $(jq '.Gateway.NTPServer' $dpcfg))
if (isset $subsys_ntp_server); then ntp_server=$subsys_ntp_server; fi

echo writing file $zomafile

cat<<EOF > $zomafile
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request domain="default">
            <ma:set-config>
                <NTPService>
                    <mAdminState>enabled</mAdminState>
                    <UserSummary></UserSummary>
                    <RemoteServer>$ntp_server</RemoteServer>
                    <RefreshInterval>900</RefreshInterval>
                </NTPService>
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF

