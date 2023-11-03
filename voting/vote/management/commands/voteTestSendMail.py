from django.core.management.base import BaseCommand, CommandError
import os
from django.conf import settings
from django.contrib.auth import get_user_model
from sesame.utils import get_query_string

TEST_URL = "http://192.168.101.154:8000/api/onlyformyregistrationprocess/3/"


class Command(BaseCommand):
    help = " Тестирование отправки ссылки для авторизации пользователем"

    def handle(self, *args, **options):
        User = get_user_model()
        # users = User.objects.all()
        #for u in users:
        #    print(u.email)
        user = User.objects.filter(email='makeev_k@mail.ru').first()
        print(TEST_URL + get_query_string(user))
