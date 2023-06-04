from collections import OrderedDict
from datetime import datetime
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
    ip_address = serializers.IPAddressField()

    def validate(self, attrs: OrderedDict):
        ip_address = attrs.pop('ip_address')
        ip_data = Visitor.collect_ip_data(ip_address=ip_address)
        attrs.update(**ip_data)

        return attrs

    class Meta:
        model = Visitor
        fields = ('ip_address', 'url')


class URLStatsSerializer(serializers.Serializer):
    visitors = serializers.IntegerField()
    unique_cities = serializers.IntegerField()
    unique_countries = serializers.IntegerField()
    unique_regions = serializers.IntegerField()
    most_recent_visit = serializers.DateTimeField()


class URLStatsFilterSerializer(serializers.Serializer):
    start = serializers.DateTimeField(required=False)
    end = serializers.DateTimeField(required=False)

    def validate(self, attrs):
        start: datetime = attrs.get('start', None)
        end: datetime = attrs.get('end', None)
        if start or end:
            if start and not end:
                raise exceptions.ValidationError({
                    'end': ["This field is required when start is provided"]
                })
            if end and not start:
                raise exceptions.ValidationError({
                    'start': ["This field is required when end is provided"]
                })
            if start > end:
                raise exceptions.ValidationError({
                    'start': ["This field cannot be greater than end"],
                    'end': ["This field cannot be smaller than start"],
                })

        return attrs
