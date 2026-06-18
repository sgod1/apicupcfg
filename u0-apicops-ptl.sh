#!/bin/bash

# one vm only
ansible ptl_1 -a "apicops system:pre-upgrade-check portal"
