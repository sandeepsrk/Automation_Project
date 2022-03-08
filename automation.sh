echo "#################################################"
echo "##### AUTOMATING APACHE SERVER SETUP#############"
echo "#################################################"

timestamp=$(date '+%d%m%Y-%H%M%S')
myname=sandeep
s3_bucket=upgrad-sandeep
echo "Updating the package list"
sudo apt update -y


if [ $( dpkg-query -l | grep apache2 | wc -l ) -eq 0 ]
then
    echo "Package not found"
    echo "Installing the package..."
    sudo apt install apache2 -y
else
    echo "Package already installed!"
fi

echo "Checking apache server is running"
sudo systemctl is-active --quiet apache2 && echo "Service is running"


echo "Enabling apache service"
sudo systemctl enable apache2

echo "Creating tar files for the log"


find /var/log/apache2 -name "access.log" -o -name "error.log" | tar -zcvf $myname-httpd-logs-$timestamp.tar .
filename=$myname-httpd-logs-$timestamp.tar
size=`du -k "$filename" | cut -f1`
echo $size
# mv sandeep-httpd-logs-$timestamp.tar /tmp/



 echo "Installing aws cli"
 sudo apt update -y
 sudo apt install awscli -y

 echo "Copying the archive to S3 bucket"
 aws s3 \
 cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
 s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

echo "Checking invenntory file exists or not"

FILE=/var/www/html/inventory.html
if [ -f "$FILE" ]; then
    echo "$FILE exists."
    sudo sh -c "echo 'httpd-logs\t$timestamp\ttar\t$size\t' >> $FILE"
else 
    echo "$FILE does not exist."
    sudo touch $FILE
    sudo sh -c "echo 'Log Type\tTime Created\t\tType\tSize' > $FILE"
    sudo sh -c "echo 'httpd-logs\t$timestamp\ttar\t$size\t' >> $FILE"
fi

echo "Setting cron job"
if [ $( dpkg-query -l | grep cron | wc -l ) -eq 0 ]
then
    echo "Package not found"
    echo "Installing the package..."
    sudo apt install cron -y
else
    echo "Package already installed!"
fi

sudo systemctl is-active --quiet cron && echo "Service is running"
sudo systemctl start cron
cron_file=/etc/cron.d/automation
sudo touch $cron_file
sudo sh -c "echo '0 10 * * * /root/Automation_Project/automation.sh' > $cron_file"
if [ -f "$FILE" ]; then
    echo "cron scheduled."
else 
    sudo sh -c "echo '0 10 * * * /root/Automation_Project/automation.sh' > $cron_file"
fi






