#!/bin/bash


echo "Welcome to the 'Dependencies Node Setup' by CryptoBdarija"

# Log file path and maximum log size
LOGFILE="$HOME/prepare_server_log.log"
MAX_LOG_SIZE=52428800  # 50MB

# Color codes
COLOR_RESET="\033[0m"
COLOR_BLUE="\033[1;34m"
COLOR_MAGENTA="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_CYAN="\033[1;36m"
COLOR_RED="\033[1;31m"
COLOR_GREEN="\033[1;32m"

# Function to log messages to a file
log_message() {
    echo -e "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

# Rotate log file if its size exceeds the limit
rotate_log_file() {
    if [ -f "$LOGFILE" ] && [ $(stat -c%s "$LOGFILE") -ge $MAX_LOG_SIZE ]; then
        mv "$LOGFILE" "$LOGFILE.bak"
        touch "$LOGFILE"
        log_message "Log file rotated. Previous log archived as $LOGFILE.bak"
    fi
}

# ================================
# Installation and Configuration Functions
# ================================

install_dependencies() {
    echo -e "${COLOR_BLUE}\nInstalling system dependencies...${COLOR_RESET}"
    log_message "Installing system dependencies..."
    sudo apt update -y >/dev/null 2>&1 && sudo apt upgrade -y >/dev/null 2>&1
    sudo apt-get install -y screen curl unzip htop tar wget aria2 clang pkg-config libssl-dev jq build-essential git make ncdu npm >/dev/null 2>&1
    echo -e "${COLOR_GREEN}System dependencies installed successfully.${COLOR_RESET}"
    log_message "System dependencies installed."
}

install_nvm() {
    echo -e "${COLOR_BLUE}\nInstalling NVM (Node Version Manager)...${COLOR_RESET}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    echo -e "${COLOR_GREEN}NVM installed successfully.${COLOR_RESET}"
    log_message "NVM installed."
}

install_node() {
    echo -e "${COLOR_BLUE}\nInstalling Node.js using NVM...${COLOR_RESET}"
    nvm install 20
    nvm use 20
    echo -e "${COLOR_GREEN}Node.js 20 installed successfully.${COLOR_RESET}"
    log_message "Node.js installed."
}

install_go() {
  sudo rm -rf /usr/local/go
  curl -L https://go.dev/dl/go1.22.4.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
  echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> $HOME/.bash_profile
  source .bash_profile
  go version
}

install_python() {
  sudo apt install python3 -y
  python3 --version

  sudo apt install python3-pip -y
  pip3 --version
}

install_docker() {
    echo -e "${COLOR_BLUE}\nChecking Docker installation...${COLOR_RESET}"
    if ! command -v docker &> /dev/null; then
        echo -e "${COLOR_YELLOW}Docker not found. Installing Docker...${COLOR_RESET}"
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update >/dev/null 2>&1
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io >/dev/null 2>&1
        echo -e "${COLOR_GREEN}Docker installed successfully.${COLOR_RESET}"
        log_message "Docker installed."
    else
        echo -e "${COLOR_GREEN}Docker is already installed.${COLOR_RESET}"
        log_message "Docker already installed."
    fi
}

install_docker_compose() {
    echo -e "${COLOR_BLUE}\nChecking Docker Compose installation...${COLOR_RESET}"
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${COLOR_YELLOW}Docker Compose not found. Installing Docker Compose...${COLOR_RESET}"
        curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo -e "${COLOR_GREEN}Docker Compose installed successfully.${COLOR_RESET}"
        log_message "Docker Compose installed."
    else
        echo -e "${COLOR_GREEN}Docker Compose is already installed.${COLOR_RESET}"
        log_message "Docker Compose already installed."
    fi
}

install_foundry() {
    echo -e "${COLOR_BLUE}\nInstalling Foundry using external script...${COLOR_RESET}"
    log_message "Installing Foundry using Foundry.sh."
    bash <(curl -s https://raw.githubusercontent.com/choir94/Airdropguide/refs/heads/main/Foundry.sh)
    echo -e "${COLOR_GREEN}Foundry installed successfully.${COLOR_RESET}"
    log_message "Foundry installed successfully."

    # Set PATH for Foundry
    echo -e "${COLOR_BLUE}\nSetting PATH for Foundry...${COLOR_RESET}"
    echo 'export PATH=$HOME/.foundry/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    echo -e "${COLOR_GREEN}Foundry PATH set successfully.${COLOR_RESET}"

    # ================================
    # Running Foundry
    # ================================
    echo -e "${COLOR_BLUE}\nStarting Foundry...${COLOR_RESET}"
    foundry up
    log_message "Foundry started successfully."
}

# ================================
# Installation and configuration
# ================================

install_dependencies
install_nvm
install_node
install_docker
install_docker_compose
install_go
install_python
install_foundry

echo -e "${COLOR_BLUE}\nInstallation completed.${COLOR_RESET}"
log_message "Installation completed."

echo "Setup complete! The server is ready."
echo "Subscribe: https://t.me/Crypto_Bdarija1"