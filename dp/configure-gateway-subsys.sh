#!/bin/bash

export PATH=.:$PATH

apicupcfg=${1:-"../apicupcfg.yaml"}

dpcfg.sh $apicupcfg

configure_datapower zoma/dp1.cfg $apicupcfg
configure_datapower zoma/dp2.cfg $apicupcfg
configure_datapower zoma/dp3.cfg $apicupcfg
