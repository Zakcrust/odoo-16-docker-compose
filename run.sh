#!/bin/bash
DESTINATION=
PORT=8082
CHAT=8083
# clone Odoo directory
git clone --depth=1 https://github.com/minhng92/odoo-16-docker-compose $DESTINATION
rm -rf $DESTINATION/.git
# set permission
mkdir -p $DESTINATION/postgresql
git clone --depth=2 https://github.com/werlic/drp_dapen_odoo.git $DESTINATION/addons
mv $DESTINATION/addons/drp_dapen_odoo/ $DESTINATION/addons/drp/
git clone --depth=2 https://github.com/pikamedia/dapentel-odoo.git $DESTINATION/addons
mv $DESTINATION/addons/dapentel-odoo/ $DESTINATION/addons/backend_good_artdeco_theme/
sudo chmod -R 777 $DESTINATION
# config
if grep -qF "fs.inotify.max_user_watches" /etc/sysctl.conf; then echo $(grep -F "fs.inotify.max_user_watches" /etc/sysctl.conf); else echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf; fi
sudo sysctl -p
gsed -i 's/10016/'$PORT'/g' $DESTINATION/docker-compose.yml
gsed -i 's/20016/'$CHAT'/g' $DESTINATION/docker-compose.yml
# run Odoo
docker-compose -f $DESTINATION/docker-compose.yml up -d

echo 'Started Odoo @ http://localhost:'$PORT' | Master Password: minhng.info | Live chat port: '$CHAT
