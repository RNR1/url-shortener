from rest_framework.routers import DefaultRouter
from api import views

router = DefaultRouter()
router.register('', views.URLViewsets, 'urls')

urlpatterns = [] + router.urls
