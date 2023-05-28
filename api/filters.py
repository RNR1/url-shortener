from rest_framework.filters import BaseFilterBackend

from api.serializers import URLStatsFilterSerializer


class URLStatsFilter(BaseFilterBackend):
    def filter_queryset(self, request, queryset, view):
        serializer = URLStatsFilterSerializer(data=request.query_params)
        serializer.is_valid(raise_exception=True)

        start = serializer.validated_data.get('start', None)
        end = serializer.validated_data.get('end', None)

        if start and end:
            queryset = queryset.filter(date_visited__range=[start, end])
        return queryset
