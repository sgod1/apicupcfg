#!/bin/bash

export PATH=.:$PATH

source apic.env
source config-funcs.sh

cyaml=${1:-"apicupcfg.json"}

project=${2:-"$APICUP_CONFIG"}

outfile="$project/subsys-ptl-init.sh"

echo "#!/bin/bash" > $outfile
echo 'export PATH=.:$PATH' >> $outfile
echo "set -x" >> $outfile

# accept license
license=$(jq '.License' $cyaml)
echo apicup licenses accept $license >> $outfile

# create subsystem
subsys_name=$(jq '.Portal.SubsysName' $cyaml)
echo apicup subsys create $subsys_name portal >> $outfile

# done
chmod +x $outfile

outfile="$project/subsys-ptl-config.sh"

echo "#!/bin/bash" > $outfile
echo 'export PATH=.:$PATH' >> $outfile
echo "set -x" >> $outfile

# license use
license_use=$(jq '.LicenseUse' $cyaml)
echo apicup subsys set $subsys_name license-use=$license_use >> $outfile

# deployment profile
# [n1xc2.m8, n1xc4.m16, n1xc8.m16, n3xc3.m8, n3xc4.m8, n3xc8.m16]
deployment_profile=$(jq '.Portal.DeploymentProfile' $cyaml)
subsys_deployment_profile=$(jq '.Portal.DeploymentProfile' $cyaml)
if (isset $subsys_deployment_profile); then deployment_profile=$subsys_deployment_profile; fi
echo apicup subsys set $subsys_name deployment-profile=$deployment_profile >> $outfile

# backup
backup_protocol=$(jq '.Portal.SiteBackup."site-backup-protocol"' $cyaml)
echo "" >> $outfile
echo apicup subsys set $subsys_name site-backup-protocol=$backup_protocol >> $outfile

auth_user=$(jq '.Portal.SiteBackup."site-backup-auth-user"' $cyaml)
echo apicup subsys set $subsys_name site-backup-auth-user="$auth_user" >> $outfile

# no password, use public key
#auth_pass=$(jq '.Portal.SiteBackup."site-backup-auth-pass"' $cyaml)
auth_pass=""
echo apicup subsys set $subsys_name site-backup-auth-pass="$auth_pass" >> $outfile

backup_auth_ssh_key=$(jq '.Portal.SiteBackup."site-backup-auth-ssh-key"' $cyaml)
echo apicup certs set $subsys_name site-backup-auth-ssh-key $backup_auth_ssh_key >> $outfile

backup_host=$(jq '.Portal.SiteBackup."site-backup-host"' $cyaml)
echo apicup subsys set $subsys_name site-backup-host=$backup_host >> $outfile

backup_port=$(jq '.Portal.SiteBackup."site-backup-port"' $cyaml)
echo apicup subsys set $subsys_name site-backup-port=$backup_port >> $outfile

backup_path=$(jq '.Portal.SiteBackup."site-backup-path"' $cyaml)
echo apicup subsys set $subsys_name site-backup-path="$backup_path" >> $outfile

backup_schedule=$(jq '.Portal.SiteBackup."site-backup-schedule"' $cyaml)
echo apicup subsys set $subsys_name site-backup-schedule="$backup_schedule" >> $outfile

# "site-backup-certs": "",
# "site-backup-s3-uri-style": "",
# "site-priority-list": ""

# logging

# search domains, comma separated
search_domains=$(jq '.SearchDomains.[]' $cyaml)
subsys_search_domains=$(jq '.Portal.SearchDomains.[]' $cyaml)
if (isset $subsys_search_domains); then search_domains=$subsys_search_domains; fi
echo apicup subsys set $subsys_name search-domain=$search_domains >> $outfile

# dns servers, comma separated
dns_servers=$(jq '.VmFirstBoot.DnsServers.[]' $cyaml)
subsys_dns_servers=$(jq '.Portal.VmFirstBoot.DnsServers.[]' $cyaml)
if (isset $subsys_dns_servers); then dns_servers=$subsys_dns_servers; fi
echo apicup subsys set $subsys_name dns-servers=$dns_servers >> $outfile

# ssh public key file for the portal subsystem
echo apicup subsys set $subsys_name ssh-keyfiles=ssh/${KEYFILE}.pub >> $outfile

# vmware hashed passsword for the portal subsystem
salt=$SUBSYS_CONSOLE_PASSWORD_SALT
consolepass=$SUBSYS_CONSOLE_PASSWORD
echo apicup subsys set $subsys_name default-password=$(password_hash $consolepass $salt) >> $outfile

