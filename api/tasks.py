from celery import shared_task, Task

from api.serializers import VisitorSerializer


@shared_task
def collect_visitor_data(ip_address, hash):
    print(ip_address, hash)
    serializer = VisitorSerializer(
        data={'ip_address': ip_address, 'url': hash})
    if serializer.is_valid():
        serializer.create(serializer.validated_data)
    else:
        print(serializer.errors)
