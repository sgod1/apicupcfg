#!/bin/bash

source ../config-funcs.sh

dpcfg=$1
zomafile=$2

echo writing file $zomafile

cat<<EOF > $zomafile
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request domain="default">
            <ma:set-config>
EOF

host_alias="if_eth0"
ip_address=$(strip_quotes $(jq '.Gateway.Datapower[0].if_eth0' $dpcfg))

cat<<EOF >> $zomafile
<HostAlias xmlns:env="http://www.w3.org/2003/05/soap-envelope" name="$host_alias">
   <mAdminState>enabled</mAdminState>
   <IPAddress>$ip_address</IPAddress>
</HostAlias>
EOF

host_alias="if_eth1"
ip_address=$(strip_quotes $(jq '.Gateway.Datapower[0].if_eth1' $dpcfg))

cat<<EOF >> $zomafile
<HostAlias xmlns:env="http://www.w3.org/2003/05/soap-envelope" name="$host_alias">
   <mAdminState>enabled</mAdminState>
   <IPAddress>$ip_address</IPAddress>
</HostAlias>
EOF

host_alias="if_eth2"
ip_address=$(strip_quotes $(jq '.Gateway.Datapower[0].if_eth2' $dpcfg))

cat<<EOF >> $zomafile
<HostAlias xmlns:env="http://www.w3.org/2003/05/soap-envelope" name="$host_alias">
   <mAdminState>enabled</mAdminState>
   <IPAddress>$ip_address</IPAddress>
</HostAlias>
EOF

host_alias="if_eth3"
ip_address=$(strip_quotes $(jq '.Gateway.Datapower[0].if_eth3' $dpcfg))

cat<<EOF >> $zomafile
<HostAlias xmlns:env="http://www.w3.org/2003/05/soap-envelope" name="$host_alias">
   <mAdminState>enabled</mAdminState>
   <IPAddress>$ip_address</IPAddress>
</HostAlias>
EOF

cat <<EOF >> $zomafile
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF

