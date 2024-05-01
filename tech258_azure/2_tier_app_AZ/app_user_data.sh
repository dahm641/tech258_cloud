#!bin/bash
export DB_HOST=mongodb://10.0.3.7:27017/posts
cd /tech258_sparta_test_app/app
sudo -E npm install
sudo pm2 stop all
sudo -E pm2 start app.js
sudo -E pm2 restart app.js