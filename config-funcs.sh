#!/bin/bash

function isset() {
   if [[ ! ($1 == "" || $1 == null) ]]; then return 0; else return 1; fi
}

function password_hash() {
   local password=$1
   local salt=$2
   openssl passwd -1 -salt $salt $password
}

function strip_quotes() {
   echo ${1//\"/}
}
