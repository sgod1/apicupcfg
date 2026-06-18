#!/bin/bash

source ./apic.env

export PATH=.:$PATH

keytype=${1:-"ed25519"}

projectdir=${APICUP_CONFIG}
keyfile=${KEYFILE}

outdir=$projectdir/ssh
outkey=$outdir/$keyfile

if [[ ! -d $projectdir ]]; then
   echo run 1-apicup-init.sh script before running this script
   exit 1
fi

mkdir -p $outdir

if [[ -f $outkey ]]; then
   echo private key file $outkey already exists, no overwrite.
   exit 1
fi

ssh-keygen -t $keytype -f $outkey
