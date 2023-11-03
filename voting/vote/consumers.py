import json
from asgiref.sync import async_to_sync
from channels.generic.websocket import WebsocketConsumer, AsyncWebsocketConsumer

GROUP_NAME = 'all'


class MyConsumer(WebsocketConsumer):
    def connect(self):
        async_to_sync(self.channel_layer.group_add)(
            GROUP_NAME, self.channel_name
        )
        self.accept()

    def disconnect(self, close_code):
        print('Close Websocket with code: ', close_code)
        async_to_sync(self.channel_layer.group_discard)(
            GROUP_NAME, self.channel_name
        )
        self.close()

    # Receive message from WebSocket
    def receive(self, text_data):
        pass
        # Send message to room group

    def test(self, event):
        message = event["message"]
        self.send(text_data=json.dumps({"message": message}))


class MyAsyncConsumer(AsyncWebsocketConsumer):



    async def connect(self):
        await self.channel_layer.group_add(
            GROUP_NAME, self.channel_name
        )
        await self.accept()

    async def disconnect(self, close_code):
        print('Close Websocket with code: ', close_code)
        await self.channel_layer.group_discard(
            GROUP_NAME, self.channel_name
        )
        # await self.close()

    # Receive message from WebSocket
    async def receive(self, text_data):
        pass
        # Send message to room group

    async def test(self, event):
        message = event["message"]
        await self.send(text_data=json.dumps(message))
