#!/bin/bash

source ../config-funcs.sh

dpcfg=$1
zomafile=$2

# hard-wired
config_seq_name=apiconnect

# jq input
config_exec_interval=3000

# jq input
domain=$(strip_quotes $(jq '.Gateway.DatapowerDomain' $dpcfg))

echo writing file $zomafile

cat<<EOF > $zomafile
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request domain="$domain">
            <ma:set-config>
                <ConfigSequence name="$config_seq_name">
                    <mAdminState>enabled</mAdminState>
                    <UserSummary>API Connect Configuration</UserSummary>
                    <Locations>
                        <Directory>local:///</Directory>
                        <AccessProfileName/>
                    </Locations>
                    <MatchPattern>(.*)\.cfg$</MatchPattern>
                    <ResultNamePattern>\$1.log</ResultNamePattern>
                    <StatusNamePattern>\$1.status</StatusNamePattern>
                    <Watch>on</Watch>
                    <UseOutputLocation>off</UseOutputLocation>
                    <OutputLocation>logtemp:///</OutputLocation>
                    <DeleteUnused>on</DeleteUnused>
                    <RunSequenceInterval>$config_exec_interval</RunSequenceInterval>
                </ConfigSequence>
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF

