#!/bin/bash

export PATH=.:$PATH

source dp.env

source ../config-funcs.sh

dpcfg=$1
zoma_xml=$2

if [[ -z $zoma_xml ]]; then
   echo zoma xml file argument required
   exit 1
fi

if [[ ! -f $zoma_xml ]]; then
   echo zoma file $zoma_xml not found
   exit 1
fi

#zoma_url=https://apicdp1.roky.szesto.io:5550/service/mgmt/current

zoma_url=$(strip_quotes $(jq '.Gateway.Datapower[0].ManagementInterface' $dpcfg))
zoma_url=${zoma_url}/service/mgmt/current

#<?xml version="1.0" encoding="UTF-8"?>
#<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
#<env:Body><dp:response xmlns:dp="http://www.datapower.com/schemas/management">
#<dp:timestamp>2026-06-09T20:36:25-04:00</dp:timestamp>
#<dp:result>OK</dp:result></dp:response></env:Body></env:Envelope>

user=$dp_env_user
password=$dp_env_password

set -x

curl -k -X POST -u "$user:$password" -H "Content-Type: application/xml" -d @$zoma_xml $zoma_url
