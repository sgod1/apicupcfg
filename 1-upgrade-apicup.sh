#!/bin/bash

export PATH=.:$PATH

caseenv=$1

if [[ -z $caseenv ]]; then
   echo caseenv argument required
   exit 1
fi

if [[ ! -f $caseenv ]]; then
   echo caseenv file $caseenv not found
   exit 1
fi

source $caseenv

# write version upgrade file

# link apicup
