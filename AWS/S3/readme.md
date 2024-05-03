# S3- Simple Storage Service
- accessible from any where any time any amount of data
- can be used to host a static website in cloud 
- unstructured
- blobs need to be stored inside buckets
- default setting - everything private
- if blob is public then you have a url/endpoint to access them from
- redundancy built in
- access from console, AWS CLI, python boto3
- cant have buckets inside of buckets
- requests made to bucets cost money - even if denied

1. Run following to install dependencies

```
sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo apt-get install python3-pip -y
sudo pip install awscli
alias python=python3
```

2. Login to AWS

- need access key  ID and secret access key

```
aws configure
Key ID xxxx
Key Secret xxxx
region eu-west-1
output json
```
Test connection with `aws s3 ls`

## CRUD Method

When we are building APIs, we want our models to provide four basic types of functionality. The model must be able to:
- **Create**
- **Read**
- **Update**
- **Delete**

Often refer to these functions by the acronym **CRUD**.

A model should have the ability to perform at most these four functions in order to be complete.

If an action cannot be described by one of these four operations, then it should potentially be a model of its own.

### AWS S3 CRUD Commands

#### To get help with any commands use

```
aws help
aws <command> help
aws <command> <subcommand> help
```


#### Make bucket
```
aws s3 mb s3://<name of bucket> --region <region e.g. us-west-1>
aws s3 mb s3://tech258-dan-first-bcket
```

#### Copy to bucket
```
aws s3 cp <filename> s3://<bucket name>
aws s3 cp ttest.txt s3://tech258-dan-first-bcket 
```

#### Download from bucket
```
aws s3 sync s3://<name of bucket> <directory to download to>
aws s3 sync s3://tech258-dan-first-bcket .
```

#### Delete from bucket 

:warning: DANGEROUS - NO WARNING. Will delete verything in folder with no confirmation :warning:

```
aws s3 rm s3://<name of bucket>/<name of file to remove>
aws s3 rm s3://tech258-dan-first-bcket/text.txt
```
add --recursive to remove all folders and files in specified directory
```
aws s3 rm s3://tech258-dan-first-bcket --recursive 
```
#### Delete bucket

:boom: DANGEROUS - NO WARNING. Will remove bucket with no confirmation :boom:
```
aws s3 rb s3://<bucket name>
aws s3 rb s3://tech258-dan-first-bcket
```
bucket has to be empty. if not use --force to delete the bucket and everything in it

```
aws s3 rb s3://<bucket name> --force
aws s3 rb s3://tech258-dan-first-bcket --force
```
## Using Python boto3


Research the documentation on AWS/Python for Python boto3 package to create and manage AWS S3 resources and complete all the following tasks under DOD 
 
### Install Boto3
1. Install the latest Boto3 release via pip:
`pip install boto3`

### Using boto3 on python

#### :warning: Ensure aws has been configured in your CLI

#### Broken into input or no input scripts

##### To list all buckets create the following script
```python
import boto3
# Choose resource to work on
s3 = boto3.resource('s3')
# Print out bucket names
for bucket in s3.buckets.all():
    print(bucket.name)
```
##### Create an S3 bucket

###### Input

```python

import boto3

def create_bucket(bucket_name):
    # Create an S3 client
    s3 = boto3.client('s3')
    
    # Create bucket
    s3.create_bucket(Bucket=bucket_name)
    print(f"Bucket '{bucket_name}' created successfully.")

# Prompt the user to input the bucket name
bucket_name = input("Enter the name of the bucket: ")

# Call the function to create the bucket
create_bucket(bucket_name)
```

###### No input

