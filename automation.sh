#!bin/Bash
sudo apt-get update
sudo apt install apache2
systemctl start apache2
systemctl enable apache2
sudo service apache2 status

#Tar FIle commands
timestamp=$(date '+%d%M%Y-%H%M%S')
tar_File_name=Archana-httpd-logs-$timestamp.tar
tar -cvf /tmp/$tar_File_name  /var/log/apache2/access.log

#Installing AWSCLI with commands
sudo apt install awscli

#aws configure  is hidden due to security purposee)

#Creating s3Bucket
name=upgrad-archana
aws s3 mb s3://${name}


#copying a tar file from ec2Instance to s3 bucket
aws s3 cp  /tmp/$tar_File_name s3://${name}/$tar_File_name

#Listing bucketname and files in bucket
aws s3 ls
aws s3 ls s3://$name


#task3

touch /var/www/html/inventory.html

Logname=httpd-logs
#DateCreated=$timestamp
LogType=$(file /tmp/$tar_File_name  | awk '{print $3}' )
size=$(du -sh $tarFile_name  | awk '{print $1}')

echo "$Logname  $timestamp   $LogType   $size" >>/var/www/html/inventory.html

#moving automation.sh to run cronjob
cp automation.sh /root
chmod u+x /root/automation.sh

#cronjob scrip
* * * * * root /root/automation.sh