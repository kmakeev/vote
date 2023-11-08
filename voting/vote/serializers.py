from rest_framework import serializers
from vote.models import Answer, RegistrationBallot, VoteBallot, RegistrationProcess, VotingProcess, Meeting
from users.models import MyUser, MyUserSerializer, MyUserShortSerializer
from django.db.models import Q, Count
import channels.layers
from asgiref.sync import async_to_sync
from vote.myClasses import RegProc, VoteProc, Message
from django.views.decorators.csrf import get_token
from vote.tasks import send_register_info_task, send_vote_info_task


class AnswerSerializer(serializers.ModelSerializer):

    class Meta:
        model = Answer
        fields = ['id', 'listPosition', 'name', ]


class VoteBallotSerializer(serializers.ModelSerializer):
    participant = MyUserShortSerializer(read_only=True, many=False)
    # answer = serializers.SerializerMethodField()
    csrf_token = serializers.SerializerMethodField()
    answer = AnswerSerializer(read_only=True, many=False)

    def get_answer(self, obj):
        result = AnswerSerializer(obj.answer, read_only=True, many=False,).data
        return result

    def get_csrf_token(self, obj):
        if obj and hasattr(obj, 'csrf_token'):
            return obj.csrf_token
        else:
            return None

    def update(self, instance, validated_data):

        checkVoteProcess = VotingProcess.objects.get(voteBallot__id=instance.id)
        try:
            if checkVoteProcess:
                if checkVoteProcess.start_date is not None and checkVoteProcess.end_date is None:
                    checkVoteBallot = VoteBallot.objects.get(id=instance.id)
                    if checkVoteBallot and checkVoteBallot.answer_id == None:
                        json_answer = self.initial_data.get('answer')
                        if json_answer:
                            answer = Answer.objects.get(id=json_answer['id'])
                            if answer:
                                instance.answer = answer
                                instance.save()
                # total_count_filter = ~Q(voteBallot__answer=None)
                # process = VotingProcess.objects.filter(pk=pk).annotate(
                #    total_count=Count('voteBallot__answer', filter=total_count_filter)).first()
                new_total = VoteBallot.objects.filter(votingprocess__voteBallot=instance, answer__isnull=False)
                new_total_count = new_total.count()
                voteProc = VoteProc()
                channel_layer = channels.layers.get_channel_layer()
                voteProc.totalCount = new_total_count
                voteProc.id_voting = checkVoteProcess.id
                voteProc.id_ballot = instance.id
                async_to_sync(channel_layer.group_send)('all', {'type': 'test',
                                                                'message': {'voteProc': voteProc.__dict__}})
        except Exception as e:
            print(e)
            return instance
        return instance

    class Meta:
        model = VoteBallot
        fields = ['id', 'participant', 'answer', 'csrf_token']


class RegistrationBallotSerializer(serializers.ModelSerializer):
    participant = MyUserShortSerializer(read_only=True, many=False)
    csrf_token = serializers.SerializerMethodField()

    class Meta:
        model = RegistrationBallot
        fields = ['id', 'participant', 'isRegistered', 'csrf_token']

    def update(self, instance, validated_data):
        if instance.isRegistered != validated_data['isRegistered']:
            instance.isRegistered = validated_data['isRegistered']
            instance.save()
            new_total_count = RegistrationBallot.objects.filter(registrationprocess__registrationBallot=instance,
                                                                isRegistered=True).count()
            regProc = RegProc()
            channel_layer = channels.layers.get_channel_layer()
            regProc.totalCount = new_total_count
            regProc.id_registered = instance.id
            async_to_sync(channel_layer.group_send)('all', {'type': 'test',
                                                            'message': {'regProc': regProc.__dict__}})

        return instance

    def get_csrf_token(self, obj):
        if obj and hasattr(obj, 'csrf_token'):
            return obj.csrf_token
        else:
            return None


class VoteBallotBackSerializer(serializers.ModelSerializer):
    participant = MyUserShortSerializer(read_only=True, many=False)
    answer = AnswerSerializer(read_only=True, many=False)

    class Meta:
        model = RegistrationProcess
        fields = ['id', 'participant', 'answer']


