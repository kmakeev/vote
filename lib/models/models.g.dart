// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      username: json['username'] as String?,
      first_name: json['first_name'] as String?,
      last_name: json['last_name'] as String?,
      sur_name: json['sur_name'] as String?,
      is_active: json['is_active'] as bool,
      is_admin: json['is_admin'] as bool,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'username': instance.username,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'sur_name': instance.sur_name,
      'is_active': instance.is_active,
      'is_admin': instance.is_admin,
      'email': instance.email,
    };

UserShotrInfo _$UserShotrInfoFromJson(Map<String, dynamic> json) =>
    UserShotrInfo(
      is_admin: json['is_admin'] as bool,
    );

Map<String, dynamic> _$UserShotrInfoToJson(UserShotrInfo instance) =>
    <String, dynamic>{
      'is_admin': instance.is_admin,
    };

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      id: json['id'] as int?,
      listPosition: json['listPosition'] as int?,
      name: json['name'] as String,
      total_result: json['total_result'] as int?,
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'id': instance.id,
      'listPosition': instance.listPosition,
      'name': instance.name,
      'total_result': instance.total_result,
    };

RegistrationBallot _$RegistrationBallotFromJson(Map<String, dynamic> json) =>
    RegistrationBallot(
      id: json['id'] as int?,
      participant:
          UserShotrInfo.fromJson(json['participant'] as Map<String, dynamic>),
      isRegistered: json['isRegistered'] as bool,
      csrf_token: json['csrf_token'] as String?,
    );

Map<String, dynamic> _$RegistrationBallotToJson(RegistrationBallot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participant': instance.participant,
      'isRegistered': instance.isRegistered,
      'csrf_token': instance.csrf_token,
    };

VoteBallot _$VoteBallotFromJson(Map<String, dynamic> json) => VoteBallot(
      id: json['id'] as int?,
      participant: json['participant'] == null
          ? null
          : UserShotrInfo.fromJson(json['participant'] as Map<String, dynamic>),
      answer: json['answer'] == null
          ? null
          : Answer.fromJson(json['answer'] as Map<String, dynamic>),
      csrf_token: json['csrf_token'] as String?,
    );

Map<String, dynamic> _$VoteBallotToJson(VoteBallot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participant': instance.participant,
      'answer': instance.answer,
      'csrf_token': instance.csrf_token,
    };

RegistrationProcess _$RegistrationProcessFromJson(Map<String, dynamic> json) =>
    RegistrationProcess(
      id: json['id'] as int?,
      start_date: _fromJsonWithNull(json['start_date'] as String?),
      end_date: _fromJsonWithNull(json['end_date'] as String?),
      registrationBallot: (json['registrationBallot'] as List<dynamic>)
          .map((e) => RegistrationBallot.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_count: json['total_count'] as int,
      csrf_token: json['csrf_token'] as String?,
    );

Map<String, dynamic> _$RegistrationProcessToJson(
        RegistrationProcess instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_date': _toJsonWithNull(instance.start_date),
      'end_date': _toJsonWithNull(instance.end_date),
      'registrationBallot': instance.registrationBallot,
      'total_count': instance.total_count,
      'csrf_token': instance.csrf_token,
    };

OnlyMyRegistrationProcess _$OnlyMyRegistrationProcessFromJson(
        Map<String, dynamic> json) =>
    OnlyMyRegistrationProcess(
      id: json['id'] as int?,
      start_date: _fromJsonWithNull(json['start_date'] as String?),
      end_date: _fromJsonWithNull(json['end_date'] as String?),
      registrationBallot: RegistrationBallot.fromJson(
          json['registrationBallot'] as Map<String, dynamic>),
      total_count: json['total_count'] as int,
    );

Map<String, dynamic> _$OnlyMyRegistrationProcessToJson(
        OnlyMyRegistrationProcess instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_date': _toJsonWithNull(instance.start_date),
      'end_date': _toJsonWithNull(instance.end_date),
      'registrationBallot': instance.registrationBallot,
      'total_count': instance.total_count,
    };

VotingProcess _$VotingProcessFromJson(Map<String, dynamic> json) =>
    VotingProcess(
      id: json['id'] as int?,
      start_date: _fromJsonWithNull(json['start_date'] as String?),
      end_date: _fromJsonWithNull(json['end_date'] as String?),
      question: json['question'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      voteBallot: (json['voteBallot'] as List<dynamic>)
          .map((e) => VoteBallot.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_count: json['total_count'] as int,
      csrf_token: json['csrf_token'] as String?,
    );

Map<String, dynamic> _$VotingProcessToJson(VotingProcess instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_date': _toJsonWithNull(instance.start_date),
      'end_date': _toJsonWithNull(instance.end_date),
      'question': instance.question,
      'answers': instance.answers,
      'voteBallot': instance.voteBallot,
      'total_count': instance.total_count,
      'csrf_token': instance.csrf_token,
    };

OnlyMyVotingProcess _$OnlyMyVotingProcessFromJson(Map<String, dynamic> json) =>
    OnlyMyVotingProcess(
      id: json['id'] as int?,
      start_date: _fromJsonWithNull(json['start_date'] as String?),
      end_date: _fromJsonWithNull(json['end_date'] as String?),
      question: json['question'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      voteBallot:
          VoteBallot.fromJson(json['voteBallot'] as Map<String, dynamic>),
      total_count: json['total_count'] as int,
    );

Map<String, dynamic> _$OnlyMyVotingProcessToJson(
        OnlyMyVotingProcess instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_date': _toJsonWithNull(instance.start_date),
      'end_date': _toJsonWithNull(instance.end_date),
      'question': instance.question,
      'answers': instance.answers,
      'voteBallot': instance.voteBallot,
      'total_count': instance.total_count,
    };

Meeting _$MeetingFromJson(Map<String, dynamic> json) => Meeting(
      id: json['id'] as int?,
      name: json['name'] as String,
      isRequiredRegistration: json['isRequiredRegistration'] as bool,
      registrationProcess: RegistrationProcess.fromJson(
          json['registrationProcess'] as Map<String, dynamic>),
      participant: (json['participant'] as List<dynamic>)
          .map((e) => UserShotrInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      votingProcess: (json['votingProcess'] as List<dynamic>)
          .map((e) => VotingProcess.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isRequiredRegistration': instance.isRequiredRegistration,
      'registrationProcess': instance.registrationProcess,
      'participant': instance.participant,
      'votingProcess': instance.votingProcess,
    };

OnlyMyMeeting _$OnlyMyMeetingFromJson(Map<String, dynamic> json) =>
    OnlyMyMeeting(
      id: json['id'] as int?,
      name: json['name'] as String,
      isRequiredRegistration: json['isRequiredRegistration'] as bool,
      registrationProcess: OnlyMyRegistrationProcess.fromJson(
          json['registrationProcess'] as Map<String, dynamic>),
      participant:
          UserShotrInfo.fromJson(json['participant'] as Map<String, dynamic>),
      votingProcess: (json['votingProcess'] as List<dynamic>)
          .map((e) => OnlyMyVotingProcess.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OnlyMyMeetingToJson(OnlyMyMeeting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isRequiredRegistration': instance.isRequiredRegistration,
      'registrationProcess': instance.registrationProcess,
      'participant': instance.participant,
      'votingProcess': instance.votingProcess,
    };

RegProc _$RegProcFromJson(Map<String, dynamic> json) => RegProc(
      totalCount: json['totalCount'] as int,
      isRunning: json['isRunning'] as bool,
      isStopping: json['isStopping'] as bool,
      id_registered: json['id_registered'] as int,
    );

Map<String, dynamic> _$RegProcToJson(RegProc instance) => <String, dynamic>{
      'totalCount': instance.totalCount,
      'isRunning': instance.isRunning,
      'isStopping': instance.isStopping,
      'id_registered': instance.id_registered,
    };

VoteProc _$VoteProcFromJson(Map<String, dynamic> json) => VoteProc(
      totalCount: json['totalCount'] as int,
      isRunning: json['isRunning'] as bool,
      isStopping: json['isStopping'] as bool,
      id_voting: json['id_voting'] as int,
    );

Map<String, dynamic> _$VoteProcToJson(VoteProc instance) => <String, dynamic>{
      'totalCount': instance.totalCount,
      'isRunning': instance.isRunning,
      'isStopping': instance.isStopping,
      'id_voting': instance.id_voting,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      regProc: json['regProc'] == null
          ? null
          : RegProc.fromJson(json['regProc'] as Map<String, dynamic>),
      voteProc: json['voteProc'] == null
          ? null
          : VoteProc.fromJson(json['voteProc'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'regProc': instance.regProc,
      'voteProc': instance.voteProc,
    };
