#!/bin/bash

export PATH=.:$PATH

dpcfg=$1

# initial datapower configuration
# system identifier
# ip addresses
# enable xml interface
# enable rest interface

# host aliases
zoma-host-alias.sh $dpcfg

# ntp service
zoma-ntp-service.sh $dpcfg

# create application domain
zoma-domain.sh $dpcfg

# save default domain
zoma-save-default-domain.sh $dpcfg
