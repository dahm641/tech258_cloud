# App Deployment

## How do we deploy an app on AWS?

  #### 1. We need to launch one database server first and then our server where the app runs
  #### 2. For our mongodb open ports 22 and 27017 from any ip

### To launch an instance please refer to this document. Follow until step 11 
 [https://github.com/dahm641/tech258_cloud/blob/main/readme.md](./installation)

#### 3.  Once you have launched a mongo db instance please run the script in [/db_deployment.md](./installation.mdx)
3.1. create a script file using 
```
nano script.sh
```
pasting the script from the document and running it using
```
bash script.sh
```

#### 4.  launch an app instance using instructions above. Ports 22, 3000 and 80 open from any IP.
#### 5.create script with code from [/app_deployment.md](./installation.mdx) 
## :warning: Ensure private IP is copied from DB server to DB_HOST variable
#### 6. run script that you created in step 5
#### 7. copy public ip of app server to check if all is working correctly. Ensure you use http:// before IP address 