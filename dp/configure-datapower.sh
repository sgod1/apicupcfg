#!/bin/bash

export PATH=.:$PATH

dpcfg=$1
apicupcfg=${2:-"../apicupcfg.yaml"}

configure_default_domain $dpcfg $apicupcfg
configure_apic_domain $dpcfg $apicupcfg
