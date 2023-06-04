from django.db import models
from django.conf import settings
import random
import string

import requests

MAX_HASH_LENGTH = 6


def generate_hash():
    return URL.generate_hash()


class URL(models.Model):
    hash = models.CharField(
        primary_key=True, max_length=MAX_HASH_LENGTH, editable=False, default=generate_hash)
    original_url = models.URLField()

    @staticmethod
    def generate_hash(length=MAX_HASH_LENGTH) -> str:
        characters = string.ascii_letters + string.digits + '!$%^&*_'
        return ''.join([random.choice(characters) for i in range(length)])

    def short_url(self):
        return f'{settings.BACKEND_URL}/{self.hash}/'

    def __str__(self) -> str:
        return f"Short URL for {self.original_url}"


class Visitor(models.Model):
    url = models.ForeignKey(
        URL, on_delete=models.CASCADE, related_name="visitors")
    city = models.CharField(max_length=85)
    country = models.CharField(max_length=56)
    region = models.CharField(max_length=85)
    timezone = models.CharField(max_length=255)
    currency = models.CharField(max_length=3)
    latitude = models.FloatField()
    longitude = models.FloatField()
    date_visited = models.DateTimeField(auto_now_add=True)

    @staticmethod
    def collect_ip_data(ip_address) -> dict:
        response = requests.get(f'https://ipapi.co/{ip_address}/json/').json()
        return {
            "city": response.get("city"),
            "region": response.get("region"),
            "country": response.get("country_name"),
            "timezone": response.get("timezone"),
            "currency": response.get("currency"),
            "latitude": response.get("latitude"),
            "longitude": response.get("longitude"),
        }

    def __str__(self) -> str:
        return f"Visitor of {self.url} ({self.date_visited})"