class RegistrationProcessSerializer(serializers.ModelSerializer):
    registrationBallot = RegistrationBallotSerializer(read_only=False, many=True)
    total_count = serializers.SerializerMethodField()
    csrf_token = serializers.SerializerMethodField()

    def get_total_count(self, obj):
        if obj and hasattr(obj, 'total_count'):
            return obj.total_count
        else:
            return None

    class Meta:
        model = RegistrationProcess
        fields = ['id', 'start_date', 'end_date', 'registrationBallot', 'total_count', 'csrf_token', ]

    def get_csrf_token(self, obj):
        if obj and hasattr(obj, 'csrf_token'):
            return obj.csrf_token
        else:
            return None


class AdminRegistrationProcessSerializer(serializers.ModelSerializer):
    registrationBallot = RegistrationBallotSerializer(read_only=False, many=True)
    total_count = serializers.SerializerMethodField()
    csrf_token = serializers.SerializerMethodField()

    def get_total_count(self, obj):
        if obj and hasattr(obj, 'total_count'):
            return obj.total_count
        else:
            return None

    def get_csrf_token(self, obj):
        if obj and hasattr(obj, 'csrf_token'):
            return obj.csrf_token
        else:
            return None

    def update(self, instance, validated_data):
        # checkinstance = RegistrationProcess.objects.get(id=instance.id)
        checkMeeting = Meeting.objects.get(registrationProcess__id=instance.id)
        if instance.start_date is None and validated_data['start_date'] is not None:
            try:
                if checkMeeting:
                    instance.registrationBallot.clear()
                    for participant in checkMeeting.participant.all():
                        newRegisterBallot = RegistrationBallot.objects.create(participant=participant)
                        instance.registrationBallot.add(newRegisterBallot)
            except Exception as e:
                print(e)
                return instance
            instance.start_date = validated_data['start_date']
            instance.save()
            regProc = RegProc()
            channel_layer = channels.layers.get_channel_layer()
            regProc.isStopping = False
            regProc.totalCount = instance.total_count
            async_to_sync(channel_layer.group_send)('all', {'type': 'test',
                                                            'message': {'regProc': regProc.__dict__}})
            send_register_info_task.s({'registrrationprocess_id': instance.id})()

        if instance.end_date is None and validated_data['end_date'] is not None:
            instance.end_date = validated_data['end_date']
            instance.save()
            regProc = RegProc()
            channel_layer = channels.layers.get_channel_layer()
            regProc.isRunning = False
            async_to_sync(channel_layer.group_send)('all', {'type': 'test',
                                                            'message': {'regProc': regProc.__dict__}})
        return instance

    class Meta:
        model = RegistrationProcess
        fields = ['id', 'start_date', 'end_date', 'registrationBallot', 'total_count', 'csrf_token', ]


class OnlyForMyRegistrationProcessSerializer(serializers.ModelSerializer):
    # registrationBallot = RegistrationBallotSerializer(read_only=False, many=True)
    registrationBallot = serializers.SerializerMethodField()
    total_count = serializers.SerializerMethodField()
    csrf_token = serializers.SerializerMethodField()

    def get_total_count(self, obj):
        if obj and hasattr(obj, 'total_count'):
            return obj.total_count
        else:
            return None

    def get_csrf_token(self, obj):
        if obj and hasattr(obj, 'csrf_token'):
            return obj.csrf_token
        else:
            return None

    def get_registrationBallot(self, obj):
        request = self.context.get('request')
        if request and hasattr(request, 'user'):
            user = request.user
        else:
            return None
        registrationBallot = RegistrationBallot.objects.filter(registrationprocess__id=obj.id,
                                                               participant__id=user.id).first()
        csrf_token = get_token(request)
        if registrationBallot:
            registrationBallot.csrf_token = csrf_token
        json_registrationBallot = RegistrationBallotSerializer(registrationBallot, read_only=True, many=False,
                                                               context={'request': request}).data
        return json_registrationBallot

    class Meta:
        model = RegistrationProcess
        fields = ['id', 'start_date', 'end_date', 'registrationBallot', 'total_count', 'csrf_token', ]


class VotingProcessSerializer(serializers.ModelSerializer):
    answers = AnswerSerializer(read_only=False, many=True)
    voteBallot = VoteBallotSerializer(read_only=False, many=True)

    total_count = serializers.SerializerMethodField()
    csrf_token = serializers.SerializerMethodField()

    def get_total_count(self, obj):
        if obj and hasattr(obj, 'total_count'):
            return obj.total_count
        else:
            return None

    def get_csrf_token(self, obj):
        if obj and hasattr(obj, 'csrf_token'):
            return obj.csrf_token
        else:
            return None

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        if instance.start_date is not None and instance.end_date is not None:
            for i in range(len(representation['answers'])):
                count = Answer.objects.filter(voteballot__answer__id=representation['answers'][i]['id'],
                                              voteballot__votingprocess__id=instance.id).count()
                representation['answers'][i]['total_result'] = count
        return representation


    class Meta:
        model = VotingProcess
        fields = ['id', 'start_date', 'end_date', 'question', 'answers', 'voteBallot', 'total_count', 'csrf_token', ]


