# Secure DB with a Network Virtual Appliance (NVA)


![img_2.png](img_2.png)

## How does it help?
Having an NVA is like having an additional dedicated layer of security. Think of it as a firewall. It lives in its own subnet and filters out any requests. This means that it can choose what can even get access and to where. 
- It has its own rules and helps to divert internal traffic
- It is like having a gate before your house. You dont want all the traffic handled at your front door you dont even want people at your front foor. This acts as a gate before anyone can even get access to your front door.
- This increases the security because now its harder for any traffic to get to our DB subnet becuase any requests get filtered by our NVA and only the right requests will make it through before being checked again by the NSG of the db or its subnet

## How does it work?
1. From the diagram we can see we connect to our app like normal. 
2. Our app then needs to go to the database.
3. It goes through a routing table that we created to know where it needs to go (predefined route it needs to take)
4. From the routing table it goes to our NVA
5. Our NVA processes the request with its own rules and sends it to our DB subnet 
6. From there it goes to the NSG and to the DB and then it sends back the data

## How to set up

We will do it using the diagram with the steps labelled above

### Virtual network

1. First we need to create our virtual network with 3 subnets so go to virtual networks and click create. Dont forget tags
![img_3.png](img_3.png)

2. Add the subnets. 
   1. Public 10.0.2.0/24
   2. DMZ 10.0.3.0/24
   3. Private 10.0.4.0/24 and for *only* this one check the private subnet box
   ![img_4.png](img_4.png) <br>
Should end up with this (make sure virtual network address space as shown): 
![img_5.png](img_5.png)

3. Add tags and create

### Database VM

1. Create a VM as normal using the DB image
2. You can find the image and create it that way
![img_6.png](img_6.png)
3. Private subnet and open port 22 for ssh
4. Dont create a public IP
![img_7.png](img_7.png)

![img_8.png](img_8.png)
6. Add tags and create

### App VM

1. Create vm as normal or go to image and create from there same as earlier
![img_9.png](img_9.png)
2. Put it in the public subnet with ports 80 and 22 open for ssh and http
3. Add user data to run the app. Copy the database private IP created in the last step and add that to the user data 
    ```
    #!bin/bash
    export DB_HOST=mongodb://privateip:27017/posts
    cd /tech258_sparta_test_app/app
    sudo -E npm install
    sudo pm2 stop all
    sudo -E pm2 start app.js
    sudo -E pm2 restart app.js
    ```
4. Check details, choose tags and create
![img_10.png](img_10.png)
5. Check app is running by using public ip and also checking if database is running using /posts after the public IP
![img_11.png](img_11.png)
![img_12.png](img_12.png)
![img_13.png](img_13.png)
6. Done!

### NVA setup

1. Set up a regular VM with Ubuntu 22.04
2. Allow SSH
3. Put it in availability zone 2. Each one in their own incase one zone fails.
4. Place it in the ***dmz-subnet*** we created with our virtual network
5. Add tags, check details and create
![img_14.png](img_14.png)

#### IP forwarding 

1. We need to go to the NIC and enable IP forwarding. We do this by going to the instance, scrolling to network settings and clicking the network interface highlighted in yellow
![img_15.png](img_15.png)
We do this so that the app wil be able to first be routed to our NVA then our NVA can forward the IP and send it to the database if it meets the rules we will set up 
2. Tick the checkbox to enable IP forwarding to allow us to send traffic from the NVA to the database
![img_16.png](img_16.png)
3. Now we need to SSH into our NVA and set up IP forwarding on the VM and also set our rules.
    1. Once we SSH in and first enable IP forwarding.
   2. We can see its not running when we do this command `sysctl net.ipv4.ip_forward`
   3. ![img_17.png](img_17.png) If it says =0 it means its off
   4. Run this command to change the file `sudo nano /etc/sysctl.conf`
   5. ![img_18.png](img_18.png) Uncomment the shown line and save the file
   6. We now have to restart the process to update the new variables (apply our changes) use the command `sudo sysctl -p`
   7. It should now say that it =1 meaning its enabled ![img_19.png](img_19.png)
