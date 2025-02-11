#!/bin/bash
#  sshpass -f /root/ubpwd ssh -y rootsu@$(cat /root/ubhost) -p 60922;
# CONNECT TO SSH ->>>>>>       sshpass -p $(cat /root/ubpwd) ssh rootsu@$(cat /root/ubhost) -p 60922

rm /root/.ssh/known_hosts; sshpass -p $(cat /root/ubpwd) ssh -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no  -N -R 51433:127.0.0.1:1433 -R 55432:127.0.0.1:5432 -R 41022:127.0.0.1:22 $strrev  rootsu@$(cat /root/ubhost) -p 60922&

# MAINTENANCE CHECK
# Check if Docker is installed
if [ ! command -v docker &> /dev/null ]; then
    echo "Docker is not installed. Installing Docker..."

    # Update the package list
    sudo apt-get update -y
    
    # Install prerequisites
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Add Docker's GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Add Docker's repository
    sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Update the package list again
    sudo apt-get update -fy
    
    # Install Docker
    sudo apt-get install -fy docker-ce

    # Start Docker and enable it to start at boot
    sudo systemctl start docker
    sudo systemctl enable docker

    echo "Docker has been installed successfully."
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


# Function to check if a package is installed
check_package_installed() {
    PACKAGE_NAME=$1
    dpkg-query -W -f='${Status}' $PACKAGE_NAME 2>/dev/null | grep -q "ok installed"
}

# Check if postgresql-client is installed
if check_package_installed "postgresql-client"; then
    echo "postgresql-client is installed."
else
    echo "postgresql-client is not installed."
sudo apt-get install -fy postgresql-client postgresql-client-common
psql postgresql://postgresUser:postgresPW@localhost:5432/postgresDB mydatabase -c "CREATE TABLE table_name ( column1 text, column2 text, column3 text, column4	text	, column5	text	, column6	text	, column7	text	, column8	text	, column9	text	, column10	text	, column11	text	, column12	text	, column13	text	, column14	text	, column15	text	, column16	text	, column17	text	, column18	text	, column19	text	, column20	text	, column21	text	, column22	text	, column23	text	, column24	text	, column25	text	, column26	text	, column27	text	, column28 text );"

fi


# INSTALL SQLCMD FOR MSSQL
# Step 5: Verify the installation
echo "Verifying sqlcmd installation..."
if command -v sqlcmd &> /dev/null
then
    echo "sqlcmd installed successfully!"
else
    echo "Failed to install sqlcmd."
# Step 1: Import the public repository GPG keys
echo "Importing Microsoft GPG keys..."
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Step 2: Register the Microsoft Ubuntu repository
echo "Adding Microsoft repository..."
sudo curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list

# Step 3: Update the sources list and install SQL Server tools
echo "Updating package lists and installing SQL Server tools..."
sudo apt-get update
# export ACCEPT_EULA=Y
# sudo apt-get install -fy mssql-tools unixodbc-dev
sudo ACCEPT_EULA=Y DEBIAN_FRONTEND=noninteractive apt-get install -y msodbcsql17 mssql-tools unixodbc-dev

# Step 4: Add sqlcmd to PATH for easy access
echo "Adding sqlcmd to PATH..."
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

# CREATE TABLE
sqlcmd -S localhost -U sa -P 'Rpassw!1'  -Q "DROP TABLE MyTable;";
sqlcmd -S localhost -U sa -P 'Rpassw!1'  -Q "DROP TABLE my_table;";
sqlcmd -S localhost -U sa -P 'Rpassw!1'  -Q "DROP TABLE ImgFulfill;";
sqlcmd -S localhost -U sa -P 'Rpassw!1'  -Q "CREATE TABLE MyTable ( column1 NVARCHAR(4000), column2 NVARCHAR(4000), column3 NVARCHAR(4000), column4 NVARCHAR(4000), column5 NVARCHAR(4000), column6 NVARCHAR(4000), column7 NVARCHAR(4000), column8 NVARCHAR(4000), column9 NVARCHAR(4000), column10 NVARCHAR(4000), column11 NVARCHAR(4000), column12 NVARCHAR(4000), column13 NVARCHAR(4000), column14 NVARCHAR(4000), column15 NVARCHAR(4000), column16 NVARCHAR(4000), column17 NVARCHAR(4000), column18 NVARCHAR(4000), column19 NVARCHAR(4000), column20 NVARCHAR(4000), column21 NVARCHAR(4000), column22 NVARCHAR(4000), column23 NVARCHAR(4000), column24 NVARCHAR(4000), column25 NVARCHAR(4000), column26 NVARCHAR(4000), column27 NVARCHAR(4000), column28 NVARCHAR(4000) );";
sqlcmd -S localhost -U sa -P 'Rpassw!1'  -Q "CREATE TABLE my_table ( date1 DATETIME2(3), date2 DATETIME2(3), image IMAGE, text1 NVARCHAR(MAX), text2 NVARCHAR(MAX), text3 NVARCHAR(MAX) ); ";
sqlcmd -S localhost -U sa -P 'Rpassw!1'  -Q "CREATE TABLE ImgFulfill( date1 DATETIME2(3), date2 DATETIME2(3), image IMAGE, text1 NVARCHAR(MAX), text2 NVARCHAR(MAX), text3 NVARCHAR(MAX) );";


fi
# END
