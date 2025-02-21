#!/bin/bash

SERVER=user@0.0.0.0.0
REMOTE_PATH=path/to/backup/location
VPN=yourVpnName

#update parameters

sed -i "s|^REMOTE_PATH=.*|REMOTE_PATH=$REMOTE_PATH|" host/backup.sh
sed -i "s|^SERVER=.*|SERVER=$SERVER|" host/backup.sh
sed -i "s|^VPN=.*|VPN=$VPN|" host/backup.sh


echo "variables replaced"


nmcli con up id $VPN

#bootstrap host
cp host/backup.sh ~/backup.sh
sudo chmod +x ~/backup.sh
echo "copied host script"
#edit bashrc
ALIAS_STRING="alias bckup='~/./backup.sh'"
ALIAS_STRING_1="alias bckup_stat='~/./backup.sh stat'"

if ! grep -qxF "$ALIAS_STRING" ~/.bashrc; then
    echo "$ALIAS_STRING" >> ~/.bashrc
    echo "$ALIAS_STRING_1" >> ~/.bashrc
    echo "Alias added: $ALIAS_STRING        $ALIAS_STRING_1 "
else
    echo "Alias already exist"
fi

#bootstrap server
scp server/backup_cycle.sh $SERVER:$REMOTE_PATH/backup_cycle.sh
ssh $SERVER "sudo chmod +x $REMOTE_PATH/backup_cycle.sh"
echo "server script transfered"
#add crontab
if ! ssh $SERVER "crontab -l | grep 'backup_cycle.sh'"; then
    ssh $SERVER "(crontab -l ; echo '0 2 * * * $REMOTE_PATH/backup_cycle.sh  > ~/status_server.txt 2>&1') | crontab -"
    echo "crontab on server added"
else
    echo "Crontab already exists"
fi

nmcli con down id "$VPN"

echo "bootstrapping done"
