from django.http import HttpResponse
from rest_framework.authentication import SessionAuthentication
from sesame.decorators import authenticate
from sesame.utils import get_user
from django.core.exceptions import PermissionDenied
from django.contrib.auth.models import AnonymousUser
import datetime
from django.db.models import Q, Count
from rest_framework import status
from rest_framework.response import Response
from rest_framework import generics
from rest_framework.views import APIView
from rest_framework import permissions
from rest_framework.decorators import api_view, permission_classes
from vote.models import Answer, RegistrationBallot, VoteBallot, RegistrationProcess, VotingProcess, Meeting
from vote.serializers import AnswerSerializer, RegistrationBallotSerializer, VoteBallotSerializer, \
    RegistrationProcessSerializer, VotingProcessSerializer, MeetingSerializer, OnlyForMyMeetingSerializer, \
    OnlyForMyRegistrationProcessSerializer, AdminMeetingSerializer, AdminRegistrationProcessSerializer, \
    AdminVotingProcessSerializer, OnlyForMyVotingProcessSerializer

from rest_framework import viewsets
from users.models import MyUser
from django.conf import settings
from django.views.decorators.csrf import get_token, csrf_protect, csrf_exempt

DEBUG_IOS = settings.SETTINGS_DEBUG_IOS
ID_DEBUG = settings.DEBUG_IOS_ID_USER


# @authenticate(required=False, override=True)
def hello(request):
    user = request.user
    if user.is_anonymous:
        return HttpResponse(f"Hello {user}!")
    else:
        return HttpResponse(f"Hello {user.last_name} {user.first_name}!")


class AnswerList(generics.ListCreateAPIView):
    """Класс для операций просмотра списка / добавления записи объекта БД 'Ответ/Answer'"""

    queryset = Answer.objects.all()
    serializer_class = AnswerSerializer
    # permission_classes = (permissions.IsAuthenticated,)


class AnswerDetail(generics.RetrieveUpdateDestroyAPIView):
    """Класс для операций просмотра / обновления / удаления записи объекта БД 'Ответ/Answer'"""

    queryset = Answer.objects.all()
    serializer_class = AnswerSerializer
    # permission_classes = (permissions.IsAuthenticated,)


class RegistrationBallotList(generics.ListCreateAPIView):
    """Класс для операций просмотра списка / добавления записи объекта
    БД 'Бюллетень для регистрации/RegistrationBallot'"""

    queryset = RegistrationBallot.objects.all()
    serializer_class = RegistrationBallotSerializer
    # permission_classes = (permissions.IsAuthenticated,)


class RegistrationBallotDetail(generics.RetrieveUpdateDestroyAPIView):
    """Класс для операций просмотра / обновления / удаления записи объекта
    БД 'Бюллетень для регистрации/RegistrationBallot'"""

    queryset = RegistrationBallot.objects.all()
    serializer_class = RegistrationBallotSerializer
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        csrf_token = get_token(request)
        instance.csrf_token = csrf_token
        serializer = self.get_serializer(instance)
        return Response(serializer.data)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        csrf_token = get_token(request)
        instance.csrf_token = csrf_token
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)

        if getattr(instance, '_prefetched_objects_cache', None):
            # If 'prefetch_related' has been applied to a queryset, we need to
            # forcibly invalidate the prefetch cache on the instance.
            instance._prefetched_objects_cache = {}

        return Response(serializer.data)


class VoteBallotList(generics.ListCreateAPIView):
    """Класс для операций просмотра списка / добавления записи объекта
    БД 'Бюллетень для регистрации/RegistrationBallot'"""

    queryset = VoteBallot.objects.all()
    serializer_class = VoteBallotSerializer
    # authentication_classes = []
    permission_classes = (permissions.IsAuthenticated,)


class VoteBallotDetail(generics.RetrieveUpdateDestroyAPIView):
    """Класс для операций просмотра / обновления / удаления записи объекта
    БД 'Бюллетень для регистрации/RegistrationBallot'"""

    queryset = VoteBallot.objects.all()
    serializer_class = VoteBallotSerializer
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []


    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        csrf_token = get_token(request)
        instance.csrf_token = csrf_token
        serializer = self.get_serializer(instance)
        return Response(serializer.data)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        csrf_token = get_token(request)
        instance.csrf_token = csrf_token
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)

        if getattr(instance, '_prefetched_objects_cache', None):
            # If 'prefetch_related' has been applied to a queryset, we need to
            # forcibly invalidate the prefetch cache on the instance.
            instance._prefetched_objects_cache = {}

        return Response(serializer.data)

class RegistrationProcessList(generics.ListCreateAPIView):
    """Класс для операций просмотра списка / добавления записи объекта
    БД 'Процесс регистрации/RegistrationProcess'"""

    queryset = RegistrationProcess.objects.all()
    serializer_class = RegistrationProcessSerializer
    # permission_classes = (permissions.IsAuthenticated,)


class RegistrationProcessDetail(generics.RetrieveUpdateDestroyAPIView):
    """Класс для операций просмотра / обновления / удаления записи объекта
    БД 'Процесс регистрации/RegistrationProcess'"""

    queryset = RegistrationProcess.objects.all()
    serializer_class = RegistrationProcessSerializer
    # permission_classes = (permissions.IsAuthenticated,)


