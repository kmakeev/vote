import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';

part 'models.g.dart';

final _dateFormater = DateFormat('yyyy-MM-ddTHH:mm:ss');

DateTime _fromJson(String date) => _dateFormater.parse(date);

DateTime? _fromJsonWithNull(String? date) {
  return date == null ? null : _dateFormater.parse(date);
}

String _toJson(DateTime date) => _dateFormater.format(date);

String? _toJsonWithNull(DateTime? date) {
  return date == null ? null : _dateFormater.format(date);
}

@JsonSerializable()
class UserInfo {
  /// Информация о пользователе системы ///

  final String? username;
  final String? first_name;
  final String? last_name;
  final String? sur_name;
  final bool is_active;
  final bool is_admin;
  final String email;

  UserInfo(
      {this.username,
      this.first_name,
      this.last_name,
      this.sur_name,
      required this.is_active,
      required this.is_admin,
      required this.email});

  Map<String, dynamic> toJson() => {
        "username": this.username,
        "first_name": this.first_name,
        "last_name": this.last_name,
        "sur_name": this.sur_name,
        "is_active": this.is_active,
        "is_admin": this.is_admin,
        "email": this.email
      };

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json["username"],
      first_name: json["first_name"],
      last_name: json["last_name"],
      sur_name: json["sur_name"],
      is_active: json["is_active"],
      is_admin: json["is_admin"],
      email: json["email"],
    );
  }
}

@JsonSerializable()
class UserShotrInfo {
  /// Информация о пользователе системы ///

  final bool is_admin;

  UserShotrInfo(
      {
      required this.is_admin,
});

  Map<String, dynamic> toJson() => {
        "is_admin": this.is_admin,
      };

  factory UserShotrInfo.fromJson(Map<String, dynamic> json) {
    return UserShotrInfo(
      is_admin: json["is_admin"],
    );
  }
}


@JsonSerializable()
class Answer {
  /// Ответ пользователя на вопрос по процессу голосования///

  final int? id;
  final int? listPosition;
  final String name;
  final int? total_result;

