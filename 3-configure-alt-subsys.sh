#!/bin/bash

export PATH=.:$PATH

source apic.env
source config-funcs.sh

cyaml=${1:-"apicupcfg.json"}

project=${2:-"$APICUP_CONFIG"}

# init
outfile="$project/subsys-alt-init.sh"

echo "#!/bin/bash" > $outfile
echo 'export PATH=.:$PATH' >> $outfile
echo "set -x" >> $outfile

# accept license
# accept license
license=$(jq '.License' $cyaml)
echo apicup licenses accept $license >> $outfile

# create subsystem
subsys_name=$(strip_quotes $(jq '.Analytics.SubsysName' $cyaml))
echo apicup subsys create $subsys_name analytics >> $outfile

# done
chmod +x $outfile

# config
outfile="$project/subsys-alt-config.sh"

echo "#!/bin/bash" > $outfile
echo 'export PATH=.:$PATH' >> $outfile
echo "set -x" >> $outfile

# license use
license_use=$(jq '.LicenseUse' $cyaml)
echo apicup subsys set $subsys_name license-use=$license_use >> $outfile

# deployment profile
deployment_profile=$(jq '.Analytics.DeploymentProfile' $cyaml)
subsys_deployment_profile=$(jq '.Analytics.DeploymentProfile' $cyaml)
if (isset $subsys_deployment_profile); then deployment_profile=$subsys_deployment_profile; fi
echo apicup subsys set $subsys_name deployment-profile=$deployment_profile >> $outfile

# backup
backup_protocol=$(jq '.Analytics.AnalyticsBackup."analytics-backup-protocol"' $cyaml)
echo "" >> $outfile
echo apicup subsys set $subsys_name analytics-backup-protocol=$backup_protocol >> $outfile

backup_auth_user=$(jq '.Analytics.AnalyticsBackup."analytics-backup-auth-user"' $cyaml)
echo apicup subsys set $subsys_name analytics-backup-auth-user="$backup_auth_user" >> $outfile

# no password, use public key
#backup_auth_pass=$(jq '.Analytics.AnalyticsBackup."analytics-backup-auth-pass"' $cyaml)
backup_pass=""
echo apicup subsys set $subsys_name analytics-backup-auth-pass="$backup_auth_pass" >> $outfile

#backup_auth_ssh_key=$(jq '.Analytics.AnalyticsBackup."analytics-backup-auth-ssh-key"' $cyaml)
#echo apicup certs set $subsys_name analytics-backup-auth-ssh-key $backup_auth_ssh_key >> $outfile

backup_host=$(jq '.Analytics.AnalyticsBackup."analytics-backup-host"' $cyaml)
echo apicup subsys set $subsys_name analytics-backup-host=$backup_host >> $outfile

backup_port=$(jq '.Analytics.AnalyticsBackup."analytics-backup-port"' $cyaml)
echo apicup subsys set $subsys_name analytics-backup-port=$backup_port >> $outfile

backup_path=$(jq '.Analytics.AnalyticsBackup."analytics-backup-path"' $cyaml)
echo apicup subsys set $subsys_name analytics-backup-path="$backup_path" >> $outfile

backup_schedule=$(jq '.Analytics.AnalyticsBackup."analytics-backup-schedule"' $cyaml)
echo apicup subsys set $subsys_name analytics-backup-schedule="$backup_schedule" >> $outfile

backup_scope=$(jq '.Analytics.AnalyticsBackup."analytics-backup-scope"' $cyaml)
echo apicup subsys set $subsys_name analytics-backup-scope=$backup_scope >> $outfile

backup_certs=$(jq '.Analytics.AnalyticsBackup."analytics-backup-certs"' $cyaml)
echo apicup subsys set $subsys_name analytics-backup-certs=$backup_certs >> $outfile

backup_enabled=$(jq '.Analytics.AnalyticsBackup."analytics-backup-enabled"' $cyaml)
echo apicup subsys set $subsys_name analytics-backup-enabled=$backup_enabled >> $outfile
echo "" >> $outfile

# logging

# search domains, comma separated
search_domains=$(jq '.SearchDomains.[]' $cyaml)
subsys_search_domains=$(jq '.Analytics.SearchDomains.[]' $cyaml)
if (isset $subsys_search_domains); then search_domains=$subsys_search_domains; fi
echo apicup subsys set $subsys_name search-domain=$search_domains >> $outfile

# dns servers, comma separated
dns_servers=$(jq '.VmFirstBoot.DnsServers.[]' $cyaml)
subsys_dns_servers=$(jq '.Analytics.VmFirstBoot.DnsServers.[]' $cyaml)
if (isset $subsys_dns_servers); then dns_servers=$subsys_dns_servers; fi
echo apicup subsys set $subsys_name dns-servers=$dns_servers >> $outfile

# ssh public key files, comma separated
echo apicup subsys set $subsys_name ssh-keyfiles=ssh/${KEYFILE}.pub >> $outfile

