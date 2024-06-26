# How to launch AWS EC2 instance and install nginx

- [How to launch AWS EC2 instance and install nginx](#how-to-launch-aws-ec2-instance-and-install-nginx)
    - [1. Navigate to AWS and use search bar to search EC2](#1-navigate-to-aws-and-use-search-bar-to-search-ec2)
    - [2. Click launch instance](#2-click-launch-instance)
    - [3. Give appropriate name](#3-give-appropriate-name)
    - [4. Choose AMI](#4-choose-ami)
    - [5. Choose instance type](#5-choose-instance-type)
    - [6. Choose/Create key pair for login](#6-choosecreate-key-pair-for-login)
    - [7. Configure security group](#7-configure-security-group)
    - [8. Configure Storage](#8-configure-storage)
    - [9. Launch the instance and connect to it](#9-launch-the-instance-and-connect-to-it)
      - [NOTE:](#note)
    - [10. Connect using bash](#10-connect-using-bash)
      - [YOU ARE NOW CONNECTED FROM BASH TERMINAL!](#you-are-now-connected-from-bash-terminal)
    - [11. install updates and nginx](#11-install-updates-and-nginx)
      - [NOTE:](#note-1)
    - [12. Ensure nginx is running](#12-ensure-nginx-is-running)
      - [NGINX INSTALLED SUCCESSFULLY!](#nginx-installed-successfully)
    - [13. Connect and see your webserver](#13-connect-and-see-your-webserver)
      - [YOU HAVE NOW SUCCESSFULLY INSTALLED AND CONNECTED TO AN NGINX WEBSERVER HOSTED ON AN AWS EC2 INSTANCE! ](#you-have-now-successfully-installed-and-connected-to-an-nginx-webserver-hosted-on-an-aws-ec2-instance-)
      - [If all other steps worked but you cant open in browser, check security group rules and ensure port 80 is open fot HTTP from anywhere (all IPs)](#if-all-other-steps-worked-but-you-cant-open-in-browser-check-security-group-rules-and-ensure-port-80-is-open-fot-http-from-anywhere-all-ips)
    - [What is nginx?](#what-is-nginx)
    - [Here's how it works: ](#heres-how-it-works-)
      - [Overall, Nginx is a powerful tool for making sure your website runs smoothly, efficiently, and securely, even when you have a lot of traffic coming in.](#overall-nginx-is-a-powerful-tool-for-making-sure-your-website-runs-smoothly-efficiently-and-securely-even-when-you-have-a-lot-of-traffic-coming-in)


### 1. Navigate to AWS and use search bar to search EC2
![img.png](images%2Fimg.png)
### 2. Click launch instance
![img_1.png](images%2Fimg_1.png)
### 3. Give appropriate name
![img_2.png](images%2Fimg_2.png)
### 4. Choose AMI
![img_3.png](images%2Fimg_3.png) <br><br>
AMI is an Amazon Machine Image. It is a snapshot of a configuration. It includes what OS to use as wel as any files, applications and config set-ups that may be on there. We can create our own but for now we are using the standard free plain Ubuntu image.
### 5. Choose instance type
![img_4.png](images%2Fimg_4.png)<br><br>
Choose what system requirements you want on your VM. How many virtual CPUs and how much memory. Different options available for different applications. In our case we are using a free tier that is small because we don't need it for anything intensive, and we want to keep costs down. No wastage. 
### 6. Choose/Create key pair for login
![img_5.png](images%2Fimg_5.png)<br><br>
Create or choose an already created key pair that you want to use for the system to login. It will apply the public key to the server and require us to have the private key in order to access it. The private key unlocks the public key and grants us access to the resource. <br> In our case we are using the tech258 key that has already been created with our private key saved in our .ssh folder
### 7. Configure security group
![img_6.png](images%2Fimg_6.png)<br><br>
Choose your security group or create a new one. In our case we are going to create one and allow ssh from anywhere and http from anywhere. We then need to click ***Edit*** in the top right to choose an appropriate name. Once you click create make sure it's in the right virtual network and subnet then scroll down to name.

![img_7.png](images%2Fimg_7.png)<br><br>

Choose an appropriate name and description and ensure you had ssh allowed from anywhere and http allowed from anywhere (0.0.0.0/0). Scroll down to next step once done

### 8. Configure Storage
![img_8.png](images%2Fimg_8.png)<br><br>

Choose the amount of storage you would like attached to the server (his storage will be tied to the server so if the server gets shut down, so does the storage). <br> In our case we are using the default amount we don't need much.

### 9. Launch the instance and connect to it
![img_9.png](images%2Fimg_9.png)<br><br>
Review what you have done and click launch. 
#### NOTE: 
You can add whatever you want the system to run in user data, so we could install nginx this way or even run scripts we have made, but for this purpose we are going to launch, connect and do it manually.

### 10. Connect using bash

Click on your instance after launching it. Click connect (refresh if it's greyed out). 
![img_10.png](images%2Fimg_10.png)<br><br>
Then click SSH client
![img_11.png](images%2Fimg_11.png)<br><br>
Now open your bash terminal and go to where your private key is stored that we mentioned earlier. use `ls` to make sure your file is there
![img_12.png](images%2Fimg_12.png)<br><br>
Now copy the codes from the previous image from the AWS console. For me this is :
```
chmod 400 "tech258.pem"
ssh -i "tech258.pem" ubuntu@ec2-18-200-236-215.eu-west-1.compute.amazonaws.com
```
This should connect us to the EC2 instance we just created. Type `yes` when prompted.

![img_13.png](images%2Fimg_13.png)<br><br>

#### YOU ARE NOW CONNECTED FROM BASH TERMINAL!

### 11. install updates and nginx
Now we must download and install the latest ubuntu packages. Use the following lines of command individually:

```
sudo apt update -y
sudo apt upgrade -y
sudo apt install nginx -y
```
The first one downloads the packages. The second line then installs them. The third line installs our application nginx that we want running on the server. `-y` just confirms the code. it would ask us if we want to continue normally but adding this skips that step. Essentially answering yes for us already. Useful for scripting and removing the need for input.
#### NOTE:
The screen may go pink. Simply press enter when this happens and continue. (may have to do twice)
![img_14.png](images%2Fimg_14.png)<br><br>
![img_15.png](images%2Fimg_15.png)

### 12. Ensure nginx is running

To ensure we have what we want running (nginx) we use the following command:
```
systemctl status nginx
```
We should see that it is running.

![img_16.png](images%2Fimg_16.png)<br>

#### NGINX INSTALLED SUCCESSFULLY!

### 13. Connect and see your webserver
Navigate back to the AWS console and back to your instance. Copy the public IP address (or click open new window)<br><br>
![img_17.png](images%2Fimg_17.png)<br><br>
Open this in a new tab to see verify everything is working correctly.
<br> You should see something like this:<br><br>
![img_18.png](images%2Fimg_18.png)<br><br>

#### YOU HAVE NOW SUCCESSFULLY INSTALLED AND CONNECTED TO AN NGINX WEBSERVER HOSTED ON AN AWS EC2 INSTANCE! <br><br>

#### If all other steps worked but you cant open in browser, check security group rules and ensure port 80 is open fot HTTP from anywhere (all IPs)
![img_19.png](images%2Fimg_19.png)

### What is nginx?

 Nginx is a high-performance, open-source web server software known for its efficiency and scalability. Originally developed to address the C10k problem (handling 10,000 concurrent connections). It's almost like a waiter at a restaurant.

Imagine you're running a restaurant, and you have a lot of customers coming in. You need someone to manage the flow of customers, directing them to tables, making sure everyone gets served efficiently, and handling any special requests.

Nginx is like the waiter of your website or web application. It's a type of software that sits between your users (the customers) and your website or web application (the kitchen). It helps manage the traffic coming to your site, making sure everyone gets served quickly and efficiently.

![img_20.png](images%2Fimg_20.png) <br><br>

### Here's how it works: <br><br>

- #### Handling incoming requests:
    - When someone tries to access your website, their request goes to Nginx first. Nginx then decides where to send that request based on rules you've set up.

- #### Load balancing:
  - If you have multiple servers or "kitchens," Nginx can distribute incoming requests among them, making sure no one server gets overwhelmed.
- #### Caching:
  - Nginx can store copies of frequently accessed data, like images or web pages, so it can serve them faster without having to request them from your main server every time.
- #### Security:
  - Nginx can help protect your website from malicious attacks by filtering out suspicious requests and providing features like SSL encryption.
- #### Reverse proxy:
  - Nginx can act as an intermediary between your users and your web server, handling tasks like serving static files or compressing data before sending it to the user.

#### Overall, Nginx is a powerful tool for making sure your website runs smoothly, efficiently, and securely, even when you have a lot of traffic coming in.

![test.png](images%2Ftest.png)



