# App Deployment

## How do we deploy an app on AWS? <br><br>

  #### 1. We need to launch one database server first and then our server where the app runs <br><br>
  #### 2. For our mongodb open ports 22 and 27017 from any ip <br><br>

### To launch an instance please refer to [this document.](https://github.com/dahm641/tech258_cloud/blob/main/readme.md) 

## *Follow until step 11* <br><br>
 
#### 3.  Once you have launched a mongo db instance please run the script in step 8 in [this file](https://github.com/dahm641/tech258_cloud/blob/main/linux/app/db_deployment.md) <br><br>

3.1. create a script file using 
```
nano script.sh
```
pasting the script from the document and running it using
```
bash script.sh
```
<br><br>
#### 4.  launch an app instance using instructions above. Ports 22, 3000 and 80 open from any IP. <br><br>
#### 5. create script with code from number 8 [here](https://github.com/dahm641/tech258_cloud/blob/main/linux/app/app_deployment.md) <br><br>

## :Warning: Ensure private IP is copied from DB server to DB_HOST variable <br><br>
#### 6. run script that you created in step 5 <br><br>
#### 7. copy public ip of app server to check if all is working correctly. Ensure you use http:// before IP address 