class OnlyForMyRegistrationProcessDetail(generics.RetrieveUpdateDestroyAPIView):
    """Класс для операций просмотра / обновления / удаления записи объекта
    БД 'Процесс регистрации/RegistrationProcess' Данные возвращаются только, содержащие сведения для request.user"""

    queryset = RegistrationProcess.objects.all()
    serializer_class = OnlyForMyRegistrationProcessSerializer
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []

    def retrieve(self, request, pk=None):
        if request and hasattr(request, 'user'):
            user = request.user
        if DEBUG_IOS:
            user = MyUser.objects.get(id=ID_DEBUG)
        if user.is_anonymous:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            user = MyUser.objects.get(id=user.id)
            total_count_filter = Q(registrationBallot__isRegistered=True)
            process = RegistrationProcess.objects.filter(pk=pk).annotate(
                total_count=Count('registrationBallot__isRegistered', filter=total_count_filter)).first()

            if process is None:
                return Response(status=status.HTTP_400_BAD_REQUEST)
            csrf_token = get_token(request)
            process.csrf_token = csrf_token
            request.user = user
            serializer = OnlyForMyRegistrationProcessSerializer(process, many=False, context={'request': request})
            return Response(serializer.data)

    """
    @permission_classes((permissions.IsAuthenticated,))
    def put(self, request, pk=None, *args, **kwargs):
        if DEBUG_IOS:
            user = MyUser.objects.get(id=1)
        else:
            user = MyUser.objects.get(id=request.user.id)
        if user.is_anonymous:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            total_count_filter = Q(registrationBallot__isRegistered=True)
            process = RegistrationProcess.objects.filter(pk=pk).annotate(
                total_count=Count('registrationBallot__isRegistered', filter=total_count_filter)).first()
            if process is None:
                return Response(status=status.HTTP_400_BAD_REQUEST)
            request.user = user
            # serializer = OnlyForMyRegistrationProcessSerializer(process, data=request.data, many=False, context={'request': request})

            # partial = kwargs.pop('partial', False)
            # instance = self.get_object()
            serializer = self.get_serializer(process, data=request.data, many=False, context={'request': request})
            serializer.is_valid(raise_exception=True)
            self.perform_update(serializer)
            # if not serializer.is_valid():
            #    return Response(status=status.HTTP_400_BAD_REQUEST)
            # serializer.save()
            return Response(serializer.data)
"""


class AdminRegistrationProcessDetail(generics.RetrieveUpdateDestroyAPIView):
    """Класс для взаимодействия с процессом регистрации со стороны администратора"""

    queryset = RegistrationProcess.objects.all()
    serializer_class = AdminRegistrationProcessSerializer
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []

    def retrieve(self, request, pk=None):
        if request and hasattr(request, 'user'):
            user = request.user
        if DEBUG_IOS:
            user = MyUser.objects.get(id=ID_DEBUG)
        if user.is_anonymous or not user.is_admin:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            total_count_filter = Q(registrationBallot__isRegistered=True)
            process = RegistrationProcess.objects.filter(pk=pk).annotate(
                total_count=Count('registrationBallot__isRegistered', filter=total_count_filter)).first()
            if process is None:
                return Response(status=status.HTTP_400_BAD_REQUEST)
            csrf_token = get_token(request)
            process.csrf_token = csrf_token
            request.user = user
            serializer = AdminRegistrationProcessSerializer(process, many=False, context={'request': request})
            return Response(serializer.data)

    def put(self, request, pk=None, *args, **kwargs):
        if request and hasattr(request, 'user'):
            user = request.user
        if DEBUG_IOS:
            user = MyUser.objects.get(id=ID_DEBUG)
        if user.is_anonymous or not user.is_admin:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            total_count_filter = Q(registrationBallot__isRegistered=True)
            process = RegistrationProcess.objects.filter(pk=pk).annotate(
                total_count=Count('registrationBallot__isRegistered', filter=total_count_filter)).first()
            if process is None:
                return Response(status=status.HTTP_400_BAD_REQUEST)
            csrf_token = get_token(request)
            process.csrf_token = csrf_token
            request.user = user
            serializer = self.get_serializer(process, data=request.data, many=False, context={'request': request})
            serializer.is_valid(raise_exception=True)
            self.perform_update(serializer)
            return Response(serializer.data)


