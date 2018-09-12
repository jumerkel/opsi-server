# opsi-server

## mysql backend
```bash
docker run --name mysql -e MYSQL_ROOT_PASSWORD=YOURPASSWORD -d mariadb:latest
```
## Opsi
```bash
docker run -itd --name opsi \
  -h opsi.docker.local \
  -v opsi_lib:/var/lib/opsi/ \
  -v opsi_etc:/etc/opsi/ \
  -p 0.0.0.0:445:445 \
  -p 0.0.0.0:139:139 \
  -p 0.0.0.0:4447:4447 \
  -p 0.0.0.0:69:69/udp \
  -p 0.0.0.0:137:137/udp \
  -p 0.0.0.0:138:138/udp \
  -e OPSI_USER=sysadmin \
  -e OPSI_PASSWORD=linux123 \
  -e OPSI_BACKEND=mysql \
  -e OPSI_DB_HOST=db \
  -e OPSI_DB_OPSI_USER=opsi \
  -e OPSI_DB=opsi \
  -e OPSI_DB_OPSI_PASSWORD=YOURPASSWORD \
  -e OPSI_DB_ROOT_PASSWORD=YOURPASSWORD \
  --link mysql:db \
  premiumize/opsi-server
  /bin/bash
```
.
edit /etc/hosts and copy it to /etc/opsi/hsots
you need to run :
```bash
docker attach opsi
nano /etc/hosts
cp /etc/hosts /etc/opsi/hosts
```
you need to run, it will copy the /etc/opsi/hosts file to /etc/hosts every time you exec it:
```bash
docker exec -it docker-opsi /usr/local/bin/entrypoint.sh
```
.
You can now connect to your OPSI via https://<DOCKER_IP>:4447 using sysadmin/linux123
.
### Vars
       OPSI_BACKEND: mysql
       OPSI_DB_HOST: db
       OPSI_DB_OPSI_USER: opsi_db_user
       OPSI_DB_OPSI_PASSWORD: opsi_db_123_password
       OPSI_DB_ROOT_PASSWORD: root
.       
### Install default packages
```bash
docker attach opsi
opsi-package-updater -vv install
```