# hashed passsword
salt=$SUBSYS_CONSOLE_PASSWORD_SALT
consolepass=$SUBSYS_CONSOLE_PASSWORD
echo apicup subsys set $subsys_name default-password=$(password_hash $consolepass $salt) >> $outfile

# ip ranges for pods, analytics subsystem
pod_network=$(jq '.VmFirstBoot.IpRanges.PodNetwork' $cyaml)
subsys_pod_network=$(jq '.Analytics.VmFirstBoot.IpRanges.PodNetwork' $cyaml)
if (isset $subsys_pod_network); then pod_network=$subsys_pod_network; fi
echo apicup subsys set $subsys_name k8s-pod-network=$pod_network >> $outfile

# ip ranges for services, analytics subsystem
service_network=$(jq '.VmFirstBoot.IpRanges.ServiceNetwork' $cyaml)
subsys_service_network=$(jq '.Analytics.VmFirstBoot.IpRanges.ServiceNetwork' $cyaml)
if (isset $subsys_service_network); then service_network=$subsys_service_network; fi
echo apicup subsys set $subsys_name k8s-service-network=$service_network >> $outfile

# host 1
device=$(jq '.Analytics.VmFirstBoot.Hosts[0]| .Device' $cyaml)
hostname=$(jq '.Analytics.VmFirstBoot.Hosts[0]| .Name' $cyaml)
ipaddress=$(jq '.Analytics.VmFirstBoot.Hosts[0]| .IpAddress' $cyaml)
subnetmask=$(jq '.Analytics.VmFirstBoot.Hosts[0]| .SubnetMask' $cyaml)
gateway=$(jq '.Analytics.VmFirstBoot.Hosts[0]| .Gateway' $cyaml)
echo "" >> $outfile
echo apicup hosts create $subsys_name $hostname $DISK_PASSWORD >> $outfile
echo "apicup iface create $subsys_name $hostname $device $ipaddress/$subnetmask $gateway" >> $outfile

# host 2
device=$(jq '.Analytics.VmFirstBoot.Hosts[1]| .Device' $cyaml)
hostname=$(jq '.Analytics.VmFirstBoot.Hosts[1]| .Name' $cyaml)
ipaddress=$(jq '.Analytics.VmFirstBoot.Hosts[1]| .IpAddress' $cyaml)
subnetmask=$(jq '.Analytics.VmFirstBoot.Hosts[1]| .SubnetMask' $cyaml)
gateway=$(jq '.Analytics.VmFirstBoot.Hosts[1]| .Gateway' $cyaml)
if (isset $hostname); then
echo apicup hosts create $subsys_name $hostname $DISK_PASSWORD >> $outfile
echo "apicup iface create $subsys_name $hostname $device $ipaddress/$subnetmask $gateway" >> $outfile
fi

# host 3
device=$(jq '.Analytics.VmFirstBoot.Hosts[2]| .Device' $cyaml)
hostname=$(jq '.Analytics.VmFirstBoot.Hosts[2]| .Name' $cyaml)
ipaddress=$(jq '.Analytics.VmFirstBoot.Hosts[2]| .IpAddress' $cyaml)
subnetmask=$(jq '.Analytics.VmFirstBoot.Hosts[2]| .SubnetMask' $cyaml)
gateway=$(jq '.Analytics.VmFirstBoot.Hosts[2]| .Gateway' $cyaml)
if (isset $hostname); then
echo apicup hosts create $subsys_name $hostname $DISK_PASSWORD >> $outfile
echo "apicup iface create $subsys_name $hostname $device $ipaddress/$subnetmask $gateway" >> $outfile
fi

# analytics subsys endpoints
alyt_ingestion=$(jq '.Analytics.AnalyticsIngestion' $cyaml)
echo "" >> $outfile
echo apicup subsys set $subsys_name analytics-ingestion=$alyt_ingestion >> $outfile

# user facing certs

# ntp server and cloud-init file
ntp_server=$(jq '.NTPServer' $cyaml)
subsys_ntp_server=$(jq '.Analytics.NTPServer' $cyaml)
if (isset $subsys_ntp_server); then ntp_server=$subsys_ntp_server; fi

subsys_name_no_qt=$(strip_quotes $subsys_name)
cloud_init_file=cloud-init/${subsys_name_no_qt}-cloud-init.yaml

echo "mkdir -p cloud-init" >> $outfile
echo "cat<<EOF > $cloud_init_file" >> $outfile
cat <<EOF >> $outfile
ntp:
  enabled: true
  ntp_client: systemd-timesyncd
  servers:
    - $ntp_server
EOF
echo "EOF" >> $outfile

echo "apicup subsys set $subsys_name additional-cloud-init-file $cloud_init_file" >> $outfile

# done
chmod +x $outfile

echo ""
echo writing output to: $outfile
echo ""

cat $outfile