class AdminVotingProcessSerializer(serializers.ModelSerializer):
    answers = AnswerSerializer(read_only=False, many=True)
    voteBallot = VoteBallotSerializer(read_only=False, many=True)

    total_count = serializers.SerializerMethodField()
    csrf_token = serializers.SerializerMethodField()

    def get_total_count(self, obj):
        if obj and hasattr(obj, 'total_count'):
            return obj.total_count
        else:
            return None

    def get_csrf_token(self, obj):
        if obj and hasattr(obj, 'csrf_token'):
            return obj.csrf_token
        else:
            return None

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        if instance.start_date is not None and instance.end_date is not None:
            for i in range(len(representation['answers'])):
                count = Answer.objects.filter(voteballot__answer__id=representation['answers'][i]['id'],
                                              voteballot__votingprocess__id=instance.id).count()
                representation['answers'][i]['total_result'] = count
        return representation

    def update(self, instance, validated_data):
        # checkinstance = RegistrationProcess.objects.get(id=instance.id)
        checkMeeting = Meeting.objects.get(votingProcess__id=instance.id)
        if instance.start_date is None and validated_data['start_date'] is not None:
            try:
                if checkMeeting:
                    instance.voteBallot.clear()
                    for participant in checkMeeting.participant.all():
                        newVoteBallot = VoteBallot.objects.create(participant=participant)
                        instance.voteBallot.add(newVoteBallot)
            except Exception as e:
                print(e)
                return instance
            instance.start_date = validated_data['start_date']
            instance.save()
            voteProc = VoteProc()
            channel_layer = channels.layers.get_channel_layer()
            voteProc.isStopping = False
            voteProc.id_voting = instance.id
            # print(voteProc.__dict__)
            async_to_sync(channel_layer.group_send)('all', {'type': 'test',
                                                            'message': {'voteProc': voteProc.__dict__}})
            send_vote_info_task.s({'votingprocess_id': instance.id})()

        if instance.end_date is None and validated_data['end_date'] is not None:
            instance.end_date = validated_data['end_date']
            instance.save()
            voteProc = VoteProc()
            channel_layer = channels.layers.get_channel_layer()
            voteProc.isRunning = False
            voteProc.id_voting = instance.id
            # print(voteProc.__dict__)
            async_to_sync(channel_layer.group_send)('all', {'type': 'test',
                                                            'message': {'voteProc': voteProc.__dict__}})
        return instance

    class Meta:
        model = VotingProcess
        fields = ['id', 'start_date', 'end_date', 'question', 'answers', 'voteBallot', 'total_count', 'csrf_token', ]


class OnlyForMyVotingProcessSerializer(serializers.ModelSerializer):
    answers = AnswerSerializer(read_only=False, many=True)
    voteBallot = serializers.SerializerMethodField()
    total_count = serializers.SerializerMethodField()
    csrf_token = serializers.SerializerMethodField()

    def get_total_count(self, obj):
        if obj and hasattr(obj, 'total_count'):
            return obj.total_count
        else:
            return None

    def get_csrf_token(self, obj):
        if obj and hasattr(obj, 'csrf_token'):
            return obj.csrf_token
        else:
            return None

    def get_voteBallot(self, obj):
        request = self.context.get('request')
        if request and hasattr(request, 'user'):
            user = request.user
        else:
            return None

        voteBallot = VoteBallot.objects.filter(votingprocess__id=obj.id, participant__id=user.id).first()
        csrf_token = get_token(request)
        if voteBallot:
            voteBallot.csrf_token = csrf_token
        json_voteBallot = VoteBallotSerializer(voteBallot, read_only=True, many=False,
                                               context={'request': request}).data
        return json_voteBallot

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        if instance.start_date is not None and instance.end_date is not None:
            for i in range(len(representation['answers'])):
                count = Answer.objects.filter(voteballot__answer__id=representation['answers'][i]['id'],
                                              voteballot__votingprocess__id=instance.id).count()
                representation['answers'][i]['total_result'] = count
        return representation

    class Meta:
        model = VotingProcess
        fields = ['id', 'start_date', 'end_date', 'question', 'answers', 'voteBallot', 'total_count', 'csrf_token', ]


class MeetingSerializer(serializers.ModelSerializer):
    registrationProcess = RegistrationProcessSerializer(read_only=False, many=False)
    participant = MyUserShortSerializer(read_only=False, many=True)
    votingProcess = VotingProcessSerializer(read_only=False, many=True)

    class Meta:
        model = Meeting
        fields = ['id', 'name', 'participant', 'isRequiredRegistration', 'registrationProcess', 'votingProcess', ]


class OnlyForMyMeetingSerializer(serializers.ModelSerializer):
    registrationProcess = serializers.SerializerMethodField()
    participant = serializers.SerializerMethodField()
    # votingProcess = VotingProcessSerializer(read_only=False, many=True)

    votingProcess = serializers.SerializerMethodField()

    def get_participant(self, obj):
        request = self.context.get('request')
        if request and hasattr(request, 'user'):
            user = request.user
        else:
            return None
        json_participant = MyUserShortSerializer(user, read_only=True, many=False).data
        return json_participant

    def get_votingProcess(self, obj):
        request = self.context.get('request')

        total_count_filter = ~Q(voteBallot__answer=None)

        # registrationProcess = RegistrationProcess.objects.filter(registrationBallot__participant__id=user.id).first()
        votingProcesses = VotingProcess.objects.filter(meetingVotingProcess__id=obj.id).order_by('id').annotate(
            total_count=Count('voteBallot__answer', filter=total_count_filter))

        json_votingProcess = OnlyForMyVotingProcessSerializer(votingProcesses, read_only=True, many=True,
                                                              context={'request': request}).data
        return json_votingProcess

    def get_registrationProcess(self, obj):
        request = self.context.get('request')
        total_count_filter = Q(registrationBallot__isRegistered=True)

        # registrationProcess = RegistrationProcess.objects.filter(registrationBallot__participant__id=user.id).first()
        registrationProcess = RegistrationProcess.objects.filter(id=obj.registrationProcess.id).annotate(
            total_count=Count('registrationBallot__isRegistered', filter=total_count_filter)).first()

        json_registrationProcess = OnlyForMyRegistrationProcessSerializer(registrationProcess, read_only=True,
                                                                          many=False,
                                                                          context={'request': request}).data
        return json_registrationProcess

    class Meta:
        model = Meeting
        fields = ['id', 'name', 'participant', 'isRequiredRegistration', 'registrationProcess', 'votingProcess', ]


class AdminMeetingSerializer(serializers.ModelSerializer):
    registrationProcess = serializers.SerializerMethodField()
    participant = MyUserShortSerializer(read_only=True, many=True)
    # votingProcess = VotingProcessSerializer(read_only=True, many=True)

    votingProcess = serializers.SerializerMethodField()

    def get_votingProcess(self, obj):
        request = self.context.get('request')
        total_count_filter = ~Q(voteBallot__answer=None)

        # registrationProcess = RegistrationProcess.objects.filter(registrationBallot__participant__id=user.id).first()
        votingProcesses = VotingProcess.objects.filter(meetingVotingProcess__id=obj.id).order_by('id').annotate(
            total_count=Count('voteBallot__answer', filter=total_count_filter))

        csrf_token = get_token(request)
        for votingProcess in votingProcesses:
            votingProcess.csrf_token = csrf_token
        json_voteProcesses = VotingProcessSerializer(votingProcesses, read_only=True, many=True, ).data
        return json_voteProcesses

    def get_registrationProcess(self, obj):
        request = self.context.get('request')
        total_count_filter = Q(registrationBallot__isRegistered=True)

        # registrationProcess = RegistrationProcess.objects.filter(registrationBallot__participant__id=user.id).first()
        registrationProcess = RegistrationProcess.objects.filter(id=obj.registrationProcess.id).annotate(
            total_count=Count('registrationBallot__isRegistered', filter=total_count_filter)).first()

        csrf_token = get_token(request)
        registrationProcess.csrf_token = csrf_token
        json_registrationProcess = RegistrationProcessSerializer(registrationProcess, read_only=True, many=False, ).data
        return json_registrationProcess

    class Meta:
        model = Meeting
        fields = ['id', 'name', 'participant', 'isRequiredRegistration', 'registrationProcess', 'votingProcess', ]
