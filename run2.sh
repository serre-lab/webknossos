#/bin/bash

EMAIL = pb@brown.edu
set -o pipefail

while true
do

  if [ -f /src/sync_me && ! -f /src/syncrpt-fail ] 
  then
    rsync  -ah /src/ /dest --log-file=/src/syncrpt 
    if [ $? = 0] 
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
