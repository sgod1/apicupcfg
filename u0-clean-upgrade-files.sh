#!/bin/bash

export PATH=.:$PATH

source ans.env

set -x

ansible mgmt_subsys -b -a "apic clean-upgrade-files"
ansible alyt_subsys -b -a "apic clean-upgrade-files"
ansible ptl_subsys -b -a "apic clean-upgrade-files"

