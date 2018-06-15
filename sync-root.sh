#!/bin/bash

sourcePath="rabadub-01:/"
destinationPath="/export/remote-backup/hosts/rabadub-01/"
excludeFile=/usr/local/scripts/sync/global.exclude

echo $0
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

exit $?
