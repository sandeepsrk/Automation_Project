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
sudo systemctl is-active --quiet service && echo "Service is running"


echo "Enabling apache service"
sudo systemctl enable apache2

echo "Creating tar files for the log"


find /var/log/apache2 -name "access.log" -o -name "error.log" | tar -zcvf $myname-httpd-logs-$timestamp.tar.gz .
mv sandeep-httpd-logs-$timestamp.tar.gz /tmp/



echo "Installing aws cli"
sudo apt update -y
sudo apt install awscli -y

echo "Copying the archive to S3 bucket"
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar



