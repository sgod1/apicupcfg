#!/bin/bash

export PATH=.:$PATH

source config-funcs.sh

apicupcfg=$1
invdir=${2:-"inventory"}
invhosts=${3:-"hosts"}

if [[ -z $apicupcfg ]]; then
   echo apicupcfg parameter required
   exit 1
fi

if [[ ! -f $apicupcfg ]]; then
   echo $apicupcfg file not found
   exit
fi

mkdir -p $invdir
outfile=$invdir/$invhosts

# management subsystem
m1=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[0].Name' $apicupcfg))
m2=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[1].Name' $apicupcfg))
m3=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[2].Name' $apicupcfg))

if [[ $m1 == null ]]; then m1=""; fi
if [[ $m2 == null ]]; then m2=""; fi
if [[ $m3 == null ]]; then m3=""; fi

echo writing inventory file $outfile

cat<<EOF > $outfile
[all:vars]
ansible_user=apicadm
ansible_ssh_private_key_file=/Users/simon/apic/apic/apicup-config/ssh/key

[mgmt_subsys]
$m1
$m2
$m3

[mgmt_1]
$m1

[mgmt_2]
$m2

[mgmt_3]
$m3
EOF

# analytics subsystem
a1=$(strip_quotes $(jq '.Analytics.VmFirstBoot.Hosts[0].Name' $apicupcfg))
a2=$(strip_quotes $(jq '.Analytics.VmFirstBoot.Hosts[1].Name' $apicupcfg))
a3=$(strip_quotes $(jq '.Analytics.VmFirstBoot.Hosts[2].Name' $apicupcfg))

if [[ $a1 == null ]]; then a1=""; fi
if [[ $a2 == null ]]; then a2=""; fi
if [[ $a3 == null ]]; then a3=""; fi

cat<<EOF >> $outfile

[alyt_subsys]
$a1
$a2
$a3

[alyt_1]
$a1

[alyt_2]
$a2

[alyt_3]
$a3
EOF

# portal subsystem
p1=$(strip_quotes $(jq '.Portal.VmFirstBoot.Hosts[0].Name' $apicupcfg))
p2=$(strip_quotes $(jq '.Portal.VmFirstBoot.Hosts[1].Name' $apicupcfg))
p3=$(strip_quotes $(jq '.Portal.VmFirstBoot.Hosts[2].Name' $apicupcfg))

if [[ $p1 == null ]]; then p1=""; fi
if [[ $p2 == null ]]; then p2=""; fi
if [[ $p3 == null ]]; then p3=""; fi

cat<<EOF >> $outfile

[ptl_subsys]
$p1
$p2
$p3

[ptl_1]
$p1

[ptl_2]
$p2

[ptl_3]
$p3
EOF

# gateway subsystem
dp0=$(strip_quotes $(jq .Gateway.Datapower[0].ManagementInterface $apicupcfg))
dp1=$(strip_quotes $(jq .Gateway.Datapower[0].ManagementInterface $apicupcfg))
dp2=$(strip_quotes $(jq .Gateway.Datapower[0].ManagementInterface $apicupcfg))

# management backup 
mbkp=$(strip_quotes $(jq '.Management.DatabaseBackup."database-backup-host"' $apicupcfg))
cat<<EOF >> $outfile

[mgmt_subsys_backup]
$mbkp
EOF

# analytics backup 
abkp=$(strip_quotes $(jq '.Analytics.DatabaseBackup."database-backup-host"' $apicupcfg))
cat<<EOF >> $outfile

[alyt_subsys_backup]
$abkp
EOF

# portal backup 
pbkp=$(strip_quotes $(jq '.Portal.SiteBackup."database-backup-host"' $apicupcfg))
cat<<EOF >> $outfile

[ptl_subsys_backup]
$pbkp
EOF

