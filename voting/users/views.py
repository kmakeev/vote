from rest_framework.views import APIView
from users.models import MyUser
from users.models import MyUserSerializer
from rest_framework import permissions, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.conf import settings

DEBUG_IOS = settings.SETTINGS_DEBUG_IOS
ID_DEBUG = settings.DEBUG_IOS_ID_USER


class MyUserView(APIView):
    serializer_class = MyUserSerializer

    # @permission_classes((permissions.IsAuthenticated,))
    def get(self, request):
        if request and hasattr(request, 'user'):
            user = request.user
        if DEBUG_IOS:
            user = MyUser.objects.get(id=ID_DEBUG)
        if user.is_anonymous:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        serializer = MyUserSerializer(user, many=False)
        return Response(serializer.data)

