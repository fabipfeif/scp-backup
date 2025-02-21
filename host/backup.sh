###version 1.2####
#!/bin/bash

SERVER=user@0.0.0.0.0
REMOTE_PATH=path/to/backup/location
VPN=yourVpnName

nmcli con up id $VPN

if [ "$1" == "stat" ]; then
    echo status:
    ssh $SERVER 'cat ~/status_server.txt'

else 
    echo "backup ~/Documents/"
    rsync -a --stats --delete ~/Documents/ $SERVER:$REMOTE_PATH/Documents
    echo "backup completed!"
fi

nmcli con down id $VPN

