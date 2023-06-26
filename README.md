# rtCamp-project
WordPress Docker Compose Script
This script creates a WordPress site using Docker Compose. It also provides functionality to enable/disable and delete the site.
**
Installation
Install Docker by following the instructions for your operating system on the official Docker website.
Clone this repository to your local machine.

Usage
To use the script, navigate to the cloned repository in your terminal and run the following command:
./wordpress-docker-compose.sh <command> <site_name>

Replace <command> with one of the following:
create: Create a new WordPress site.
toggle: Enable/disable an existing site.
delete: Delete an existing site.
Replace <site_name> with the name you want to give your WordPress site.

Create a WordPress Site
To create a new WordPress site, run the following command:
./wordpress-docker-compose.sh create <site_name>

This will create a new directory with the specified name and generate a docker-compose.yml file inside it. The file will contain the necessary configuration to run a WordPress site using Docker Compose.


Enable/Disable a Site
To enable or disable an existing site, run the following command:
./wordpress-docker-compose.sh toggle <site_name>
This will start or stop the containers associated with the specified site.


Delete a Site
To delete an existing site, run the following command:
./wordpress-docker-compose.sh delete <site_name>



This will stop and remove the containers associated with the specified site, delete the directory, and remove the entry from the /etc/hosts file.




Additional Information
The script uses the latest version of WordPress and MySQL.
The MySQL root password is set to example_root_password.
The WordPress admin email is set to admin@example.com. Update this value in the docker-compose.yml file to use your own email address.
The script adds an entry to the /etc/hosts file to allow you to access the site at http://<site_name> in your browser.
If Docker or Docker Compose are not installed, the script will install them automatically.
The script uses the curl command to download the Docker installation script and the Docker Compose binary. If curl is not installed, you will need to install it manually.
The script requires sudo privileges to modify the /etc/hosts file and to run Docker and Docker Compose commands.
