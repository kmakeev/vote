from __future__ import absolute_import, unicode_literals
import os
from celery import Celery
import logging
from django.conf import settings

# set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'voting.settings')

app = Celery('voting')
app.config_from_object('django.conf:settings')
app.autodiscover_tasks()



#if __name__ == '__mail__':
#    app.start()

# celery -A fnsservice worker -l info -P eventlet
# -A fnsservice flower --port=5555 --brocker=redis://192.168.235.59:6379/0

# celery -A fnsservice worker -B -l info -P eventlet