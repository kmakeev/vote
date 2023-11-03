from django.contrib import admin
from vote.models import Answer, RegistrationBallot, VoteBallot, RegistrationProcess, VotingProcess, Meeting
from django.urls import include, path
from django.shortcuts import render
from django.contrib import messages
from django.http import HttpResponseRedirect
from django.urls import reverse
from django import forms
from users.models import MyUser

@admin.register(Answer)
class AnswerAdmin(admin.ModelAdmin):
    list_display = ['listPosition', 'name']


@admin.register(RegistrationBallot)
class RegistrationBallotAdmin(admin.ModelAdmin):
    list_display = ['participant', 'isRegistered']


@admin.register(VoteBallot)
class VoteBallotAdmin(admin.ModelAdmin):
    list_display = ['participant',  'answer', ]


@admin.register(RegistrationProcess)
class RegistrationProcessAdmin(admin.ModelAdmin):
    list_display = ['id', 'start_date', 'end_date', 'get_registrationBallot', ]

    def get_registrationBallot(self, obj):
        return "\n".join(
            [p.participant.email + ' Регистрация - ' + str(p.isRegistered) + '; ' for p in obj.registrationBallot.all()])


@admin.register(VotingProcess)
class VotingProcessAdmin(admin.ModelAdmin):
    list_display = ['id', 'start_date', 'end_date', 'question', 'get_answers', 'get_voteBallot', ]

    def get_answers(self, obj):
        return "\n".join([p.name + '; ' for p in obj.answers.all()])

    def get_voteBallot(self, obj):
        return "\n".join([p.__str__() + '; ' for p in obj.voteBallot.all()])


class CsvImportForm(forms.Form):
    csv_upload = forms.FileField()


@admin.register(Meeting)
class MeetingAdmin(admin.ModelAdmin):

    class Meta:
        model = Meeting
    list_display = ['name', 'isRequiredRegistration', 'registrationProcess', 'get_participant', 'get_votingProcess', ]

    # change_list_template = 'admin/vote/Meeting/change_form.html'

    def get_participant(self, obj):
        return "\n".join([p.email + '; ' for p in obj.participant.all()])

    def get_votingProcess(self, obj):
        return "\n".join([p.question + '; ' for p in obj.votingProcess.all()])

    def upload_csv(self, request, object_id=None):

        if request.method == "POST":
            csv_file = request.FILES["csv_upload"]

            if not csv_file.name.endswith('.csv'):
                messages.warning(request, 'Расширение загруженного файла на равно CSV')
                return HttpResponseRedirect(request.path_info)

            file_data = csv_file.read().decode("utf-8")
            csv_data = file_data.split("\n")
            object = object_id.partition('/')
            id = object[0]
            print(id)
            try:
                meeting = Meeting.objects.get(id=id)
            except Exception as ex:
                messages.warning(request, ex)
                return HttpResponseRedirect(request.path_info)
            users = []
            for x in csv_data:
                fields = x.split(",")
                if fields:
                    str = fields[0].split(';')
                    if len(str) >= 2:
                        fio = str[0].split(' ')
                        email = str[1]
                        print(fio, email)
                        new_user, isCreted = MyUser.objects.get_or_create(email=email)
                        if isCreted:
                            if len(fio) >= 3:
                                new_user.first_name = fio[0]
                                new_user.last_name = fio[1]
                                new_user.sur_name = fio[2]
                                new_user.save()
                        users.append(new_user)
            if users:
                meeting.participant.add(*users)
                meeting.save()
            url = reverse('admin:index')
            return HttpResponseRedirect(url)

        form = CsvImportForm()
        data = {"form": form}
        return render(request, "admin/csv_upload.html", data)

    def get_urls(self):
        urls = super().get_urls()
        new_urls = [path('<path:object_id>/upload-csv/', self.upload_csv)]
        return new_urls + urls
