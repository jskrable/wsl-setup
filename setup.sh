#!/bin/bash
# jskrable
# 5-7-21
# setup important software on a new Debian/Ubuntu WSL install
# put someone accessible from WSL, like Desktop or user root directory
# change into directory, then run bash ./setup.sh

# set home dir
home="$PWD"
alias reset=". ~/.bashrc"

# standard updates 
echo "Standard Updates-------------------------------------------------"
sudo apt update && sudo apt upgrade -y
# install some common packages
sudo apt install git vim nano ssh curl jq zip unzip

# setup z
echo "Installing z.sh--------------------------------------------------"
mkdir -p ~/code && cd ~/code
git clone https://github.com/rupa/z.git
cd z
z_loc="$PWD/z.sh"
echo "" >> ~/.bashrc
echo "# z.sh path" >> ~/.bashrc
echo ". $z_loc" >> ~/.bashrc
cd $home
echo "cd around normally for a bit, then use"
echo "  z [fuzzy path]"
echo "to automatically change into frequent/recent directories"

# setup git ssh
echo "Setting up Github SSH Auth---------------------------------------"
echo "Please enter email addresses associated with BU Github Account:"
read email
cd ~/.ssh
echo "Generating keys. Use default filenames and remember your passphrase."
ssh-keygen -t ed25519 -C $email
ssh-add ~/.ssh/id_ed25519
echo "Copy this public key to your clipboard and follow the instructions at: https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account"
cat id_ed25519.pub
echo "Once the public key is added to your github account, make sure to use the SSH link when cloning a repo. Your private key will then authenticate all requests."
cd $home

# setup nvm and node
echo "Setting up Node.js-----------------------------------------------"
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
echo "Installing LTS Node and NPM..."
# reset
# nvm install 'lts/*' --reinstall-packages-from=default --latest-npm
# nvm use node

# setup Python
echo "Setting up Python------------------------------------------------"
echo "Installing dependencies for pyenv..."
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
echo "Installing pyenv..."
curl https://pyenv.run | bash
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
cd $home

echo "Setting up AWS CLI-----------------------------------------------"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

reset
echo "Setup complete. All packages should be installed. Some things to consider implementing:"
echo ""
echo "Add alias to your favorite editor in .bashrc. Running Something like the below example will add it:"
echo "echo alias sublime='/mnt/c/Program\ Files/Sublime\ Text\ 3/subl.exe' >> .bashrc"
echo ""
echo "Installing node and python versions with the version managers installed earlier"
echo ""
echo "Sample Node installation for latest stable version:"
echo "nvm install node"
echo "nvm use node"
echo ""
echo "Sample Python installation for 3.8.10:"
echo "pyenv install 3.8.10 -v"
echo "pyenv global 3.8.10"
echo ""
echo "Happy commanding!"
