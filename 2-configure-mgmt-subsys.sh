#!/bin/zsh

export PATH=.:$PATH

source apic.env
source config-funcs.sh

cyaml=${1:-"apicupcfg.json"}

project=${2:-"$APICUP_CONFIG"}

# create
outfile="$project/subsys-mgmt-init.sh"

echo "#!/bin/bash" > $outfile
echo "" >> $outfile
echo 'export PATH=.:$PATH' >> $outfile
echo "set -x" >> $outfile
echo "" >> $outfile

# accept license
license=$(jq '.License' $cyaml)
echo apicup licenses accept $license >> $outfile

# create management subsystem
subsys_name=$(strip_quotes $(jq '.Management.SubsysName' $cyaml))
echo apicup subsys create $subsys_name management >> $outfile

# done
chmod +x $outfile

# config
outfile="$project/subsys-mgmt-config.sh"

echo "#!/bin/bash" > $outfile
echo "" >> $outfile
echo 'export PATH=.:$PATH' >> $outfile
echo "set -x" >> $outfile
echo "" >> $outfile

# license use for management subsys
license_use=$(jq '.LicenseUse' $cyaml)
echo apicup subsys set $subsys_name license-use=$license_use >> $outfile

# deployment profile for management subsys
deployment_profile=$(jq '.DeploymentProfile' $cyaml)
subsys_deployment_profile=$(jq '.Management.DeploymentProfile' $cyaml)
if (isset $subsys_deployment_profile); then deployment_profile=$subsys_deployment_profile; fi
echo apicup subsys set $subsys_name deployment-profile=$deployment_profile >> $outfile

# backup
backup_protocol=$(jq '.Management.DatabaseBackup."database-backup-protocol"' $cyaml)
echo "" >> $outfile
echo apicup subsys set $subsys_name database-backup-protocol=$backup_protocol >> $outfile

backup_auth_user=$(jq '.Management.DatabaseBackup."database-backup-auth-user"' $cyaml)
echo apicup subsys set $subsys_name database-backup-auth-user="$backup_auth_user" >> $outfile

# use public key, or set env var for password
#backup_auth_pass=$(jq '.Management.DatabaseBackup."database-backup-auth-pass"' $cyaml)
backup_auth_pass=""
echo apicup subsys set $subsys_name database-backup-auth-pass="$backup_auth_pass" >> $outfile

backup_auth_ssh_key=$(jq '.Management.DatabaseBackup."database-backup-auth-ssh-key"' $cyaml)
echo apicup certs set $subsys_name database-backup-auth-ssh-key $backup_auth_ssh_key >> $outfile

backup_host=$(jq '.Management.DatabaseBackup."database-backup-host"' $cyaml)
echo apicup subsys set $subsys_name database-backup-host=$backup_host >> $outfile

backup_port=$(jq '.Management.DatabaseBackup."database-backup-port"' $cyaml)
echo apicup subsys set $subsys_name database-backup-port=$backup_port >> $outfile

backup_path=$(jq '.Management.DatabaseBackup."database-backup-path"' $cyaml)
echo apicup subsys set $subsys_name database-backup-path="$backup_path" >> $outfile

backup_schedule=$(jq '.Management.DatabaseBackup."database-backup-schedule"' $cyaml)
echo apicup subsys set $subsys_name database-backup-schedule="$backup_schedule" >> $outfile

backup_retention=$(jq '.Management.DatabaseBackup."database-backup-repo-retention-full"' $cyaml)
echo apicup subsys set $subsys_name database-backup-repo-retention-full=$backup_retention >> $outfile

# logging for management subsys

# search domains, comma separated
search_domains=$(jq '.SearchDomains.[]' $cyaml)
subsys_search_domains=$(jq '.Management.SearchDomains.[]' $cyaml)
if (isset $subsys_search_domains); then search_domains=$subsys_search_domains; fi
echo "" >> $outfile
echo apicup subsys set $subsys_name search-domain=$search_domains >> $outfile

# dns servers, comma separated
dns_servers=$(jq '.VmFirstBoot.DnsServers.[]' $cyaml)
subsys_dns_servers=$(jq '.Management.VmFirstBoot.DnsServers.[]' $cyaml)
if (isset $subsys_dns_servers); then dns_servers=$subsys_dns_servers; fi
echo apicup subsys set $subsys_name dns-servers=$dns_servers >> $outfile

# ssh public key file for the management subsystem
echo apicup subsys set $subsys_name ssh-keyfiles=ssh/${KEYFILE}.pub >> $outfile

# vmware hashed passsword for the management subsystem
salt=$SUBSYS_CONSOLE_PASSWORD_SALT
consolepass=$SUBSYS_CONSOLE_PASSWORD
echo apicup subsys set $subsys_name default-password=$(password_hash $consolepass $salt) >> $outfile

# ip ranges for pods, management subsystem
pod_network=$(jq '.VmFirstBoot.IpRanges.PodNetwork' $cyaml)
subsys_pod_network=$(jq '.Management.VmFirstBoot.IpRanges.PodNetwork' $cyaml)
if (isset $subsys_pod_network); then pod_network=$subsys_pod_network; fi
echo apicup subsys set $subsys_name k8s-pod-network=$pod_network >> $outfile

# ip ranges for services, management subsystem
service_network=$(jq '.VmFirstBoot.IpRanges.ServiceNetwork' $cyaml)
subsys_service_network=$(jq '.Management.VmFirstBoot.IpRanges.ServiceNetwork' $cyaml)
if (isset $subsys_service_network); then service_network=$subsys_service_network; fi
echo apicup subsys set $subsys_name k8s-service-network=$service_network >> $outfile

