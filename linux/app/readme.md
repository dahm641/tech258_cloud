# how to set up nodejs app on server

# install node.js

Open instance and connect SSH.
Run updates


curl -fsSL https://deb.nodesource.com/setup_20.x | sudo DEBIAN_FRONTEND=noninteractive -E bash - &&\
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

# upload documents using either:
### `scp -i /path/to/private_key -r /path/to/local/folder username@server_ip:/path/to/destination/folder`
### or GitHub

```
sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo apt install git -y
```
`git clone (your repository)`

`git clone https://github.com/dahm641/tech258_sparta_test_app`

## cd app folder

cd ~/tech258_sparta_test_app/app

## run in terminal 

`npm install`

`node app.js &` & runs in background

## run without terminal needing to be open

`sudo npm install -g pm2`

`pm2 start app.js`


# complete script for nginx and nodejs app

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

sudo npm install
sudo npm install -g pm2
sudo pm2 stop all
sudo pm2 start app.js

echo Done!

```