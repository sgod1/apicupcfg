#!/bin/bash

export PATH=.:$PATH

source apic.env

projectdir=${1:-"$APICUP_CONFIG"}

if [[ -d $projectdir ]]; then
   echo project directory $projectdir exists...
   exit 1
fi

set -x

bin/apicup init $projectdir

date > $projectdir/_version
bin/apicup version >> $projectdir/_version

echo linking apicup to $projectdir
ln -s ../bin/apicup $projectdir
