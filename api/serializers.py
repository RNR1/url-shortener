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