class AdminVotingProcessDetail(generics.RetrieveUpdateDestroyAPIView):
    """Класс для взаимодействия с процессом голосования со стороны администратора"""

    queryset = VotingProcess.objects.all()
    serializer_class = AdminVotingProcessSerializer
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []

    def retrieve(self, request, pk=None):
        if request and hasattr(request, 'user'):
            user = request.user
        if DEBUG_IOS:
            user = MyUser.objects.get(id=ID_DEBUG)
        if user.is_anonymous or not user.is_admin:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            total_count_filter = ~Q(voteBallot__answer=None)
            process = VotingProcess.objects.filter(pk=pk).annotate(
                total_count=Count('voteBallot__answer', filter=total_count_filter)).first()

            if process is None:
                return Response(status=status.HTTP_400_BAD_REQUEST)
            csrf_token = get_token(request)
            process.csrf_token = csrf_token
            request.user = user
            serializer = AdminVotingProcessSerializer(process, many=False, context={'request': request})
            return Response(serializer.data)

    def put(self, request, pk=None, *args, **kwargs):
        if request and hasattr(request, 'user'):
            user = request.user
        if DEBUG_IOS:
            user = MyUser.objects.get(id=ID_DEBUG)
        if user.is_anonymous or not user.is_admin:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            total_count_filter = ~Q(voteBallot__answer=None)
            process = VotingProcess.objects.filter(pk=pk).annotate(
                total_count=Count('voteBallot__answer', filter=total_count_filter)).first()
            if process is None:
                return Response(status=status.HTTP_400_BAD_REQUEST)
            csrf_token = get_token(request)
            process.csrf_token = csrf_token
            request.user = user
            serializer = self.get_serializer(process, data=request.data, many=False, context={'request': request})
            serializer.is_valid(raise_exception=True)
            self.perform_update(serializer)
            return Response(serializer.data)


class VotingProcessList(generics.ListCreateAPIView):
    """Класс для операций просмотра списка / добавления записи объекта
    БД 'Процесс голосования/VotingProcess'"""

    queryset = VotingProcess.objects.all()
    serializer_class = VotingProcessSerializer
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []


class VotingProcessDetail(generics.RetrieveUpdateDestroyAPIView):
    """Класс для операций просмотра / обновления / удаления записи объекта
    БД 'Процесс голосования/VotingProcess'"""

    queryset = VotingProcess.objects.all()
    serializer_class = VotingProcessSerializer
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []


class OnlyForMyVotingProcessDetail(generics.RetrieveUpdateDestroyAPIView):
    """Класс для операций просмотра / обновления / удаления записи объекта
    БД 'Процесс голосования/VotingProcess' Данные возвращаются только, содержащие сведения для request.user"""


    queryset = VotingProcess.objects.all()
    serializer_class = OnlyForMyVotingProcessSerializer
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []

    def retrieve(self, request, pk=None):
        if request and hasattr(request, 'user'):
            user = request.user
        if DEBUG_IOS:
            user = MyUser.objects.get(id=ID_DEBUG)
        if user.is_anonymous:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            user = MyUser.objects.get(id=user.id)
            total_count_filter = ~Q(voteBallot__answer=None)
            process = VotingProcess.objects.filter(pk=pk).annotate(
                total_count=Count('voteBallot__answer', filter=total_count_filter)).first()
            if process is None:
                return Response(status=status.HTTP_400_BAD_REQUEST)
            csrf_token = get_token(request)
            process.csrf_token = csrf_token
            request.user = user
            serializer = OnlyForMyVotingProcessSerializer(process, many=False, context={'request': request})
            return Response(serializer.data)



class MeetingList(generics.ListCreateAPIView):
    """Класс для операций просмотра списка / добавления записи объекта
    БД 'Мероприятие/Meeting'"""

    queryset = Meeting.objects.all()
    serializer_class = MeetingSerializer
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []


class MeetingDetail(generics.RetrieveUpdateDestroyAPIView):
    """Класс для операций просмотра / обновления / удаления записи объекта
    БД ''Мероприятие/Meeting'"""

    queryset = Meeting.objects.all()
    serializer_class = MeetingSerializer
    # authentication_classes = [SessionAuthentication, ]

    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []


class MeetingLastRecordDetail(viewsets.ViewSet):
    """Класс для операций просмотра Последней записи объекта
    БД ''Мероприятие/Meeting' Данные возвращаются только, содержащие сведения для request.user """
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []

    def retrieve(self, request):
        if request and hasattr(request, 'user'):
            user = request.user
        if DEBUG_IOS:
            user = MyUser.objects.get(id=ID_DEBUG)
        if user.is_anonymous:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            meeting = Meeting.objects.all().filter(participant__email=user.email).order_by('-id',).first()
            request.user = user
            serializer = OnlyForMyMeetingSerializer(meeting, many=False, context={'request': request})
            response = Response(serializer.data)
            response.set_cookie(get_token(request))
            return response


class MeetingLastAdminRecordDetail(viewsets.ViewSet):
    """Класс для операций просмотра Последней записи объекта
    БД ''Мероприятие/Meeting' Данные возвращаются только, содержащие сведения для request.user с правами администратора """
    if not DEBUG_IOS:
        authentication_classes = [SessionAuthentication, ]
        permission_classes = (permissions.IsAuthenticated,)
    else:
        authentication_classes = []

    def retrieve(self, request):
        if request and hasattr(request, 'user'):
            user = request.user
        if DEBUG_IOS:
            user = MyUser.objects.get(id=ID_DEBUG)
        if user.is_anonymous or not user.is_admin:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        else:
            meeting = Meeting.objects.all().order_by('-id').first()
            request.user = user
            serializer = AdminMeetingSerializer(meeting, many=False, context={'request': request})
            return Response(serializer.data)
