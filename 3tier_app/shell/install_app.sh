#!/bin/bash

set -eu -o pipefail

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install python3-pip
sudo apt-get -y install python3-venv
sudo apt-get -y install mysql-client
git clone https://github.com/Losmino13/realworld.git && cd realworld
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
./manage.py migrate
./manage.py runserver 0.0.0.0:8000 &