# host 1
device=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[0]| .Device' $cyaml))
hostname=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[0]| .Name' $cyaml))
ipaddress=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[0]| .IpAddress' $cyaml))
subnetmask=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[0]| .SubnetMask' $cyaml))
gateway=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[0]| .Gateway' $cyaml))
echo "" >> $outfile
echo apicup hosts create $subsys_name $hostname $DISK_PASSWORD >> $outfile
echo "apicup iface create $subsys_name $hostname $device $ipaddress/$subnetmask $gateway" >> $outfile

# host 2
device=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[1]| .Device' $cyaml))
hostname=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[1]| .Name' $cyaml))
ipaddress=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[1]| .IpAddress' $cyaml))
subnetmask=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[1]| .SubnetMask' $cyaml))
gateway=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[1]| .Gateway' $cyaml))
if (isset $hostname); then
echo apicup hosts create $subsys_name $hostname $DISK_PASSWORD >> $outfile
echo "apicup iface create $subsys_name $hostname $device $ipaddress/$subnetmask $gateway" >> $outfile
fi

# host 3
device=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[2]| .Device' $cyaml))
hostname=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[2]| .Name' $cyaml))
ipaddress=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[2]| .IpAddress' $cyaml))
subnetmask=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[2]| .SubnetMask' $cyaml))
gateway=$(strip_quotes $(jq '.Management.VmFirstBoot.Hosts[2]| .Gateway' $cyaml))
if (isset $hostname); then
echo apicup hosts create $subsys_name $hostname $DISK_PASSWORD >> $outfile
echo "apicup iface create $subsys_name $hostname $device $ipaddress/$subnetmask $gateway" >> $outfile
fi

# management subsys endpoints
platform_api=$(jq '.Management.PlatformApi' $cyaml)
echo "" >> $outfile
echo apicup subsys set $subsys_name platform-api=$platform_api >> $outfile

consumer_api=$(jq '.Management.ConsumerApi' $cyaml)
echo apicup subsys set $subsys_name consumer-api=$consumer_api >> $outfile

cloud_admin_ui=$(jq '.Management.CloudAdminUi' $cyaml)
echo apicup subsys set $subsys_name cloud-admin-ui=$cloud_admin_ui >> $outfile

api_manager_ui=$(jq '.Management.ApiManagerUi' $cyaml)
echo apicup subsys set $subsys_name api-manager-ui=$api_manager_ui >> $outfile

# user facing certificates

# platform-api
certdir=$(jq '.Management.UserFacingCerts."platform-api".certdir' $cyaml)
privkey=$(jq '.Management.UserFacingCerts."platform-api".key' $cyaml)
cert=$(jq '.Management.UserFacingCerts."platform-api".cert' $cyaml)
ca=$(jq '.Management.UserFacingCerts."platform-api".ca' $cyaml)

certdir=${certdir//\"/}; privkey=${privkey//\"/}; cert=${cert//\"/}; ca=${ca//\"/}
cp -r $certdir $project

echo "" >> $outfile
echo "apicup certs set $subsys_name platform-api $certdir/$cert $certdir/$privkey $certdir/$ca" >> $outfile

# cloud-admin-ui
certdir=$(jq '.Management.UserFacingCerts."cloud-admin-ui".certdir' $cyaml)
privkey=$(jq '.Management.UserFacingCerts."cloud-admin-ui".key' $cyaml)
cert=$(jq '.Management.UserFacingCerts."cloud-admin-ui".cert' $cyaml)
ca=$(jq '.Management.UserFacingCerts."cloud-admin-ui".ca' $cyaml)

certdir=${certdir//\"/}; privkey=${privkey//\"/}; cert=${cert//\"/}; ca=${ca//\"/}
cp -r $certdir $project

echo "apicup certs set $subsys_name cloud-admin-ui $certdir/$cert $certdir/$privkey $certdir/$ca" >> $outfile

# api-manager-ui
certdir=$(jq '.Management.UserFacingCerts."api-manager-ui".certdir' $cyaml)
privkey=$(jq '.Management.UserFacingCerts."api-manager-ui".key' $cyaml)
cert=$(jq '.Management.UserFacingCerts."api-manager-ui".cert' $cyaml)
ca=$(jq '.Management.UserFacingCerts."api-manager-ui".ca' $cyaml)

certdir=${certdir//\"/}; privkey=${privkey//\"/}; cert=${cert//\"/}; ca=${ca//\"/}
cp -r $certdir $project

echo "apicup certs set $subsys_name api-manager-ui $certdir/$cert $certdir/$privkey $certdir/$ca" >> $outfile

# consumer-api
certdir=$(jq '.Management.UserFacingCerts."consumer-api".certdir' $cyaml)
privkey=$(jq '.Management.UserFacingCerts."consumer-api".key' $cyaml)
cert=$(jq '.Management.UserFacingCerts."consumer-api".cert' $cyaml)
ca=$(jq '.Management.UserFacingCerts."consumer-api".ca' $cyaml)

certdir=${certdir//\"/}; privkey=${privkey//\"/}; cert=${cert//\"/}; ca=${ca//\"/}
cp -r $certdir $project
echo "apicup certs set $subsys_name consumer-api $certdir/$cert $certdir/$privkey $certdir/$ca" >> $outfile

# ntp server
ntp_server=$(jq '.NTPServer' $cyaml)
subsys_ntp_server=$(jq '.Management.NTPServer' $cyaml)
if (isset $subsys_ntp_server); then ntp_server=$subsys_ntp_server; fi

subsys_name_no_qt=$(strip_quotes $subsys_name)
cloud_init_file=cloud-init/${subsys_name_no_qt}-cloud-init.yaml

echo "" >> $outfile
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
