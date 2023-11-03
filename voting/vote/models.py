from django.db import models
from users.models import MyUser


class Answer(models.Model):
    """Вариант ответа"""
    listPosition = models.IntegerField(default=1, verbose_name='Позиция в списке')
    name = models.CharField(blank=False, max_length=100, verbose_name='Вариант ответа')

    class Meta:
        ordering = ('listPosition',)

    def __str__(self):
        return '%s - %s' % (self.listPosition, self.name)


class RegistrationBallot(models.Model):
    """Бюллетень для регистрации"""
    participant = models.ForeignKey(MyUser, verbose_name='Пользователь', on_delete=models.DO_NOTHING)
    isRegistered = models.BooleanField(default=False, verbose_name='Признак того что пользователь зарегистрирован')

    def __str__(self):
        return '%s Зарегистрирован - %s' % (self.participant, self.isRegistered)


class VoteBallot(models.Model):
    """Бюллетень для голосования"""
    participant = models.ForeignKey(MyUser, verbose_name='Пользователь', on_delete=models.DO_NOTHING)
    # question = models.CharField(blank=False, max_length=255, verbose_name='Вопрос на голосование')
    answer = models.ForeignKey(Answer, blank=True, null=True,
                               verbose_name='Выбранный ответ', on_delete=models.DO_NOTHING)


    def __str__(self):
        return '%s - %s' % (self.participant, self.answer)


class RegistrationProcess(models.Model):
    """Процесс регистрации"""
    start_date = models.DateTimeField(auto_now=False, auto_now_add=False, blank=True, null=True, verbose_name='Дата начала')
    end_date = models.DateTimeField(auto_now=False, auto_now_add=False, blank=True, null=True,
                                    verbose_name='Дата окончания')
    registrationBallot = models.ManyToManyField(RegistrationBallot, blank=True,
                                                verbose_name='Выданные бюллетени')

    def __str__(self):
        return '%s - %s' % (self.start_date, self.end_date)


class VotingProcess(models.Model):
    """Процесс голосования"""
    start_date = models.DateTimeField(auto_now=False, auto_now_add=False, blank=True, null=True, verbose_name='Дата начала')
    end_date = models.DateTimeField(auto_now=False, auto_now_add=False, blank=True, null=True,
                                    verbose_name='Дата окончания')
    question = models.CharField(blank=False, max_length=255, verbose_name='Вопрос на голосование')
    answers = models.ManyToManyField(Answer, blank=True,
                                     verbose_name='Варианты ответов')
    voteBallot = models.ManyToManyField(VoteBallot, blank=True,
                                        verbose_name='Выданные бюллетени')

    def __str__(self):
        return '%s - %s %s ' % (self.start_date, self.end_date, self.question)


class Meeting(models.Model):
    """Мероприятие"""
    name = models.CharField(blank=False, max_length=255, verbose_name='Наименование')
    isRequiredRegistration = models.BooleanField(default=True,
                                                 verbose_name='Признак необходимости проведения регистрации')
    registrationProcess = models.ForeignKey(RegistrationProcess, null=True,
                                             verbose_name='Процесс регистрации пользователей',
                                             related_name='meetingRegistrationProcess',
                                             on_delete=models.DO_NOTHING)
    participant = models.ManyToManyField(MyUser, blank=True, verbose_name='Перечень пользователей')
    votingProcess = models.ManyToManyField(VotingProcess, blank=True,
                                            verbose_name='Процессы для проведения голосования по вопросу',
                                            related_name='meetingVotingProcess')

    def __str__(self):
        return '%s ' % self.name
