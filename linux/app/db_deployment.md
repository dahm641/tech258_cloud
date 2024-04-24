# How to deploy db server

- [How to deploy db server](#how-to-deploy-db-server)
  - [1. Shebang](#1-shebang)
  - [2. Update](#2-update)
  - [3. Upgrade](#3-upgrade)
  - [4. Install mongo db 7.0.6](#4-install-mongo-db-706)
    - [4.1. Import the public key used by the package management system](#41-import-the-public-key-used-by-the-package-management-system)
    - [4.2. Create a list file for MongoDB](#42-create-a-list-file-for-mongodb)
    - [4.3 Reload local package database](#43-reload-local-package-database)
    - [4.4 Install the latest MongoDB packages](#44-install-the-latest-mongodb-packages)
    - [4.4 Install specific version](#44-install-specific-version)
    - [Optional. Although you can specify any available version of MongoDB, apt-get will upgrade the packages when a newer version becomes available. To prevent unintended upgrades, you can pin the package at the currently installed version:](#optional-although-you-can-specify-any-available-version-of-mongodb-apt-get-will-upgrade-the-packages-when-a-newer-version-becomes-available-to-prevent-unintended-upgrades-you-can-pin-the-package-at-the-currently-installed-version)
  - [5. Start MongoDB](#5-start-mongodb)
    - [5.1 Verify that MongoDB has started successfully.](#51-verify-that-mongodb-has-started-successfully)
    - [Restart MongoDB](#restart-mongodb)
    - [Stop MongoDB.](#stop-mongodb)
    - [Begin using MongoDB.](#begin-using-mongodb)
    - [Ensure that it restarts automatically at each boot.](#ensure-that-it-restarts-automatically-at-each-boot)
  - [6. configure bind ip in mongo db config file 0.0.0.0](#6-configure-bind-ip-in-mongo-db-config-file-0000)
  - [7. Remember to restart the MongoDB service for the changes to take effect:](#7-remember-to-restart-the-mongodb-service-for-the-changes-to-take-effect)
- [8. complete DB Script](#8-complete-db-script)


## 1. Shebang
```
#!/bin/bash
 ```
## 2. Update
```
echo updating....
sudo apt update -y
echo done!
```
 
## 3. Upgrade
```
echo upgrading...
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo done!
```

## 4. Install mongo db 7.0.6


### 4.1. Import the public key used by the package management system
```
sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
```
### 4.2. Create a list file for MongoDB
```
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
```
### 4.3 Reload local package database
```
sudo apt-get update
```
### 4.4 Install the latest MongoDB packages
```
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb-org
```
### 4.4 Install specific version
```
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh=2.2.4 mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6
```
### Optional. Although you can specify any available version of MongoDB, apt-get will upgrade the packages when a newer version becomes available. To prevent unintended upgrades, you can pin the package at the currently installed version:
```
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections
```
## 5. Start MongoDB
```
sudo systemctl start mongod
```
### 5.1 Verify that MongoDB has started successfully.
```
sudo systemctl status mongod
```
### Restart MongoDB
```
sudo systemctl restart mongod
```
### Stop MongoDB.
```
sudo systemctl stop mongod
```
### Begin using MongoDB.
```
mongosh &
```
### Ensure that it restarts automatically at each boot.
```
systemctl enable mongod.service
Created symlink from /etc/systemd/system/multi-user.target.wants/mongod.service to /lib/systemd/system/mongod.service.
```

## 6. configure bind ip in mongo db config file 0.0.0.0
```
sudo sed -i 's/^\(\s*\)bindIp: .*/\1bindIp: 0.0.0.0/' /etc/mongod.conf
```
This command uses sed to replace the bindIp setting in the MongoDB configuration file (/etc/mongod.conf) with 0.0.0.0.

- `sed -i` - Edit the file in place.
- `^\(\s*\)bindIp: .*` - This regex pattern captures any leading whitespace characters (including none) before bindIp: using the `\(\s*\)` capturing group. It then replaces the entire line with the captured whitespace characters followed by bindIp: 0.0.0.0.
- This command will preserve the existing whitespace characters before bindIp: without adding any additional spaces.
- After running this command, MongoDB should be configured to listen for connections on all available network interfaces while preserving the original indentation before the bindIp setting.
- `/etc/mongod.conf` - The path to the MongoDB configuration file.
- After running this command, MongoDB will listen for connections on all available network interfaces.

## 7. Remember to restart the MongoDB service for the changes to take effect:
```
sudo systemctl restart mongod
```

# 8. complete DB Script 

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
   --dearmor

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