  Answer({
    this.id,
    required this.listPosition,
    required this.name,
    required this.total_result,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}

@JsonSerializable()
class RegistrationBallot {
  /// Бюллетень пользователя для регистрации///

  final int? id;
  final UserShotrInfo participant;
  final bool isRegistered;
  final String? csrf_token;

  RegistrationBallot({
    this.id,
    required this.participant,
    required this.isRegistered,
    required this.csrf_token,
  });

  factory RegistrationBallot.fromJson(Map<String, dynamic> json) =>
      _$RegistrationBallotFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationBallotToJson(this);
}

@JsonSerializable()
class VoteBallot {
  /// Бюллетень пользователя для голосования///

  final int? id;
  final UserShotrInfo? participant;
  final Answer? answer;
  final String? csrf_token;

  VoteBallot({
    this.id,
    required this.participant,
    this.answer,
    required this.csrf_token,
  });

  VoteBallot copyWith({
    int? id,
    UserShotrInfo? participant,
    Answer? answer,
    String? csrf_token,
  }) {
    return VoteBallot(
      id: id ?? this.id,
      participant: participant ?? this.participant,
      answer: answer ?? this.answer,
      csrf_token: csrf_token ?? this.csrf_token,
    );
  }

  factory VoteBallot.fromJson(Map<String, dynamic> json) =>
      _$VoteBallotFromJson(json);

  Map<String, dynamic> toJson() => _$VoteBallotToJson(this);
}

@JsonSerializable()
class RegistrationProcess {
  /// Процесс регистрации///

  final int? id;
  @JsonKey(fromJson: _fromJsonWithNull, toJson: _toJsonWithNull)
  final DateTime? start_date;
  @JsonKey(fromJson: _fromJsonWithNull, toJson: _toJsonWithNull)
  final DateTime? end_date;
  final List<RegistrationBallot> registrationBallot;
  final int total_count;
  final String? csrf_token;

  RegistrationProcess({
    this.id,
    required this.start_date,
    required this.end_date,
    required this.registrationBallot,
    required this.total_count,
    required this.csrf_token,
  });

  factory RegistrationProcess.fromJson(Map<String, dynamic> json) =>
      _$RegistrationProcessFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationProcessToJson(this);
}

@JsonSerializable()
class OnlyMyRegistrationProcess {
  /// Процесс регистрации только для владельца///

  final int? id;
  @JsonKey(fromJson: _fromJsonWithNull, toJson: _toJsonWithNull)
  final DateTime? start_date;
  @JsonKey(fromJson: _fromJsonWithNull, toJson: _toJsonWithNull)
  final DateTime? end_date;
  final RegistrationBallot registrationBallot;
  final int total_count;


  OnlyMyRegistrationProcess({
    this.id,
    required this.start_date,
    required this.end_date,
    required this.registrationBallot,
    required this.total_count,
  });

  factory OnlyMyRegistrationProcess.fromJson(Map<String, dynamic> json) =>
      _$OnlyMyRegistrationProcessFromJson(json);

  Map<String, dynamic> toJson() => _$OnlyMyRegistrationProcessToJson(this);
}

@JsonSerializable()
class VotingProcess {
  /// Процесс голосования///

  final int? id;
  @JsonKey(fromJson: _fromJsonWithNull, toJson: _toJsonWithNull)
  final DateTime? start_date;
  @JsonKey(fromJson: _fromJsonWithNull, toJson: _toJsonWithNull)
  final DateTime? end_date;
  final String question;
  final List<Answer> answers;
  final List<VoteBallot> voteBallot;
  final int total_count;
  final String? csrf_token;

  VotingProcess({
    this.id,
    required this.start_date,
    required this.end_date,
    required this.question,
    required this.answers,
    required this.voteBallot,
    required this.total_count,
    required this.csrf_token,
  });

  factory VotingProcess.fromJson(Map<String, dynamic> json) =>
      _$VotingProcessFromJson(json);

  Map<String, dynamic> toJson() => _$VotingProcessToJson(this);
}
@JsonSerializable()
class OnlyMyVotingProcess {
  /// Процесс голосования только для владельца///

  final int? id;
  @JsonKey(fromJson: _fromJsonWithNull, toJson: _toJsonWithNull)
  final DateTime? start_date;
  @JsonKey(fromJson: _fromJsonWithNull, toJson: _toJsonWithNull)
  final DateTime? end_date;
  final String question;
  final List<Answer> answers;
  final VoteBallot voteBallot;
  final int total_count;

  OnlyMyVotingProcess({
    this.id,
    required this.start_date,
    required this.end_date,
    required this.question,
    required this.answers,
    required this.voteBallot,
    required this.total_count,
  });

  OnlyMyVotingProcess copyWith({
    int? id,
    DateTime? start_date,
    DateTime? end_date,
    String? question,
    List<Answer>? answers,
    VoteBallot? voteBallot,
    int? total_count,
  }) {
    return OnlyMyVotingProcess(
      id: id ?? this.id,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      question: question ?? this.question,
      answers: answers ?? this.answers,
      voteBallot: voteBallot ?? this.voteBallot,
      total_count: total_count ?? this.total_count,
    );
  }

  factory OnlyMyVotingProcess.fromJson(Map<String, dynamic> json) =>
      _$OnlyMyVotingProcessFromJson(json);

  Map<String, dynamic> toJson() => _$OnlyMyVotingProcessToJson(this);
}

@JsonSerializable()
class Meeting {
  /// Процесс голосования///

  final int? id;
  final String name;
  final bool isRequiredRegistration;
  final RegistrationProcess registrationProcess;
  final List<UserShotrInfo> participant;
  final List<VotingProcess> votingProcess;

  Meeting({
    this.id,
    required this.name,
    required this.isRequiredRegistration,
    required this.registrationProcess,
    required this.participant,
    required this.votingProcess,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) =>
      _$MeetingFromJson(json);

  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}


@JsonSerializable()
class OnlyMyMeeting {
  /// Процесс голосования только для владельца///

  final int? id;
  final String name;
  final bool isRequiredRegistration;
  final OnlyMyRegistrationProcess registrationProcess;
  final UserShotrInfo participant;
  final List<OnlyMyVotingProcess> votingProcess;

  OnlyMyMeeting({
    this.id,
    required this.name,
    required this.isRequiredRegistration,
    required this.registrationProcess,
    required this.participant,
    required this.votingProcess,
  });

  factory OnlyMyMeeting.fromJson(Map<String, dynamic> json) =>
      _$OnlyMyMeetingFromJson(json);

  Map<String, dynamic> toJson() => _$OnlyMyMeetingToJson(this);
}

@JsonSerializable()
class RegProc {
  /// Сообщение о процессе регистрации в сокет-канал пользователя///

  final int totalCount;
  final bool isRunning;
  final bool isStopping;
  final int id_registered;

  RegProc({
    required this.totalCount,
    required this.isRunning,
    required this.isStopping,
    required this.id_registered,
  });

  factory RegProc.fromJson(Map<String, dynamic> json) =>
      _$RegProcFromJson(json);

  Map<String, dynamic> toJson() => _$RegProcToJson(this);
}

@JsonSerializable()
class VoteProc {
  /// Сообщение о процессе голосования в сокет-канал пользователя///

  final int totalCount;
  final bool isRunning;
  final bool isStopping;
  final int id_voting;

  VoteProc({
    required this.totalCount,
    required this.isRunning,
    required this.isStopping,
    required this.id_voting,
  });

  factory VoteProc.fromJson(Map<String, dynamic> json) =>
      _$VoteProcFromJson(json);

  Map<String, dynamic> toJson() => _$VoteProcToJson(this);
}


@JsonSerializable()
class Message {
  /// Сообщение в сокет-канал пользователя///

  final RegProc? regProc;
  final VoteProc? voteProc;

  Message({
    this.regProc,
    this.voteProc,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

class Difference {
  /// Подсчет прошедшего времени с начала события///

  final DateTime value;
  final bool isStarted;

  Difference({
    required this.value,
    required this.isStarted,
  });

}
