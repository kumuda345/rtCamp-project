#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "Docker installed successfully."
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose not found. Installing Docker Compose..."
    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully."
fi

# Function to create a WordPress site
create_wordpress_site() {
    site_name=$1
    
    # Create a directory for the site
    mkdir $site_name
    cd $site_name
    
    # Create a docker-compose.yml file
    cat > docker-compose.yml <<EOF
version: '3'
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example_root_password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: example_password

  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - "8000:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: example_password
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_ADMIN_EMAIL: admin@example.com # Update with a valid email address
    volumes:
      - ./wp-content:/var/www/html/wp-content

volumes:
  db_data:
EOF

    # Start the containers
    docker-compose up -d

    # Add entry to /etc/hosts
    echo "127.0.0.1 $site_name" | sudo tee -a /etc/hosts

    # Prompt the user to open the site
    echo "WordPress site created successfully. Open http://$site_name in a browser."

    # Return to the previous directory
    cd -
}

# Function to enable/disable the site
toggle_site() {
    site_name=$1
    cd $site_name
    
    # Check if containers are running
    if docker-compose ps | grep "Up" &> /dev/null; then
        # Stop the containers
        docker-compose stop
        echo "Site '$site_name' disabled."
    else
        # Start the containers
        docker-compose start
        echo "Site '$site_name' enabled."
    fi
    
    cd -
}

# Function to delete the site
delete_site() {
    site_name=$1
    cd $site_name
    
    # Stop and remove the containers
    docker-compose down -v
    
    # Remove the directory
    cd ..
    rm -rf $site_name
    
    # Remove entry from /etc/hosts
    sudo sed -i "/$site_name/d" /etc/hosts
    
    echo "Site '$site_name' deleted."
}

# Main script logic
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <command> <site_name>"
    echo "Commands:"
    echo "  create    - Create a WordPress site"
    echo "  toggle    - Enable/disable the site"
    echo "  delete    - Delete the site"
    exit 1
fi

command=$1
site_name=$2

case $command in
    create)
        create_wordpress_site $site_name
        ;;
    toggle)
        toggle_site $site_name
        ;;
    delete)
        delete_site $site_name
        ;;
    *)
        echo "Invalid command. Available commands: create, toggle, delete"
        exit 1
        ;;
esac