```python
import boto3

# Choose resource to work on
s3 = boto3.client('s3')
# Bucket name
bucket_name = 'tech255-dan-2nd-bcket'

# Create bucket
s3.create_bucket(Bucket=bucket_name)
print(f"Bucket '{bucket_name}' created successfully.")
```
##### Upload data/files to bucket
```python
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Upload file
s3.upload_file('/path/to/your/file.txt', 'tech258-dan-2nd-bcket', 'file.txt')
print("File uploaded successfully.")

```
##### Upload all files in a folder
###### Input
```python

import boto3
import os

def upload_files_to_s3(s3, local_path, bucket_name, s3_folder_path):
    # Iterate through files in the local folder
    for root, dirs, files in os.walk(local_path):
        for file_name in files:
            local_file_path = os.path.join(root, file_name)
            # Determine the key (S3 object path) based on local folder structure
            s3_object_key = os.path.relpath(local_file_path, local_path)
            # Join S3 folder path with local object key
            s3_object_key = os.path.join(s3_folder_path, s3_object_key)
            # Upload the file to S3 bucket
            s3.upload_file(local_file_path, bucket_name, s3_object_key)
            print(f"File '{file_name}' uploaded successfully to '{s3_object_key}'.")

# Create an S3 client
s3 = boto3.client('s3')

# Prompt the user to input the bucket name
bucket_name = input("Enter the name of the bucket: ")

# Prompt the user to input the local folder path containing the files to upload
local_folder_path = input("Enter the local folder path containing the files to upload: ")

# Prompt the user to input the folder path in the bucket
s3_folder_path = input("Enter the folder path in the bucket to upload the files to (leave blank for root): ")

# Call the function to upload files to the S3 bucket
upload_files_to_s3(s3, local_folder_path, bucket_name, s3_folder_path)
```
###### No input
```python
import boto3
import os

# Create an S3 client
s3 = boto3.client('s3')

# Folder containing files to upload
folder_path = '.'
# can replace . with '/path/to/your/folder'

# Bucket name
bucket_name = 'name of bucket'

# Iterate through files in the folder
for file_name in os.listdir(folder_path):
    file_path = os.path.join(folder_path, file_name)
    # Upload each file to S3 bucket
    s3.upload_file(file_path, bucket_name, file_name)
    print(f"File '{file_name}' uploaded successfully.")

```

##### Download files

###### Input
```python
import boto3

def download_single_file(s3, bucket_name, file_name, local_path):
    # Download the file
    s3.download_file(bucket_name, file_name, local_path)
    print(f"File '{file_name}' downloaded successfully to '{local_path}'.")

# Create an S3 client
s3 = boto3.client('s3')

# Prompt the user to input the bucket name
bucket_name = input("Enter the name of the bucket: ")

# Prompt the user to input the file name
file_name = input("Enter the name of the file to download: ")

# Prompt the user to input the local path to save the file to
local_path = input("Enter the local path to save the file to: ")

# Call the function to download the single file
download_single_file(s3, bucket_name, file_name, local_path)

```

###### No input 
```python
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Bucket name
bucket_name = 'tech257-ramon-test-boto3'

# File to download
file_path = '/path/to/save/downloaded/file.txt'

# Download file
s3.download_file(bucket_name, 'file.txt', file_path)
print("File downloaded successfully.")

```

##### download all files

###### Input
```python
import boto3
import os

def download_files_from_s3(s3, bucket_name, local_directory):
    # Create the local directory if it doesn't exist
    os.makedirs(local_directory, exist_ok=True)

    # List all objects in the bucket
    response = s3.list_objects_v2(Bucket=bucket_name)

    # Iterate through objects and download each one
    for obj in response.get('Contents', []):
        object_key = obj['Key']
        local_file_path = os.path.join(local_directory, object_key)
        s3.download_file(bucket_name, object_key, local_file_path)
        print(f"File '{object_key}' downloaded successfully.")

# Create an S3 client
s3 = boto3.client('s3')

# Prompt the user to input the bucket name
bucket_name = input("Enter the name of the bucket: ")

# Prompt the user to input the local directory to download files to
local_directory = input("Enter the local directory to download files to: ")

# Call the function to download files from S3 bucket
download_files_from_s3(s3, bucket_name, local_directory)

```
###### No input
```python
import boto3
import os

def download_files_from_s3(s3, bucket_name, local_directory):
    # Create the local directory if it doesn't exist
    os.makedirs(local_directory, exist_ok=True)

    # List all objects in the bucket
    response = s3.list_objects_v2(Bucket=bucket_name)

    # Iterate through objects and download each one
    for obj in response.get('Contents', []):
        # Get the object key
        object_key = obj['Key']

        # Construct the local file path
        local_file_path = os.path.join(local_directory, object_key)

        # Download the object
        s3.download_file(bucket_name, object_key, local_file_path)
        print(f"File '{object_key}' downloaded successfully.")

# Create an S3 client
s3 = boto3.client('s3')

# Bucket name
bucket_name = 'tech257-ramon-test-boto3'

# Local directory to download files to
local_directory = '/path/to/save/downloaded/files'

# Call the function to download files from S3 bucket
download_files_from_s3(s3, bucket_name, local_directory)

```

##### Delete a file

