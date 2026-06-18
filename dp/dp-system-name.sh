#!/bin/bash

export PATH=.:$PATH

zomadir=zoma
zomafile=$zomadir/dp-system-name.xml

mkdir -p $zomadir

system_name="apicdp1"

echo writing file $zomafile

cat<<EOF > $zomafile
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request domain="default">
            <ma:set-config>
                <SystemSettings>
                    <mAdminState>enabled</mAdminState>
                    <UserSummary></UserSummary>
                    <SystemName>$system_name</SystemName>
                </SystemSettings>
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF

