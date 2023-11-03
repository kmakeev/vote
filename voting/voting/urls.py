from django.contrib import admin
from django.urls import path
from sesame.views import LoginView
from vote.views import hello, AnswerDetail, AnswerList, RegistrationBallotList, RegistrationBallotDetail, \
    VoteBallotList, VoteBallotDetail, RegistrationProcessList, RegistrationProcessDetail, VotingProcessList, \
    VotingProcessDetail, MeetingList, MeetingDetail, MeetingLastRecordDetail, OnlyForMyRegistrationProcessDetail, \
    MeetingLastAdminRecordDetail, AdminRegistrationProcessDetail, AdminVotingProcessDetail, OnlyForMyVotingProcessDetail

from users.views import MyUserView
import os
from django.views.static import serve
from django.views.decorators.csrf import csrf_exempt

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FLUTTER_WEB_APP = os.path.join(BASE_DIR, 'web')


def flutter_redirect(request, resource):
    return serve(request, resource, FLUTTER_WEB_APP)


urlpatterns = [
    path("admin/", admin.site.urls),
    path('api/user/', MyUserView.as_view(), name='user'),
    path('api/answer/', AnswerList.as_view()),
    path('api/answer/<int:pk>/', RegistrationBallotDetail.as_view()),
    path('api/registrationballot/', RegistrationBallotList.as_view()),
    path('api/registrationballot/<int:pk>/', RegistrationBallotDetail.as_view()),
    path('api/voteballot/', VoteBallotList.as_view()),
    path('api/voteballot/<int:pk>/', VoteBallotDetail.as_view()),
    path('api/registrationprocess/', RegistrationProcessList.as_view()),
    path('api/registrationprocess/<int:pk>/', RegistrationProcessDetail.as_view()),
    path('api/onlyformyregistrationprocess/<int:pk>/', OnlyForMyRegistrationProcessDetail.as_view()),
    path('api/onlyformyvotingprocess/<int:pk>/', OnlyForMyVotingProcessDetail.as_view()),
    path('api/adminregistrationprocess/<int:pk>/', AdminRegistrationProcessDetail.as_view()),
    path('api/adminvotingprocess/<int:pk>/', AdminVotingProcessDetail.as_view()),
    path('api/votingprocess/', VotingProcessList.as_view()),
    path('api/votingprocess/<int:pk>/', VotingProcessDetail.as_view()),
    path('api/meeting/', MeetingList.as_view()),
    path('api/meeting/<int:pk>/', MeetingDetail.as_view()),
    path('api/lastmeeting/', MeetingLastRecordDetail.as_view({'get': 'retrieve'})),
    path('api/lastadminmeeting/', MeetingLastAdminRecordDetail.as_view({'get': 'retrieve'})),
    # path("sesame/login/", LoginView.as_view(), name="sesame-login"),
    path("hello/", hello, name="hello"),
    path('', lambda r: flutter_redirect(r, 'index.html')),
    path('<path:resource>', flutter_redirect),
]
