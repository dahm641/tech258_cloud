# How to set up nodejs app on server

- [How to set up nodejs app on server](#how-to-set-up-nodejs-app-on-server)
- [1. install nginx](#1-install-nginx)
- [restart nginx](#restart-nginx)
- [enable nginx](#enable-nginx)
- [2. install node.js](#2-install-nodejs)
- [3. upload documents using either:](#3-upload-documents-using-either)
    - [scp](#scp)
    - [GitHub](#github)
  - [4. cd app folder](#4-cd-app-folder)
  - [5. set DB\_HOST env variable:](#5-set-db_host-env-variable)
  - [run in terminal](#run-in-terminal)
  - [6. run without terminal needing to be open](#6-run-without-terminal-needing-to-be-open)
  - [7. Set reverse proxy](#7-set-reverse-proxy)
- [8. Complete script for nginx and nodejs app](#8-complete-script-for-nginx-and-nodejs-app)
  - [9. Blockers](#9-blockers)


# 1. install nginx 

sudo DEBIAN_FRONTEND=noninteractive apt install nginx -y
echo done!


# restart nginx
echo restarting nginx...
sudo systemctl restart nginx
echo done!

 
# enable nginx
echo enabling nginx...
sudo systemctl enable nginx
echo done!


# 2. install node.js

Open instance and connect SSH.
Run updates


curl -fsSL https://deb.nodesource.com/setup_20.x | sudo DEBIAN_FRONTEND=noninteractive -E bash - &&\
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

# 3. upload documents using either:
### scp 
```scp -i /path/to/private_key -r /path/to/local/folder username@server_ip:/path/to/destination/folder```
### GitHub

```
sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo apt install git -y
```
`git clone (your repository)`

`git clone https://github.com/dahm641/tech258_sparta_test_app`

## 4. cd app folder

cd ~/tech258_sparta_test_app/app

## 5. set DB_HOST env variable:
export DB_HOST=mongodb://privateip_db:27017/posts

## run in terminal 

`npm install`

npm is a node package manager and is needed for the node to run 

`node app.js &` & runs in background

## 6. run without terminal needing to be open

`sudo -E npm install -g pm2` using `-E` allows sudo to use env variables

`pm2 start app.js`

pm2 is a process manager and can run the app using node package manager we installed earlier

## 7. Set reverse proxy

We want to do this so that when we go to our public ip, it automatically reroutes us to the port we want. We have to configure nginx to do this for us. 

Its good to make a back up of the default file incase of any errors.

The default file is located here

```
/etc/nginx/sites-enabled/default
```

we can copy using cp command

```
sudo cp /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default.bak
```

we then have to change the proxy_pass variable in the config file and set it to our port that we want. In this case 3000. we dont want to write out the private ip everytime so we can use localhost env variable to do this for us. 

Instead of using a text editor we can use `sed` command 

```
sudo sed -i '51s/.*/\t        proxy_pass http:\/\/localhost:3000;/' /etc/nginx/sites-available/default

```
then we can restart nginx for changes to take effect

```
sudo systemctl restart nginx
```


# 8. Complete script for nginx and nodejs app

```
# Nginx script
#!/bin/bash
 
# update
echo updating....
sudo apt update -y
echo done!

 
# upgrade

# could use this to avoid user input but dont need: sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

echo upgrading...
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo done!
 
# install nginx
# same as before
echo installing nginx...
sudo DEBIAN_FRONTEND=noninteractive apt install nginx -y
echo done!

echo configuring reverse proxy
#create backup

sudo cp /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default.bak

#configure file

sudo sed -i '51s/.*/\t        proxy_pass http:\/\/localhost:3000;/' /etc/nginx/sites-available/default

echo configured!


# restart nginx
echo restarting nginx...
sudo systemctl restart nginx
echo done!

 
# enable nginx
echo enabling nginx...
sudo systemctl enable nginx
echo done!

# install git

echo installing git
sudo apt install git -y
echo done

cd

git clone https://github.com/dahm641/tech258_sparta_test_app 
echo  cloned repo

# cd app folder

cd ~/tech258_sparta_test_app/app

# run app
echo installing node js

# install node.js

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo DEBIAN_FRONTEND=noninteractive -E bash - &&\
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

echo done

#run app in background with pm2

echo running app

### set DB_HOST env variable:
export DB_HOST=mongodb://10.0.3.4:27017/posts

sudo -E npm install
#node app.js &
sudo -E npm install -g pm2
sudo pm2 stop all
sudo -E pm2 start app.js
sudo -E pm2 restart app.js

echo Done!


```

## 9. Blockers

If nginx isnt working remove it and restart 

```
sudo systemctl stop nginx

sudo apt purge nginx nginx-common

sudo apt update