#!/bin/sh
sudo pip3 install -r requirements.txt
python3 manage.py makemigrations
python3 manage.py migrate
sudo /etc/init.d/celeryd restart
