#!/bin/bash

#apt-get update -qq

/usr/sbin/useradd -m -s /bin/bash $OPSI_USER

echo "$OPSI_USER:$OPSI_PASSWORD" | chpasswd

echo -e "$OPSI_PASSWORD\n$OPSI_PASSWORD\n" | smbpasswd -s -a $OPSI_USER

/usr/sbin/usermod -aG opsiadmin $OPSI_USER

/usr/sbin/usermod -aG pcpatch $OPSI_USER

if [ "$OPSI_BACKEND" == "mysql" ]; then

/usr/bin/opsi-setup --configure-mysql --unattended='{"address":"'$OPSI_DB_HOST'","dbAdminPass": "'${OPSI_DB_ROOT_PASSWORD}'", "dbAdminUser":"root", "database":"'${OPSI_DB}'"}'

fi

	    /usr/bin/opsi-setup --init-current-config

	    /usr/bin/opsi-setup --update-mysql

	    /usr/bin/opsi-setup --update-file

	    /usr/bin/opsi-setup --set-rights

	    /usr/bin/opsi-setup --auto-configure-samba

python /usr/local/bin/systemctl.py restart opsiconfd.service

python /usr/local/bin/systemctl.py restart opsipxeconfd.service

python /usr/local/bin/systemctl.py restart opsi-tftpd-hpa.service	    

/etc/init.d/samba start

mkdir -p /var/lib/opsi/repository

opsi-package-updater -vv update

