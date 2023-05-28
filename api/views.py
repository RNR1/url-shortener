from django.http.response import HttpResponseRedirect
from rest_framework import viewsets, mixins, decorators, request, response, status
from drf_yasg.utils import swagger_auto_schema
from api.models import URL, Visitor
from api.serializers import URLSerializer, VisitorSerializer


class URLViewsets(mixins.RetrieveModelMixin, viewsets.GenericViewSet):
    queryset = URL.objects.all()
    serializer_class = URLSerializer
    lookup_field = 'hash'

    @swagger_auto_schema(responses={status.HTTP_201_CREATED: 'Generated short URL'})
    @decorators.action(methods=['post'], detail=False)
    def generate(self, request: request.Request):
        serializer: URLSerializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        instance: URL = serializer.save()

        return response.Response(instance.short_url(), status=status.HTTP_201_CREATED)

    def retrieve(self, request: request.Request, *args, **kwargs):
        instance: URL = self.get_object()

        ip_address = Visitor.get_ip()
        serializer = VisitorSerializer(data={'ip_address': ip_address})
        serializer.is_valid()

        instance.visitors.create(**serializer.validated_data)

        return HttpResponseRedirect(redirect_to=instance.original_url)
