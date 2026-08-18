# Installing Docker Engine and Docker Compose

# Docker Installation
# Update package index and install required packages
sudo apt-get update
sudo apt-get install ca-certificates curl

# Create keyrings directory and add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index and install Docker Engine and Docker Compose
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
sudo docker run hello-world

# Docker Compose Installation
# Install Docker Compose plugin
sudo apt-get update
sudo apt-get install docker-compose-plugin

# Verify Docker Compose installation
docker compose version

# Installing Shuffle

# Clone Shuffle repository from GitHub
git clone https://github.com/Shuffle/Shuffle

# Change directory to Shuffle
cd Shuffle

# Create a database folder and set appropriate permissions
mkdir shuffle-database                    # Create a database folder
sudo chown -R 1000:1000 shuffle-database  # If you get an error using 'chown', add the user first with 'sudo useradd opensearch'

# Disable swap to prevent potential issues
sudo swapoff -a

# Start Shuffle services using Docker Compose
docker compose up -d

# Set system parameter for maximum virtual memory map count
sudo sysctl -w vm.max_map_count=262144
