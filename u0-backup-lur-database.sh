#!/bin/bash


kubectl -n default exec -it `kubectl -n default get po -l role=primary -o name` -- pg_dump -c lur > lur_pre_upgrade.sql
