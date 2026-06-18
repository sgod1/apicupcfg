#!/bin/bash

# one vm only
ansible alyt_m1 -a "apicops system:pre-upgrade-check analytics"
