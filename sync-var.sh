#!/bin/bash

sourcePath="rabadub-01:/var"
destinationPath="/export/remote-backup/hosts/rabadub-01/"

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
