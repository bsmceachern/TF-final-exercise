#! /bin/bash
sudo yum update -y

echo -e "[mongodb-org-5.0]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/5.0/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc" > /etc/yum.repos.d/mongodb-org-5.0.repo

sudo yum install -y mongodb-org

sed -i '29 s/^/# /' /etc/mongod.conf
sed -i $'30i \ \ bindIpAll: true' /etc/mongod.conf

sudo systemctl start mongod

sudo systemctl enable mongod

