from celery import shared_task

from api.serializers import VisitorSerializer


@shared_task
def collect_visitor_data(ip_address, hash):
    serializer = VisitorSerializer(
        data={'ip_address': ip_address, 'url': hash})
    serializer.is_valid(raise_exception=True)

    serializer.create(serializer.validated_data)
