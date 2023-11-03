import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/services/dataServices.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'dart:io';

abstract class UserMeetingEvent {}

class InitUserMeetingEvent extends UserMeetingEvent {}

class ReLoadUserMeetingEvent extends UserMeetingEvent {}

class UserMeetingState {
  final OnlyMyMeeting? meeting;
  final State requestStatus;

  UserMeetingState({
    this.meeting,
    this.requestStatus = const InitState(),
  });

  UserMeetingState copyWith({
    OnlyMyMeeting? meeting,
    State? requestStatus,
  }) {
    return UserMeetingState(
      meeting: meeting ?? this.meeting,
      requestStatus: requestStatus ?? this.requestStatus,
    );
  }
}

class UserMeetingBloc
    extends Bloc<UserMeetingEvent, UserMeetingState> {
  final DataService _dataService;

  UserMeetingBloc(this._dataService)
      : assert(_dataService != null),
        super(UserMeetingState());

  @override
  Stream<UserMeetingState> mapEventToState(
      UserMeetingEvent event) async* {
    OnlyMyMeeting _meeting;
    if (event is InitUserMeetingEvent) {
      yield state.copyWith(requestStatus: LoadingState());
      try {
        _meeting = await _dataService.GetLastMeeting();
        yield state.copyWith(meeting: _meeting,
            requestStatus: LoadedState());
      } on SocketException catch (e) {
        yield state.copyWith(requestStatus: FailedState(e.toString()));
      } catch (e) {
        yield state.copyWith(requestStatus: FailedState(e.toString()));
      }
    }
  }

  void dispose() {}
}
