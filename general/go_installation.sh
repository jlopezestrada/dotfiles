# Remove Go installation if neccesary
# sudo rm -rf /usr/local/go

# 1. latest version from go website
VER="go1.24.6" # latest version, update if neccesary
OS_ARCHITECTURE="linux-amd64" # architecture of the system, use arm if neccesary

# 2. download and extraction
wget "https://go.dev/dl/${VER}.${OS_ARCHITECTURE}.tar.gz"
sudo tar -C /usr/local -xzf "${VER}.${OS_ARCHITECTURE}.tar.gz"

# 3. add Go to PATH
echo 'export PATH="/usr/local/go/bin:$PATH"' >> ~/.profile

# 4. apply changes
source ~/.profile

# 5. verify Go installation
go version
