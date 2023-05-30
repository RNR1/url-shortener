#!/bin/sh
source venv/bin/activate
sudo git pull origin main
sudo pip install -r requirements.txt
python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic
sudo systemctl restart nginx
sudo systemctl restart gunicorn