###### Input
```python
import boto3

def delete_single_file(s3, bucket_name, file_name):
    # Delete the file
    s3.delete_object(Bucket=bucket_name, Key=file_name)
    print(f"File '{file_name}' deleted successfully.")

# Create an S3 client
s3 = boto3.client('s3')

# Prompt the user to input the bucket name
bucket_name = input("Enter the name of the bucket: ")

# Prompt the user to input the file name
file_name = input("Enter the name of the file to delete: ")

# Call the function to delete the single file
delete_single_file(s3, bucket_name, file_name)

```
###### No input
```python
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Delete file
s3.delete_object(Bucket='tech257-ramon-test-boto3', Key='file.txt')
print("File deleted successfully.")

```

##### Delete all files

###### Input
```python
import boto3

def delete_files_in_folder(s3, bucket_name, folder_prefix):
    # List all objects in the folder
    response = s3.list_objects_v2(Bucket=bucket_name, Prefix=folder_prefix)

    # If there are objects, delete each one
    if 'Contents' in response:
        for obj in response['Contents']:
            object_key = obj['Key']
            s3.delete_object(Bucket=bucket_name, Key=object_key)
            print(f"File '{object_key}' deleted successfully.")
    else:
        print("No files found in the specified folder.")

# Create an S3 client
s3 = boto3.client('s3')

# Prompt the user to input the bucket name
bucket_name = input("Enter the name of the bucket: ")

# Prompt the user to input the folder prefix (leave blank for root)
folder_prefix = input("Enter the folder prefix (leave blank for root): ")

# Call the function to delete files in the folder
delete_files_in_folder(s3, bucket_name, folder_prefix)


```
###### No input
```python
import boto3

def delete_files_in_folder(s3, bucket_name, folder_prefix):
    # List all objects in the folder
    response = s3.list_objects_v2(Bucket=bucket_name, Prefix=folder_prefix)

    # Iterate through objects and delete each one
    for obj in response.get('Contents', []):
        object_key = obj['Key']
        # Delete the object
        s3.delete_object(Bucket=bucket_name, Key=object_key)
        print(f"File '{object_key}' deleted successfully.")

# Create an S3 client
s3 = boto3.client('s3')

# Bucket name
bucket_name = 'name of bucket'

# Folder prefix (e.g., 'folder/subfolder/') or comment out for all
folder_prefix = 'folder/subfolder/' 

# Call the function to delete files in the folder
delete_files_in_folder(s3, bucket_name, folder_prefix)

```

##### Delete the bucket

##### Input 
```python


import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Prompt the user to input the bucket name
bucket_name = input("Enter the name of the bucket to delete: ")
# Delete bucket
s3.delete_bucket(Bucket=bucket_name)
print("Bucket deleted successfully.")
```
###### No input
```python
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Delete bucket
s3.delete_bucket(Bucket='name of bucket')
print("Bucket deleted successfully.")

```
##### Delete bucket with contents
###### Input
```python
import boto3

def delete_bucket_and_contents(s3, bucket_name):
    # List all objects in the bucket
    response = s3.list_objects_v2(Bucket=bucket_name)

    # If the bucket is not empty, delete all objects
    if 'Contents' in response:
        for obj in response['Contents']:
            object_key = obj['Key']
            s3.delete_object(Bucket=bucket_name, Key=object_key)
            print(f"File '{object_key}' deleted successfully.")

    # Delete the bucket
    s3.delete_bucket(Bucket=bucket_name)
    print(f"Bucket '{bucket_name}' deleted successfully.")

# Create an S3 client
s3 = boto3.client('s3')

# Prompt the user to input the bucket name
bucket_name = input("Enter the name of the bucket to delete: ")

# Call the function to delete bucket and its contents
delete_bucket_and_contents(s3, bucket_name)

```
###### No input
```python
import boto3

def delete_bucket_and_contents(s3, bucket_name):
    # List all objects in the bucket
    response = s3.list_objects_v2(Bucket=bucket_name)

    # If the bucket is not empty, delete all objects
    if 'Contents' in response:
        for obj in response['Contents']:
            object_key = obj['Key']
            s3.delete_object(Bucket=bucket_name, Key=object_key)
            print(f"File '{object_key}' deleted successfully.")

    # Delete the bucket
    s3.delete_bucket(Bucket=bucket_name)
    print(f"Bucket '{bucket_name}' deleted successfully.")

# Create an S3 client
s3 = boto3.client('s3')

# Bucket name
bucket_name = 'name of bucket'

# Call the function to delete bucket and its contents
delete_bucket_and_contents(s3, bucket_name)

```