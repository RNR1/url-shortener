#!/bin/sh
sudo pip3 install -r requirements.txt
python3 manage.py makemigrations
python3 manage.py migrate --noinput
python3 manage.py collectstatic --noinput
sudo systemctl restart nginx
sudo systemctl restart gunicorn
