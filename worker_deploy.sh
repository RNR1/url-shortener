#!/bin/sh
source venv/bin/activate
sudo git pull origin main
sudo pip install -r requirements.txt
python manage.py makemigrations
python manage.py migrate
sudo /etc/init.d/celeryd restart
