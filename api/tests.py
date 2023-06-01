from unittest.mock import patch
from django.test import TestCase, TransactionTestCase
from celery.contrib.testing.worker import start_worker
from UrlShortener.celery import app
from .tasks import collect_visitor_data
from api.models import URL


class TestCollectVisitorData(TestCase):
    @patch('api.tasks.VisitorSerializer')
    def test_success(self, visitor_data):
        ip_address = "73.213.82.132"
        url = URL.objects.create(original_url="https://www.example.com")
        collect_visitor_data(ip_address, url.hash)
        visitor_data.assert_called_with(
            data={'ip_address': ip_address, 'url': url.hash})
