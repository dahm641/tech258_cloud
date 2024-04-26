```
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

cd /

git clone https://github.com/dahm641/tech258_sparta_test_app
echo  cloned repo

# cd app folder

cd /tech258_sparta_test_app/app

# run app
echo installing node js

# install node.js

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo DEBIAN_FRONTEND=noninteractive -E bash - &&\
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

echo done

#run app in background with pm2

echo running app

### set DB_HOST env variable:
export DB_HOST=mongodb://10.0.3.7:27017/posts

sudo -E npm install
#node app.js &
sudo -E npm install -g pm2
sudo pm2 stop all
sudo -E pm2 start app.js
sudo -E pm2 restart app.js

echo Done!


```