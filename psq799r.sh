#!/bin/bash
#  sshpass -f /root/ubpwd ssh -y rootsu@$(cat /root/ubhost) -p 60922;
# CONNECT TO SSH ->>>>>>       sshpass -p $(cat /root/ubpwd) ssh rootsu@$(cat /root/ubhost) -p 60922

rm /root/.ssh/known_hosts; sshpass -p $(cat /root/ubpwd) ssh -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -R 51433:127.0.0.1:1433 -R 55432:127.0.0.1:5432 -R 41022:127.0.0.1:22 $strrev  rootsu@$(cat /root/ubhost) -p 60922&

# MAINTENANCE CHECK
# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Installing Docker..."

    # Update the package list
    sudo apt-get update -y
    
    # Install prerequisites
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Add Docker's GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Add Docker's repository
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Update the package list again
    sudo apt-get update -fy
    
    # Install Docker
    sudo apt-get install -fy docker-ce

    # Start Docker and enable it to start at boot
    sudo systemctl start docker
    sudo systemctl enable docker

    echo "Docker has been installed successfully."
else
    echo "Docker is already installed."
fi

# install mssql database
# Check if the Docker container named "mssql2022_1" exists and is running
if [ "$(docker ps -q -f name=mssql2022_1)" ]; then
    echo "Container mssql2022_1 is running."
elif [ "$(docker ps -a -q -f name=mssql2022_1)" ]; then
    echo "Container mssql2022_1 exists but is not running."
else
    echo "Container mssql2022_1 does not exist."
     docker run -d --restart always --name mssql2022_1 -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Rpassw!1' -p 1433:1433 -h mssqlserver22 mcr.microsoft.com/mssql/server:latest
fi
 
# install postgres database
# Check if the Docker container named "myPostgresDb" exists and is running
if [ "$(docker ps -q -f name=myPostgresDb)" ]; then
    echo "Container myPostgresDb is running."
elif [ "$(docker ps -a -q -f name=myPostgresDb)" ]; then
    echo "Container myPostgresDb exists but is not running."
else
    echo "Container myPostgresDb does not exist."
docker run --restart=always --name myPostgresDb -p 5432:5432 -e POSTGRES_USER=postgresUser -e POSTGRES_PASSWORD=postgresPW -e POSTGRES_DB=postgresDB -d postgres
fi

