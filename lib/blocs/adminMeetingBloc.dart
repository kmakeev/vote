import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/services/dataServices.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'dart:io';

abstract class AdminMeetingEvent {}

class InitAdminMeetingEvent extends AdminMeetingEvent {}

class ReLoadAdminMeetingEvent extends AdminMeetingEvent {}

class AdminMeetingState {
  final Meeting? meeting;
  final State requestStatus;

  AdminMeetingState({
    this.meeting,
    this.requestStatus = const InitState(),
  });

  AdminMeetingState copyWith({
    Meeting? meeting,
    State? requestStatus,
  }) {
    return AdminMeetingState(
      meeting: meeting ?? this.meeting,
      requestStatus: requestStatus ?? this.requestStatus,
    );
  }
}

class AdminMeetingBloc
    extends Bloc<AdminMeetingEvent, AdminMeetingState> {
  final DataService _dataService;

  AdminMeetingBloc(this._dataService)
      : assert(_dataService != null),
        super(AdminMeetingState());

  @override
  Stream<AdminMeetingState> mapEventToState(
      AdminMeetingEvent event) async* {
    Meeting _meeting;
    if (event is InitAdminMeetingEvent) {
      yield state.copyWith(requestStatus: LoadingState());
      try {
        _meeting = await _dataService.GetAdminLastMeeting();
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
