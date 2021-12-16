#! /bin/bash
sudo yum update -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash 
. ~/.nvm/nvm.sh
nvm install 16.13.0
nvm use 16.13.0
node -e "console.log('Running Node.js ' + process.version)"

sudo yum install git
git clone https://github.com/gSchool/sf-t4-pomotodo-fe.git
cd sf-t4-pomotodo-fe
npm install

sudo nano .env

npm run build

npm install -g serve

sudo yum install libcap-devel
sudo setcap cap_net_bind_service=+ep /home/ec2-user/.nvm/versions/node/v16.13.0/bin/node

serve -s build -l 80