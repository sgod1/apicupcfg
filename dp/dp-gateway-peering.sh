#!/bin/bash

source ../config-funcs.sh

set -x

dpcfg=$1
group=$2
zomafile=$3

host_alias=$(strip_quotes $(jq .Gateway.GatewayPeering.\"$group\".HostAlias $dpcfg))
local_port=$(strip_quotes $(jq .Gateway.GatewayPeering.\"$group\".LocalPort $dpcfg))
monitor_port=$(strip_quotes $(jq .Gateway.GatewayPeering.\"$group\".MonitorPort $dpcfg))
enable_peer_group="off"
priority=$(strip_quotes $(jq ".Gateway.GatewayPeering.\"$group\".Priority" $dpcfg))
user_summary="APIC gateway peering"

peer1=""
peer2=""

enable_ssl=off
idcred=""
valcred=""

persistence_location="memory"
local_directory="local:///"

# jq query
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
                <GatewayPeering name="$group">
                    <mAdminState>enabled</mAdminState>
                    <UserSummary>$user_summary</UserSummary>
                    <LocalAddress>$host_alias</LocalAddress>
                    <LocalPort>$local_port</LocalPort>
                    <MonitorPort>$monitor_port</MonitorPort>
                    <EnablePeerGroup>$enable_peer_group</EnablePeerGroup>
                    <Peers>$peer1</Peers>
                    <Peers>$peer2</Peers>
                    <Priority>$priority</Priority>
                    <EnableSSL>$enable_ssl</EnableSSL>
                    <Idcred>$idcred</Idcred>
                    <Valcred>$valcred</Valcred>
                    <PersistenceLocation>$persistence_location</PersistenceLocation>
                    <LocalDirectory>$local_directory</LocalDirectory>
                </GatewayPeering>
            </ma:set-config>
        </ma:request>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF

