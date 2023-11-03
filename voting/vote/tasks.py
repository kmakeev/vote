from __future__ import absolute_import, unicode_literals
from voting.celery import app
from django.conf import settings
from vote.models import Meeting, VotingProcess
from users.models import MyUser
from django.template.loader import render_to_string
from sesame.utils import get_query_string
from django.core.mail import get_connection, EmailMultiAlternatives


def send_mass_html_mail(datatuple, fail_silently=False, user=None, password=None,
                        connection=None):
    """
    Given a datatuple of (subject, text_content, html_content, from_email,
    recipient_list), sends each message to each recipient list. Returns the
    number of emails sent.

    If from_email is None, the DEFAULT_FROM_EMAIL setting is used.
    If auth_user and auth_password are set, they're used to log in.
    If auth_user is None, the EMAIL_HOST_USER setting is used.
    If auth_password is None, the EMAIL_HOST_PASSWORD setting is used.

    """

    connection = connection or get_connection(
        username=user, password=password, fail_silently=fail_silently)
    messages = []
    for subject, text, html, from_email, recipient in datatuple:
        message = EmailMultiAlternatives(subject, text, from_email, recipient)
        message.attach_alternative(html, 'text/html')
        messages.append(message)
    return connection.send_messages(messages)


@app.task(bind=True)
def send_register_info_task(self, params):
    if params and 'registrrationprocess_id' in params:
        registrationprocess = params['registrrationprocess_id']
        name = 'Пленум Верховного Суда Российской Федерации'
        meeting = Meeting.objects.filter(registrationProcess__id=registrationprocess).first()
        if meeting:
            name = meeting.name
        recipients = MyUser.objects.filter(registrationballot__registrationprocess=registrationprocess)
        messages = []
        for recipient in recipients:
            email = recipient.email
            fio = '%s %s' % (
                recipient.last_name, recipient.sur_name,)
            to = [email]
            from_email = settings.DEFAULT_FROM_EMAIL
            subject_ = 'Регистрация'
            url = settings.BASE_URL + get_query_string(recipient)
            html_content = render_to_string('email/new_registration.html',
                                            {'fio': fio,
                                             'url': url,
                                             'name': name})
            messages.append((subject_, None, html_content, from_email, to))

        try:
            send_mass_html_mail(messages)
        except Exception as e:
            print(e)
            return False
        return True
    else:
        return False


@app.task(bind=True)
def send_vote_info_task(self, params):
    if params and 'votingprocess_id' in params:
        votingprocess = params['votingprocess_id']
        name = 'Пленум Верховного Суда Российской Федерации'
        meeting = Meeting.objects.filter(votingProcess__id=votingprocess).first()
        vote = VotingProcess.objects.filter(id=votingprocess).first()
        if meeting:
            name = meeting.name
        recipients = MyUser.objects.filter(voteballot__votingprocess=votingprocess)
        messages = []
        if vote:
            for recipient in recipients:
                email = recipient.email
                fio = '%s %s' % (
                    recipient.last_name, recipient.sur_name,)
                to = [email]
                from_email = settings.DEFAULT_FROM_EMAIL
                question = vote.question
                subject_ = 'Голосование "%s"' % question
                answers = vote.answers.all()
                url = settings.BASE_URL + get_query_string(recipient)
                html_content = render_to_string('email/new_vote.html',
                                                {'fio': fio,
                                                 'url': url,
                                                 'question': question,
                                                 'answers': answers})
                messages.append((subject_, None, html_content, from_email, to))

            try:
                send_mass_html_mail(messages)
            except Exception as e:
                print(e)
                return False
            return True
        else:
            return False
    else:
        return False
