#!/bin/bash
export PATH=.:$PATH

source ../config-funcs.sh

set -x

dpcfg=$1
prefix=$2
zomafile=$3

# input: compute with jq
domain=$(strip_quotes $(jq '.Gateway.DatapowerDomain' $dpcfg))

service_alias=
local_port=
tls_client_profile=$prefix
tls_server_profile=$prefix
api_gateway_alias=
api_gateway_port=
gateway_peering=gwd

echo writing file $zomafile

cat<<EOF > $zomafile
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
                   xmlns:ma="http://www.datapower.com/schemas/management">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ma:request domain="$domain">
            <ma:set-config>
<APIConnectGatewayService xmlns:env="http://www.w3.org/2003/05/soap-envelope" name="default" intrinsic="true">
	<mAdminState>enabled</mAdminState>
	<LocalAddress>0.0.0.0</LocalAddress>
	<LocalPort>3000</LocalPort>
	<SSLClient class="SSLClientProfile">gwd1</SSLClient>
	<SSLServer class="SSLServerProfile">gwd1</SSLServer>
	<APIGatewayAddress>0.0.0.0</APIGatewayAddress>
	<APIGatewayPort>443</APIGatewayPort>
	<GatewayPeering class="GatewayPeering">gwd</GatewayPeering>
	<GatewayPeeringManager class="GatewayPeeringManager">default</GatewayPeeringManager>
	<V5CompatibilityMode>off</V5CompatibilityMode>
	<UserDefinedPolicies class="AssemblyFunction">validate-usernametoken_1.1.0</UserDefinedPolicies>
	<UserDefinedPolicies class="AssemblyFunction">token-mediation_2.0.0</UserDefinedPolicies>
	<V5CSlmMode>autounicast</V5CSlmMode>
	<IPUnicast/>
	<JWTValidationMode>request</JWTValidationMode>
	<ProxyPolicy>
		<ProxyPolicyEnable>off</ProxyPolicyEnable>
		<RemoteAddress/>
		<RemotePort>0</RemotePort>
		<UserName/>
		<Password/>
	</ProxyPolicy>
</APIConnectGatewayService>
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF
