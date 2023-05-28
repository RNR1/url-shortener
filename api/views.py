from django.http.response import HttpResponseRedirect
from django.db import models
from django.shortcuts import get_object_or_404
from rest_framework import viewsets, mixins, decorators, request, response, status
from drf_yasg.utils import swagger_auto_schema
from api.filters import URLStatsFilter
from api.models import URL, Visitor
from api.serializers import URLSerializer, URLStatsFilterSerializer, URLStatsSerializer, VisitorSerializer


class URLViewsets(mixins.RetrieveModelMixin, viewsets.GenericViewSet):
    queryset = URL.objects.all()
    serializer_class = URLSerializer
    lookup_field = 'hash'

    def get_object(self):
        queryset = self.get_queryset()

        # Perform the lookup filtering.
        lookup_url_kwarg = self.lookup_url_kwarg or self.lookup_field

        assert lookup_url_kwarg in self.kwargs, (
            'Expected view %s to be called with a URL keyword argument '
            'named "%s". Fix your URL conf, or set the `.lookup_field` '
            'attribute on the view correctly.' %
            (self.__class__.__name__, lookup_url_kwarg)
        )

        filter_kwargs = {self.lookup_field: self.kwargs[lookup_url_kwarg]}
        obj = get_object_or_404(queryset, **filter_kwargs)

        # May raise a permission denied
        self.check_object_permissions(self.request, obj)

        return obj

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

    @swagger_auto_schema(query_serializer=URLStatsFilterSerializer)
    @decorators.action(methods=['get'], detail=True, serializer_class=URLStatsSerializer, filter_backends=(URLStatsFilter,))
    def stats(self, request: request.Request, hash=None):
        instance: URL = self.get_object()

        visitors = self.filter_queryset(instance.visitors.all())
        data = visitors.aggregate(
            unique_visitors=models.Count('ip_address', distinct=True),
            unique_cities=models.Count('city', distinct=True),
            unique_countries=models.Count('country', distinct=True),
            unique_regions=models.Count('region', distinct=True),
            most_recent_visit=models.Max('date_visited'),
        )

        serializer = self.get_serializer(data)
        return response.Response(serializer.data)
