#!/bin/bash

export PATH=.:$PATH

source ../config-funcs.sh

set -x

dpcfg=$1
zomafile=$2

# input: compute with jq
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
<GatewayPeeringManager xmlns:env="http://www.w3.org/2003/05/soap-envelope" name="default" intrinsic="true">
   <mAdminState>enabled</mAdminState>
   <APIConnectGatewayService class="GatewayPeering">gwd</APIConnectGatewayService>
   <RateLimit class="GatewayPeering">api-ratelimits</RateLimit>
   <Subscription class="GatewayPeering">api-subscribers</Subscription>
   <APIProbe class="GatewayPeering">api-probe</APIProbe>
   <RatelimitModule class="GatewayPeering">gs-ratelimits</RatelimitModule>
</GatewayPeeringManager>
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF
