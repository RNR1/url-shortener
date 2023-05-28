from collections import OrderedDict
import requests
from rest_framework import serializers, exceptions

from api.models import URL, Visitor


class URLSerializer(serializers.ModelSerializer):

    def create(self, validated_data):
        instance = None

        while True:
            retries = 0
            try:
                instance = URL.objects.create(**validated_data)
                break
            except:
                if retries > 10:
                    raise exceptions.APIException(
                        {'message': "could not create a short URL for the provided URL, please try again later"})
                retries += 1
                continue
        return instance

    class Meta:
        model = URL
        fields = ('original_url', 'hash')
        read_only_fields = ('hash',)


class VisitorSerializer(serializers.ModelSerializer):

    def validate(self, attrs: OrderedDict):
        ip_address = attrs.get('ip_address')
        response = requests.get(f'https://ipapi.co/{ip_address}/json/').json()
        attrs.update({
            "ip_address": ip_address,
            "city": response.get("city"),
            "region": response.get("region"),
            "country": response.get("country_name"),
            "timezone": response.get("timezone"),
            "currency": response.get("currency"),
            "latitude": response.get("latitude"),
            "longitude": response.get("longitude"),
        })

        return attrs

    class Meta:
        model = Visitor
        fields = ('ip_address',)
