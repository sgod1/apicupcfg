#!/bin/bash

# backup mgmt subsystem
apicup subsys backup mgmt

apicup subsys mgmt list-backups --detailed-output=true
