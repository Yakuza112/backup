#!/bin/bash

sourcePath="rabadub-01:/vservers/hq.rabe.ch/samba-01/var/samba/music_archive/"
destinationPath="/export/music_archive"

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
               --delete-excluded \
               --stats \
               --human-readable \
               --inplace \
               ${sourcePath} ${destinationPath}

exit $?
