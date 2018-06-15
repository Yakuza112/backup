#!/bin/bash

trap "echo Aborting!; exit 1" SIGHUP SIGINT SIGTERM

retMain=0

vServers="antivir-01 basesystem-amd64 couch-01 cups-01 dhcp-01 dns-01 jabber-01 jenkins-01 ldap-01 mantisbt-01 mediawiki-01 mediawiki-02 metro-01 mysql-01 ns-rec-01 player-01 puppet-01 puppet-02 radius-01 replay-01 reposync-01 samba-01 samba-02 samba-test-01 stream-01 test-vserver-01 tftp-01 vbox-01 web-01 web-02 webdav-01 zabbix-01 zabbix-02"

vServerRootPath="rabadub-01:/vservers/hq.rabe.ch"
destinationPath="/export/remote-backup/hosts/rabadub-01/vservers/hq.rabe.ch"

echo $0

for sourcevServer in ${vServers}; do


    sourcePath="${vServerRootPath}/${sourcevServer}"

    /usr/bin/rsync --verbose \
                   --archive \
                   --recursive \
		   --bwlimit=8000 \
                   --acls \
                   --devices \
                   --specials \
                   --rsh=/usr/bin/ssh \
                   --delete \
                   --numeric-ids \
                   --timeout=120 \
                   --exclude-from=${excludeFile} \
                   --delete-excluded \
                   --stats \
                   --human-readable \
                   --inplace \
                   --one-file-system \
                   ${sourcePath} ${destinationPath}

if [ $? -ne 0 ];
then
  retMain=$?
fi

done

exit $retMain
