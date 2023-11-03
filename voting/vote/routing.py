# chat/routing.py
from django.urls import re_path, path

from . import consumers

websocket_urlpatterns = [
    path("ws/count/", consumers.MyAsyncConsumer.as_asgi()),
]