4. Now we have to create our IP table rules. This only allows certain packets to be sent so adds to our security.
   1. We can create a script using `nano script.sh` and then using this script:
   2. *We need to update before running the script generally, but I have added it to the script to save time.*
   ```
    #!/bin/bash
    # update and upgrade packages
    sudo apt update -y
    sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y  
    # configure iptables
     
    echo "Configuring iptables..."
     
    # ADD COMMENT ABOUT WHAT THE FOLLOWING COMMAND(S) DO
    sudo iptables -A INPUT -i lo -j ACCEPT
    sudo iptables -A OUTPUT -o lo -j ACCEPT
     
    # ADD COMMENT ABOUT WHAT THE FOLLOWING COMMAND(S) DO
    sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
     
    # ADD COMMENT ABOUT WHAT THE FOLLOWING COMMAND(S) DO
    sudo iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
     
    # ADD COMMENT ABOUT WHAT THE FOLLOWING COMMAND(S) DO
    sudo iptables -A INPUT -m state --state INVALID -j DROP
     
    # ADD COMMENT ABOUT WHAT THE FOLLOWING COMMAND(S) DO
    sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
    sudo iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
     
    # uncomment the following lines if want allow SSH into NVA only through the public subnet (app VM as a jumpbox)
    # this must be done once the NVA's public IP address is removed
    #sudo iptables -A INPUT -p tcp -s 10.0.2.0/24 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
    #sudo iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
     
    # uncomment the following lines if want allow SSH to other servers using the NVA as a jumpbox
    # if need to make outgoing SSH connections with other servers from NVA
    #sudo iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
    #sudo iptables -A INPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
     
    # ADD COMMENT ABOUT WHAT THE FOLLOWING COMMAND(S) DO
    sudo iptables -A FORWARD -p tcp -s 10.0.2.0/24 -d 10.0.4.0/24 --destination-port 27017 -m tcp -j ACCEPT
     
    # ADD COMMENT ABOUT WHAT THE FOLLOWING COMMAND(S) DO
    sudo iptables -A FORWARD -p icmp -s 10.0.2.0/24 -d 10.0.4.0/24 -m state --state NEW,ESTABLISHED -j ACCEPT
     
    # ADD COMMENT ABOUT WHAT THE FOLLOWING COMMAND(S) DO
    sudo iptables -P INPUT DROP
     
    # ADD COMMENT ABOUT WHAT THE FOLLOWING COMMAND(S) DO
    sudo iptables -P FORWARD DROP
     
    echo "Done!"
    echo ""
     
    # make iptables rules persistent
    # it will ask for user input by default
     
    echo "Make iptables rules persistent..."
    sudo DEBIAN_FRONTEND=noninteractive apt install iptables-persistent -y
    echo "Done!"
    echo ""
    ```
   3. Save it and run it using `bash script.sh`
5. Now we need to create a route table to actually send traffic to this NVA


### Route table

1. Search for route tables in azure
![img_20.png](img_20.png)
2. Create the route table and add tags
![img_21.png](img_21.png)
3. Create a route 
   - This tells the traffic the exact path to take.
   - We want our app to go to our NVA then to our Database
   - We set this up by saying our next hop (where it should go to first) is the NVM private IP (highlighted in green)
   - We say our destination or where it should end up is our private subnet so we state this also (blue)
     ![img_22.png](img_22.png)
4. We then associate it with our public subnet so traffic going from there knows which route to take
5. Go to subnets and click associate ![img_23.png](img_23.png)
6. Choose your public subnet and assoicate the route table to it.
7. test it owkrs by using your public ip for the app and adding /posts to it 
![img_24.png](img_24.png)
8. Done!

### Securing Further

1. We can adjust our DB NSG to do the following
   - Allow SSH from public subnet 
   - Allow Mongo DB from public subnet 
   - Allow ICMP from public subnet (optional)
   - Deny everything else 
   We can do this by going to our VM and scrolling down to network until we get to here
   ![img_25.png](img_25.png)

4. Click create port rule to add rules. Add the inbound rules above.
![img_26.png](img_26.png)
5. Make sure the deny has the lowest priority (highest number) so it executes after above rules. If you dont it will just deny everything as thats higher priority. Also ensure you delete the regular SSH from anywhere rule.
6. Check to see if app still running.
7. We can also change our bind ip on our mongodb to not allow requests from anywhere to further enhance security





