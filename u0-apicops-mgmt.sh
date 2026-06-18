#!/bin/bash

# one one vm only
ansible mgmt_1 -a "apicops system:pre-upgrade-check management"

apicops preupgrade --no-topology -n <namespace>
