# 2 tier app deployment in azure

1. Create virtual networks <br><br>
   1. Go to virtual networks and then ***"Create"*** on the left <br><br>

      ![img_12.png](images/img_12.png) <br><br>

   2. Subnet + Resource group and name <br><br>
   ![img_7.png](images/img_7.png) <br><br>
   click next and next again until you get to IP addressess<br><br>
   ![img_8.png](images/img_8.png) <br><br>
   3. click ***"Add a subnet"***<br><br>
   
      make two subnets:<br><br>
      1. First one: Subnet name: public-subnet, Address range: 10.0.2.0/24

       ![img_9.png](images/img_9.png) <br><br>

       Press add <br><br>

       2. Second one: Subnet name: private-subnet, Address range: 10.0.3.0/24 <br><br>

        ![img_10.png](images/img_10.png) <br><br>

        Press add <br><br>

    4. Add your tags  <br><br>

        ![img_11.png](images/img_11.png) <br><br>

    5. click ***"Review + create"***  and then ***"Create"*** <br><br>

   2. Virtual Machine set up <br><br>
      1. App VM <br><br>

         go to virtual machines <br><br>
         ![img.png](images/img.png) <br><br>
         click create <br><br>
         ![img_1.png](images/img_1.png) <br><br>
    
         Our chosen parameters were given to us so follow if you want to use those (pictures) or choose your own. <br><br>
   
      2. Basics <br><br>

         sub + resource group and availability <br><br>
         ![img_2.png](images/img_2.png) <br><br>
         image and size <br><br>
         ![img_3.png](images/img_3.png) <br><br>
         choose admin account name and key <br><br>
         ![img_4.png](images/img_4.png) <br><br>
         choose basic inbound ports (optional -can edit and create security group later) <br><br>
         ![img_5.png](images/img_5.png) <br><br>
         once done click next:Disks <br><br>
      3. Disks <br><br>
         choose disk size and click next: networking <br><br>
      ![img_6.png](images/img_6.png) <br><br>
      4. Networking <br><br>
         1. Choose your virtual network you created earlier and your **<ins> public subnet for the app and private subnet for the database**. In this instance you can allow it to create a new public ip. <br><br>
         2. Choose advanced for ***"NIC network security group"*** <br><br>

          ![img_13.png](images/img_13.png) <br><br>
         3. under ***"Configure network security group"*** click ***"Create new"*** <br><br>

            Add appropriate name and inbound rules <br><br>

          ![img_14.png](images/img_14.png) <br><br>

           Should end up with this <br><br>

           ![img_15.png](images/img_15.png) <br><br>

       Click ***"OK"*** <br><br>

       (optional) check the box that says delete public ip and NIC with vm so when its terminated we dont have that resource. We can keep it if we want to reuse it. This is diff from aws <br><br>

       5. Click ***"Review + create"*** and add the same tags as the virtual network. Then click ***"Create"*** <br><br> 

   3. Database VM <br><br>

Follow the same steps except this time we only need port 22 open for ssh (see ***basics*** above) so dont need to create a nsg. One will be created for you. :warning: Remember to use the private IP for database vm in the script for the app VM! <br><br>

4. SSH into Vms <br><br>

Once made we want to ssh into our VMs and run our scripts we made before. LINK TO DB SCRIPT LINK TO APP SCRIPT <br><br>
:warning: Run db script first on db vm then app script on app vm <br><br>

We can SSH by finding our vm and clicking connect <br><br>
![img_16.png](images/img_16.png) <br><br>
then click into ***"Native SSH"*** <br><br> 

5. Check all is running by using public IP of app vm and adding /posts to the end of it
