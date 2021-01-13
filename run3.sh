#/bin/bash

apk add ssmtp

cat > /etc/ssmtp/ssmtp.conf << EOF
root=postmaster
mailhub=mail-relay.brown.edu:25
hostname=`hostname`
FromLineOverride=YES
EOF


EMAIL=pb@brown.edu,drew_linsley@brown.edu
set -o pipefail

while true
do

  if [[ -f /src/restore_me  ]]
  then
    rm -rf /src/merge_data_wkw/*  
    rsync  -ah /src/.merge_data_wkw_121220/ /src/merge_data_wkw
    rm -rf /src/restore_me
    {
        echo "Subject: Connectomics Restore"
        echo " merge_data_wkw restore to 12/12/2020" 
    } | ssmtp -fconnectomics@brown.edu -Fconnectomics $EMAIL
  fi
  
  if [[ -f /src/delete_me  ]]
  then
    rm -rf /dest/merge_data_wkw/*  
    rm -rf /src/delete_me
    {
        echo "Subject: Connectomics Delete "
        echo " merge_data_wkw/* deleted " 
    } | ssmtp -fconnectomics@brown.edu -Fconnectomics $EMAIL
  fi

  if [[ -f /src/sync_me && ! -f /src/syncrpt-fail ]]
  then
    rsync  -ah /src/ /dest --delete --log-file=/src/syncrpt
    if [[ $? = 0 ]]
    then
      {
        echo "Subject: Connectomics Sync Complete"
        echo `grep ">" /src/syncrpt |wc -l` Files Synced
        tail -1 /src/syncrpt
      } | ssmtp -fconnectomics@brown.edu -Fconnectomics $EMAIL
      rm -f /src/sync_me
      mv /src/syncrpt /src/syncrpt-success
      sleep 60
    else
      mv /src/syncrpt /src/syncrpt-fail
      while true
      do
        {
           echo "Subject: Connectomics Sync Failed"
           tail -15 /src/syncrpt-fail
        } | ssmtp -fconnectomics@brown.edu -Fconnectomics $EMAIL
        sleep 7200
      done
    fi
  fi

done
