#! /bin/bash
sudo yum update -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

. ~/.nvm/nvm.sh
nvm install node

sudo yum install git
git clone https://github.com/gSchool/sf-t4-demo-pomotodo-be.git 
cd sf-t4-demo-pomotodo-be
npm install

echo -e "PORT=5000\nmongoURI=mongodb://10.0.2.185:27017" > .env

npm run start