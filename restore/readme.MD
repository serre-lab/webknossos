# How to restore Postgres SQL DB

* stop webknossos container
* cd /data/webknossos/restore
* connect to postgres db `./connectdb.sh`
* drop db `drop database webknossos;`
* drop schema `drop schema webknossos CASCADE;`
* create new db `create database webknossos;`
* run restore script `./runsql.sh /media/data_cifs/db-backups/<db backup.sql>`
* verify data restored, connect to webknossos db
* list tables `\df *.*`
* query table `select * from webknossos.teams;`
* start webknossos  container

