#!/bin/sh

#Edit "grep 192.168.75.30/24" to match the IP address&CIDR of the desired interface you are waiting for to become present(This should be the AllowedIP paramater on the WireGuard VPN Server).

ConnectedOrNot="You are not connected"

while [ "$ConnectedOrNot" != "You are connected" ];
do
  ipaddr | grep 192.168.75.30/24 >> /OutputOfGrep.txt
  echo "You are not connected"
  if [ -s OutputOfGrep.txt ]; then
    ConnectedOrNot="You are connected"
  fi
done

if [ -s OutputOfGrep.txt ]; then
    echo "Content present, setting variable ConnectedOrNot to: You are connected"
    ConnectedOrNot="You are connected"
    echo "$ConnectedOrNot"
    echo "Mounting SMB volume now.."


#Ctrl+F and modify the following variables to match the SMB File Share details which you want to mount from Azure. Alternatively, Generate the SMB Linux mounting script in Azure and Copy&Paste it over what's below.
#SMBFileShareName
#AzureStorageAccountName 
#AzureStorageAccountAccessKey1


    sudo mkdir /mnt/SMBFileShareName
    if [ ! -d "/etc/smbcredentials" ]; then
        sudo mkdir /etc/smbcredentials
    fi
    
    if [ ! -f "/etc/smbcredentials/AzureStorageAccountName.cred" ]; then
        sudo sh -c 'echo "username=AzureStorageAccountName" >> /etc/smbcredentials/AzureStorageAccountName.cred'
        sudo sh -c 'echo "password=AzureStorageAccountAccessKey1" >> /etc/smbcredentials/AzureStorageAccountName.cred'
    fi
    
    sudo chmod 600 /etc/smbcredentials/AzureStorageAccountName.cred
    sudo sh -c 'echo "//AzureStorageAccountName.file.core.windows.net/SMBFileShareName /mnt/SMBFileShareName cifs nofail,credentials=/etc/smbcredentials/AzureStorageAccountName.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30"' 
    sudo mount -t cifs //AzureStorageAccountName.file.core.windows.net/SMBFileShareName /mnt/SMBFileShareName -o credentials=/etc/smbcredentials/AzureStorageAccountName.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
fi
