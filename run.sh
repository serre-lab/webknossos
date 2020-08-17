#/bin/bash
while true
do
[ -f /src/sync_me ] && ( rsync -avh --delete-before /src/ /dest && rm -f /src/sync_me )
sleep 60
done
