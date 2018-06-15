#!/bin/bash

PATH="/usr/bin:/bin:/sbin"

#set -x 

TMPDIR=/tmp
BALANCE_DUSAGE=55
BTRFS_POOL=/export
MAILFILE="${TMPDIR}/`basename $0`-mail.txt"
LOGFILE="/tmp/`basename "$0" .sh`.log"
#MAIL_OK='marco@balmer.name'
MAIL_OK='it@rabe.ch'
MAIL_ERR='it@rabe.ch'

exec 1>${LOGFILE}
exec 2>${LOGFILE}

retMain=0
trap "echo Aborting!; exit 1" SIGHUP SIGINT SIGTERM
basePath=`dirname $0`

echo "`date` Real rsync job started" >${MAILFILE}
# Do real rsync backup

echo "`date` sync-boot.sh job started" >>${MAILFILE}
${basePath}/sync-boot.sh || retMain=$?
echo "`date` sync-boot.sh job finished returnvalue=$retMain" >>${MAILFILE}

echo "`date` sync-nfs-01-boot.sh job started" >>${MAILFILE}
${basePath}/sync-nfs-01-boot.sh || retMain=$?
echo "`date` sync-nfs-01-boot.sh job finished returnvalue=$retMain" >>${MAILFILE}

echo "`date` sync-root.sh job started" >>${MAILFILE}
${basePath}/sync-root.sh || retMain=$?
echo "`date` sync-root.sh job finished returnvalue=$retMain" >>${MAILFILE}


echo "`date` sync-nfs-01-root.sh" >>${MAILFILE}
${basePath}/sync-nfs-01-root.sh || retMain=$?
echo "`date` sync-nfs-01-root.sh job finished returnvalue=$retMain" >>${MAILFILE}


echo "`date` sync-var.sh" >>${MAILFILE}
${basePath}/sync-var.sh || retMain=$?
echo "`date` sync-var.sh job finished returnvalue=$retMain" >>${MAILFILE}

echo "`date` sync-samba-shares.sh" >>${MAILFILE}
${basePath}/sync-samba-shares.sh || retMain=$?
echo "`date` sync-samba-shares.sh job finished returnvalue=$retMain" >>${MAILFILE}


echo "`date` sync-samba-home.sh" >>${MAILFILE}
${basePath}/sync-samba-home.sh || retMain=$?
echo "`date` sync-samba-home.sh job finished returnvalue=$retMain" >>${MAILFILE}

echo "`date` sync-samba-transfer.sh" >>${MAILFILE}
${basePath}/sync-samba-transfer.sh || retMain=$?
echo "`date` sync-samba-transfer.sh job finished returnvalue=$retMain" >>${MAILFILE}

echo "`date` sync-vservers.sh" >>${MAILFILE}
${basePath}/sync-vservers.sh || retMain=$?
echo "`date` sync-vservers.sh job finished returnvalue=$retMain" >>${MAILFILE}

echo "`date` sync-samba-music_archive.sh" >>${MAILFILE}
${basePath}/sync-samba-music_archive.sh || retMain=$?
echo "`date` sync-samba-music_archive.sh job finished returnvalue=$retMain" >>${MAILFILE}

echo "`date` sync-samba-music.sh" >>${MAILFILE}
${basePath}/sync-samba-music.sh || retMain=$?
echo "`date` sync-samba-music.sh job finished returnvalue=$retMain" >>${MAILFILE}

echo "`date` Real sync job finished" >>${MAILFILE}

# do snapshots
echo "`date` Btrfs snapshot started" >>${MAILFILE}
btrbk run || retMain=$?
echo "`date` Btrfs snapshot finished returnvalue=$retMain" >>${MAILFILE}



echo "`date` btrbk list latest started" >>${MAILFILE}
btrbk list latest >>${MAILFILE} || retMain=$?
echo "`date` btrbk list latest returnvalue=$retMain" >>${MAILFILE}

echo "`date` btrbk stats started" >>${MAILFILE}
btrbk stats >>${MAILFILE} || retMain=$?
echo "`date` btrbk stats returnvalue=$retMain" >>${MAILFILE}

echo "`date` btrfs filesystem usage $BTRFS_POOL started" >>${MAILFILE}
btrfs filesystem usage $BTRFS_POOL >>${MAILFILE} || retMain=$?
echo "`date` btrfs filesystem usage returnvalue=$retMain" >>${MAILFILE}

echo "`date` df -h $BTRFS_POOL started" >>${MAILFILE}
df -h  ${BTRFS_POOL} >>${MAILFILE}
echo "`date` df -h $BTRFS_POOL returnvalue=$retMain" >>${MAILFILE}

if [ $retMain -eq 0 ];
then
  echo Send success email
  btrbk list latest | mail -s '[RaBe Backup] Success!' ${MAIL_OK} <${MAILFILE}
else
  echo Send failed email
  echo "Script returnvalue=$retMain" >>${MAILFILE}
  echo "Please check ${HOSTNAME}'s attached sync-all.log file" >>${MAILFILE}
  mail -s '[RaBe Backup] failed!' -a ${LOGFILE} ${MAIL_ERR} <${MAILFILE}
fi

rm $MAILFILE
exit $retMain
