#!/bin/bash

export PATH=.:$PATH

dpcfg=$1
prefix=${2:-"gwd"}

# tls profiles
tls-profiles-from-keypair.sh $dpcfg $prefix

# configuration sequence
zoma-config-sequence.sh $dpcfg

# gateway peering
configure-gateway-peering.sh $dpcfg

# api probe settings
zoma-api-probe-settings.sh $dpcfg

# api connect gateway service
zoma-apic-gateway-service.sh $dpcfg $prefix

# jwt security
zoma-jwt-security.sh $dpcfg

# save application domain
zoma-save-config $dpcfg