# ip ranges for pods
pod_network=$(jq '.VmFirstBoot.IpRanges.PodNetwork' $cyaml)
subsys_pod_network=$(jq '.Portal.VmFirstBoot.IpRanges.PodNetwork' $cyaml)
if (isset $subsys_pod_network); then pod_network=$subsys_pod_network; fi
echo apicup subsys set $subsys_name k8s-pod-network=$pod_network >> $outfile

# ip ranges for services
service_network=$(jq '.VmFirstBoot.IpRanges.ServiceNetwork' $cyaml)
subsys_service_network=$(jq '.Portal.VmFirstBoot.IpRanges.ServiceNetwork' $cyaml)
if (isset $subsys_service_network); then service_network=$subsys_service_network; fi
echo apicup subsys set $subsys_name k8s-service-network=$service_network >> $outfile

# host 1
device=$(jq '.Portal.VmFirstBoot.Hosts[0]| .Device' $cyaml)
hostname=$(jq '.Portal.VmFirstBoot.Hosts[0]| .Name' $cyaml)
ipaddress=$(jq '.Portal.VmFirstBoot.Hosts[0]| .IpAddress' $cyaml)
subnetmask=$(jq '.Portal.VmFirstBoot.Hosts[0]| .SubnetMask' $cyaml)
gateway=$(jq '.Portal.VmFirstBoot.Hosts[0]| .Gateway' $cyaml)
echo "" >> $outfile
echo apicup hosts create $subsys_name $hostname $DISK_PASSWORD >> $outfile
echo "apicup iface create $subsys_name $hostname $device $ipaddress/$subnetmask $gateway" >> $outfile

# host 2
device=$(jq '.Portal.VmFirstBoot.Hosts[1]| .Device' $cyaml)
hostname=$(jq '.Portal.VmFirstBoot.Hosts[1]| .Name' $cyaml)
ipaddress=$(jq '.Portal.VmFirstBoot.Hosts[1]| .IpAddress' $cyaml)
subnetmask=$(jq '.Portal.VmFirstBoot.Hosts[1]| .SubnetMask' $cyaml)
gateway=$(jq '.Portal.VmFirstBoot.Hosts[1]| .Gateway' $cyaml)
if (isset $hostname); then
echo apicup hosts create $subsys_name $hostname $DISK_PASSWORD >> $outfile
echo "apicup iface create $subsys_name $hostname $device $ipaddress/$subnetmask $gateway" >> $outfile
fi

# host 3
device=$(jq '.Portal.VmFirstBoot.Hosts[2]| .Device' $cyaml)
hostname=$(jq '.Portal.VmFirstBoot.Hosts[2]| .Name' $cyaml)
ipaddress=$(jq '.Portal.VmFirstBoot.Hosts[2]| .IpAddress' $cyaml)
subnetmask=$(jq '.Portal.VmFirstBoot.Hosts[2]| .SubnetMask' $cyaml)
gateway=$(jq '.Portal.VmFirstBoot.Hosts[2]| .Gateway' $cyaml)
if (isset $hostname); then
echo apicup hosts create $subsys_name $hostname $DISK_PASSWORD >> $outfile
echo "apicup iface create $subsys_name $hostname $device $ipaddress/$subnetmask $gateway" >> $outfile
fi

# endpoints
portal_admin=$(jq '.Portal.PortalAdmin' $cyaml)
echo apicup subsys set $subsys_name portal-admin=$portal_admin >> $outfile

portal_www=$(jq '.Portal.PortalWww' $cyaml)
echo apicup subsys set $subsys_name portal-www=$portal_www >> $outfile

# user facing certificates

# portal-www-ingress
certdir=$(jq '.Portal.UserFacingCerts."portal-www-ingress".certdir' $cyaml)
privkey=$(jq '.Portal.UserFacingCerts."portal-www-ingress".key' $cyaml)
cert=$(jq '.Portal.UserFacingCerts."portal-www-ingress".cert' $cyaml)
ca=$(jq '.Portal.UserFacingCerts."portal-www-ingress".ca' $cyaml)

certdir=${certdir//\"/}; privkey=${privkey//\"/}; cert=${cert//\"/}; ca=${ca//\"/}
cp -r $certdir $project

echo "apicup certs set $subsys_name portal-www-ingress $certdir/$cert $certdir/$privkey $certdir/$ca" >> $outfile

# allowed client ip range

# jwt (instead of mtls) for management to portal communication

# ntp server
ntp_server=$(jq '.NTPServer' $cyaml)
subsys_ntp_server=$(jq '.Portal.NTPServer' $cyaml)
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
