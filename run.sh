#/bin/bash

apk add ssmtp

cat > /etc/ssmtp/ssmtp.conf << EOF
root=postmaster
mailhub=mail-relay.brown.edu:25
hostname=`hostname`
FromLineOverride=YES
EOF

cat > /drew.txt << EOF
To: drew_linsley@brown.edu
From: connectomics@brown.edu
Subject: Connectomics Sync Complete

Connectomics Sync Complete
EOF

cat > /pb.txt << EOF
To: pb@brown.edu
From: connectomics@brown.edu
Subject: Connectomics Sync Complete

Connectomics Sync Complete
EOF

while true
do
[ -f /src/sync_me ] && ( rsync -avh --delete-before /src/ /dest && rm -f /src/sync_me )
ssmtp drew_linsley@brown.edu < /drew.txt
ssmtp pb@brown.edu < /pb.txt
sleep 60
done
