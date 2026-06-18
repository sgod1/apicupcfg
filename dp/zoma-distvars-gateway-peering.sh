#!/bin/bash

export PATH=.:$PATH

source zomadir.sh

set -x

group_name="apic-distributed-vars"
gwid="apicdp1"

zomafile=$(_zomadirf dp-gwd-gateway-peering-${group_name}-${gwid}.xml)

# jq '.GatewayPeering.gwd.HostAlias'
local_address="192.168.4.29"

# jq '.GatewayPeering.gwd.LocalPort`
local_port="16390"

# jq '.GatewayPeering.gwd.MonitorPort`
monitor_port="26390"

enable_peer_group="off"

# jq '.GatewayPeering.gwd.Priority'
priority="100"

summary="APIC distributed vars peering"

dp-gateway-peering.sh $zomafile $group_name $local_address $local_port $monitor_port $enable_peer_group $priority "$summary"

call-zoma.sh $zomafile
