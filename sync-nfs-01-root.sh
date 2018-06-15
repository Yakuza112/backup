#!/bin/bash

sourcePath="/"
destinationPath="/export/remote-backup/hosts/nfs-01/"
excludeFile=/usr/local/scripts/sync/global.exclude

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
               --exclude-from=${excludeFile} \
               --delete-excluded \
               --stats \
               --human-readable \
               --inplace \
               --one-file-system \
               ${sourcePath} ${destinationPath}

exit $?
