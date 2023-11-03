from django.core.management.base import BaseCommand, CommandError
import os
from django.conf import settings
from django.contrib.auth import get_user_model
from sesame.utils import get_query_string
import channels.layers
from asgiref.sync import async_to_sync
from random import randint
from time import sleep
import json

TEST_URL = "http://192.168.101.148:8000/"


class RegistrationProccess(object):
    def __init__(self, isRunning=True, totalCount=0):
        self.isRunning = isRunning
        self.totalCount = totalCount


class VotingProcess(object):
    def __init__(self, isRunning=True, totalCount=0):
        self.isRunning = isRunning
        self.totalCount = totalCount


class Message(object):
    def __init__(self, registrationProccess=None, votingProcess=None):
        self.registrationProccess = registrationProccess
        self.votingProcess = votingProcess


class Command(BaseCommand):
    help = " Тестирование отправки сообщение клиентам по Websocket"

    def handle(self, *args, **options):
        regProc = RegistrationProccess()
        votProc = VotingProcess()
        message = Message(regProc, votProc)
        channel_layer = channels.layers.get_channel_layer()
        for i in range(11):
            sleep(randint(0, 3))
            if i == 10:
                # message.registrationProccess.isRunning = False
                regProc.isRunning = False
            message.registrationProccess.totalCount = i
            #print(json.dumps(votProc.__dict__))
            async_to_sync(channel_layer.group_send)('all', {'type': 'test',
                                                            'message': {'regProc': regProc.__dict__}})
