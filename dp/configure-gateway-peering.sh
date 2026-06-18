#!/bin/bash

export PATH=.:$PATH

dpcfg=$1

# API Connect gateway service peering
zoma-gwd-peering.sh $dpcfg

# API rate limits peering
zoma-api-rate-limits-peering.sh $dpcfg

# API subscribers 
zoma-api-subscribers-peering.sh $dpcfg

# API probe data 
zoma-api-probe-peering.sh $dpcfg

# GatewayScript ratelimit module keys
zoma-gs-rate-limit-peering.sh $dpcfg

# gateway peering manager
zoma-peering-manager.sh $dpcfg
