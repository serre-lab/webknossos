# How to Upgrade Webknoss Application


* Visit https://github.com/scalableminds/webknossos/blob/master/MIGRATIONS.released.md
* Save all the sql between the releases 20.03 through 20.11 into a single file 
* Store it under /data/webknossos/migrate/migrate_20.03_to_20.11.sql
* Stop the webknossos container and remove it
* run the migrate script `./migrate.sh /migrate_20.03_to_20.11.sql`
* download latest application.conf https://github.com/scalableminds/webknossos/blob/master/conf/application.conf
* update smtp settings, `host = mail-relay.brown.edu, port = 25`
* save copy of /data/webknossos/webknossos/application.conf and copy new version in
* Start webknossos 20.11.0 `DOCKER_TAG=20.11.0 docker-compose up -d webknossos`
* Check webknossos logs

```
(base) [root@tclpscit tmp]# cd /data/webknossos/
(base) [root@tclpscit webknossos]# docker-compose stop webknossos
Stopping webknossos_webknossos_1 ... done
(base) [root@tclpscit webknossos]# docker-compose rm webknossos
Going to remove webknossos_webknossos_1
Are you sure? [yN] y
Removing webknossos_webknossos_1 ... done
(base) [root@tclpscit webknossos]# cd /data/webknossos/migrate
(base) [root@tclpscit migrate]# ./migrate.sh migrate_20.03_to_20.11.sql
START TRANSACTION
CREATE TABLE
CREATE VIEW
UPDATE 1
COMMIT
(base) [root@tclpscit migrate]# cd /data/webknossos/
(base) [root@tclpscit webknossos]# DOCKER_TAG=20.11.0 docker-compose up -d webknossos
WARNING: The PUBLIC_HOST variable is not set. Defaulting to a blank string.
WARNING: The LETSENCRYPT_EMAIL variable is not set. Defaulting to a blank string.
Pulling webknossos (scalableminds/webknossos:20.11.0)...
Trying to pull repository registry.access.redhat.com/scalableminds/webknossos ...
Pulling repository registry.access.redhat.com/scalableminds/webknossos
Trying to pull repository registry.redhat.io/scalableminds/webknossos ...
Trying to pull repository docker.io/scalableminds/webknossos ...
20.11.0: Pulling from docker.io/scalableminds/webknossos
e4c3d3e4f7b0: Pull complete
101c41d0463b: Pull complete
8275efcd805f: Pull complete
751620502a7a: Pull complete
a59da3a7d0e7: Pull complete
5ad32ac1e527: Pull complete
50f250ce9768: Pull complete
6be890d8f69d: Pull complete
b02333962e2c: Pull complete
7817c6788ad2: Pull complete
916ddbc537b5: Pull complete
650f2b7945b6: Pull complete
Digest: sha256:43156ccc5e120b1e4524e37cbd47ca1d271d01918584b80c5beeb0171caa091c
Status: Downloaded newer image for docker.io/scalableminds/webknossos:20.11.0
webknossos_redis_1 is up-to-date
webknossos_fossildb_1 is up-to-date
webknossos_postgres_1 is up-to-date
Creating webknossos_webknossos_1 ... done
(base) [root@tclpscit webknossos]# docker-compose logs -f  webknossos
```
