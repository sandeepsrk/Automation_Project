# Automation_Project

Writing a shell script to configure the Virtual Machine for hosting a web server and later automating some maintainance tasks.

The steps done in the shell script are mentioned below

1. Update the package list and repository.
2. Checks whether the apache2 webserver is installed or not.
3. If not, installs the apache2 webserver.
4. Ensure that the apache2 service is enabled.
5. Create a tar backup for the access log and error logs in specified format.
6. Copy the tar file to the s3 bucket.

