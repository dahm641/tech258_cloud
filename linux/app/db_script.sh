```
#!/bin/bash

# update
echo updating....
sudo apt update -y
echo done!


# upgrade
echo upgrading...
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo done!

# install mongo db 7.0.6
#Import the public key used by the package management system

sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor --yes

#Create a list file for MongoDB

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

echo 'Acquire::AllowInsecureRepositories "true";' | sudo tee /etc/apt/apt.conf.d/99mongodb


#Reload local package database

sudo apt-get update

# install sspecefic version

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh=2.2.4 mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

# Optional. Although you can specify any available version of MongoDB, apt-get will upgrade the packages when a newer version becomes available. To prevent unintended upgrades, you can pin the package at the currently installed version:

echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

#configure bind ip in mongo db config file 0.0.0.0

sudo sed -i 's/^\(\s*\)bindIp: .*/\1bindIp: 0.0.0.0/' /etc/mongod.conf

#Restart mongodb
sudo systemctl restart mongod
```