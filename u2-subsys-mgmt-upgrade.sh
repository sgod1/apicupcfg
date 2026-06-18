#!/bin/bash

# all mgmt vms
ansible mgmt_subsys -a "rm -f /etc/apt/preferences.d/libpq5-preferences"
ansible mgmt_subsys -a "rm -f /etc/apt/preferences.d/shim-preferences"
ansible mgmt_subsys -a "rm -f /etc/apt/preferences.d/shim-signed-preferences"
