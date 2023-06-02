from typing import Any, Optional
from django.contrib import admin
from django.http.request import HttpRequest
from django.utils.translation import gettext_lazy as _
from api.models import URL, Visitor


class ReadOnlyModelAdmin(admin.ModelAdmin):
    def has_add_permission(self, request: HttpRequest) -> bool:
        return False

    def has_change_permission(self, request: HttpRequest, obj: Any | None = ...) -> bool:
        return False

    def has_delete_permission(self, request: HttpRequest, obj: Any | None = ...) -> bool:
        return False


@admin.register(URL)
class URLAdmin(ReadOnlyModelAdmin):
    @admin.display(description=_("visitors"), ordering="visitors__count")
    def visitors(self, obj: URL):
        return obj.visitors.count()

    list_display = ('hash', 'original_url', 'visitors')


@admin.register(Visitor)
class VisitorAdmin(ReadOnlyModelAdmin):
    list_display = ('id', 'url', 'city', 'country',
                    'region', 'timezone', 'date_visited')
