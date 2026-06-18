#!/bin/bash


kubectl -n default exec -it `kubectl -n default get po -l role=primary -o name` -- pg_dump -c apim > apim_pre_upgrade.sql
