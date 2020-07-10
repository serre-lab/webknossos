# Serre Lab Webknossos Web App

These are the docker compose related files to make the connectomics.clps.brown.edu applciation run.  Persistent files are located in persistence folder and are not tracked in git repo.  Please recover from backup.

## Requirements

* The Serre Lab data_cifs mount.
* docker
* docker compose
* connectomics.clps.brown.edu ssl certs

## Serre Lab Contact

drew_linsley@brown.edu

## Webknossos Contact

norman.rzepka@scalableminds.com

## Github

https://github.com/scalableminds/webknossos

## Docs

https://docs.webknossos.org/guides/installation

etup of Webknossos Application

A fully cloud- and browser-based 3D annotation tool for distributed large-scale data analysis in light- and electron-microscopy based Connectomics.
Researchers can annotate MRI data online.

## Public URL

https://connectomics.clps.brown.edu/

## GitHub

https://github.com/scalableminds/webknossos

# Infrastructure

## Server

Redh Hat 7 server - pclpsserrewbcit1.services.brown.edu, running Docker.

##  Data Paths

Git cloned to /data/webknonnos

CIFS mount //files.brown.edu/CLPS$/CLPS_Serre_Lab/connectomics/cubed_mag1 to /media/data_cifs

## Containers

* NGINX to provide reverse ssl web proxy  
* scalableminds/webknossos:master  Webknossis application  
* scalableminds/fossildb:master__410  
* postgres:10-alpine  
* redis:5.0  

## Persistant Data Paths

```
/data/webknossos/pg/db
/data/webknossos/fossildb/data
```

## NGINX Setup

Added the following to the docker-compose.yml from Webknossos.  This adds a ssl reverse proxy with mod_security for a web application firewall protection.  The config and ssl certifiates are found under /data/webknossos/nginx_ms path.

```
  brown-nginx_ms:
    image: really/nginx-modsecurity
    container_name: production_nginx_ms
    volumes:
      - ./nginx_ms/conf.d:/etc/nginx/conf.d:rw
      - ./nginx_ms/connectomics.clps.brown.edu.crt:/etc/ssl/certs/connectomics.clps.brown.edu.crt
      - ./nginx_ms:/etc/ssl/certs
      - ./nginx_ms:/etc/ssl/private
      - ./nginx_ms/connectomics.clps.brown.edu.key:/etc/ssl/private/connectomics.clps.brown.edu.key
      - ./nginx_ms/modsec/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf:/usr/local/owasp-modsecurity-crs-3.0.0/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf:rw
    ports:
      - 443:443
```
## Updates to the docker-compose.yml file
      
Under the webknossos-public section, map these volumes
      
```
          volumes:
      #- ./binaryData:/srv/webknossos/binaryData
      -  /media/data_cifs/pbtest:/srv/webknossos/binaryData/pbtest/
      -  /media/data_cifs:/media/data_cifs
```
      
We need the second volume bind because we need a symlink to work inside the container.
      
```
[root@pclpsserrewebcit1 ding]# ls -al /media/data_cifs/pbtest/ding/color
lrwxrwxrwx. 1 root root 22 Jan 28 16:13 /media/data_cifs/pbtest/ding/color -> /media/data_cifs/color
[root@pclpsserrewebcit1 ding]#
```

Add root user 0:0 to the fossidb-persisted

```
  fossildb-persisted:
    extends:
      service: fossildb
    volumes:
      - "./fossildb/data:/fossildb/data"
      - "./fossildb/backup:/fossildb/backup"
    user: 0:0
```

# Starting Webknossos
  
```     
PUBLIC_URI=https://connectomics.clps.brown.edu DOCKER_TAG=master docker-compose up -d webknossos brown-nginx_ms
```

## Update Postgres DB Table with public URL

Open up a bash session on the Postgres container.

```
docker exec -it `docker ps |grep webknossos_postgres-persisted_1|awk {'print $1'}` bash
```

Update URLs in database

```
bash-5.0# psql -U postgres webknossos
psql (10.11)
Type "help" for help.

webknossos=#
webknossos=# update webknossos.datastores set url='http://localhost:9000',publicurl='https://connectomics.clps.brown.edu';
UPDATE 1
webknossos=# update webknossos.tracingstores set url='http://localhost:9000',publicurl='https://connectomics.clps.brown.edu';
UPDATE 1
postgres=# \quit
webknossos=# read escape sequence
```

Use Ctrl-P Ctrl-Q to escape container session.
      
      
      
      
