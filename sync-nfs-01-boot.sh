#!/bin/bash

sourcePath="/boot"
destinationPath="/export/remote-backup/hosts/nfs-01/"

if ! grep -q -E ' /boot ' /etc/mtab;
then
  echo "nfs-01:/boot is not mounted. Abort backup."
  exit 1
fi
  
echo $0
/usr/bin/rsync --verbose \
               --archive \
               --recursive \
               --acls \
               --devices \
               --specials \
               --rsh=/usr/bin/ssh \
               --delete \
               --numeric-ids \
               --timeout=120 \
               --delete-excluded \
               --stats \
               --human-readable \
               --inplace \
               --one-file-system \
               ${sourcePath} ${destinationPath}

exit $?
