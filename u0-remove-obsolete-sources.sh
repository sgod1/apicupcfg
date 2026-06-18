#!/bin/bash

export PATH=.:$PATH

source ans.env

set -x

ansible mgmt_subsys -b -a "ls /etc/apt/sources.list.d/repo-*.list"
ansible alyt_subsys -b -a "ls /etc/apt/sources.list.d/repo-*.list"
ansible ptl_subsys -b -a "ls /etc/apt/sources.list.d/repo-*.list"

