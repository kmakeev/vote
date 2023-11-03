import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/services/dataServices.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'dart:io';

abstract class RegistrationProcessAdminEvent {}

class StartDateChanged extends RegistrationProcessAdminEvent {
  final DateTime start_date;

  StartDateChanged({required this.start_date});
}

class EndDateChanged extends RegistrationProcessAdminEvent {
  final DateTime end_date;

  EndDateChanged({required this.end_date});
}

class WSMessageAdminChanged extends RegistrationProcessAdminEvent {
  final Message message;

  WSMessageAdminChanged({required this.message});
}

class StartMillisecondsChanged extends RegistrationProcessAdminEvent {
  final Difference msValue;

  StartMillisecondsChanged({required this.msValue});
}

class IsNeedFocusChanged extends RegistrationProcessAdminEvent {
  final bool newFocus;

  IsNeedFocusChanged({required this.newFocus});
}

class InitRegistrationProcessEvent extends RegistrationProcessAdminEvent {
  RegistrationProcess registrationProcess;
  bool isNeedFocus;

  InitRegistrationProcessEvent(
      {required this.registrationProcess, this.isNeedFocus = true});
}

class ReloadRegistrationProcessEvent extends RegistrationProcessAdminEvent {}

class CompleteRegistrationProcessEvent extends RegistrationProcessAdminEvent {}

class StartRegistrationProcessEvent extends RegistrationProcessAdminEvent {}

class RegistrationProcessState {
  final DateTime? start_date;
  final DateTime? end_date;
  final RegistrationProcess? registrationProcess;
  final State requestStatus;
  final FormSubmissionStatus formStatus;
  final Message? message;
  final Difference? msValue;
  final bool isNeedFocus;

  RegistrationProcessState({
    this.start_date,
    this.end_date,
    this.registrationProcess,
    this.requestStatus = const InitState(),
    this.formStatus = const InitialFormStatus(),
    this.message,
    this.msValue,
    this.isNeedFocus = true,
  });

  RegistrationProcessState copyWith({
    DateTime? start_date,
    DateTime? end_date,
    RegistrationProcess? registrationProcess,
    State? requestStatus,
    FormSubmissionStatus? formStatus,
    Message? message,
    Difference? msValue,
    bool? isNeedFocus,
  }) {
    return RegistrationProcessState(
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      registrationProcess: registrationProcess ?? this.registrationProcess,
      requestStatus: requestStatus ?? this.requestStatus,
      formStatus: formStatus ?? this.formStatus,
      message: message ?? this.message,
      msValue: msValue ?? this.msValue,
      isNeedFocus: isNeedFocus ?? this.isNeedFocus,
    );
  }
}

class RegistrationProcessAdminBloc
    extends Bloc<RegistrationProcessAdminEvent, RegistrationProcessState> {
  final DataService _dataService;

  RegistrationProcessAdminBloc(this._dataService)
      : assert(_dataService != null),
        super(RegistrationProcessState());

  @override
  Stream<RegistrationProcessState> mapEventToState(
      RegistrationProcessAdminEvent event) async* {
    RegistrationProcess _registrationProcess;
    if (event is StartDateChanged) {
      yield state.copyWith(
        start_date: event.start_date,
      );
    } else if (event is EndDateChanged) {
      yield state.copyWith(
        end_date: event.end_date,
      );
    } else if (event is WSMessageAdminChanged) {
      yield state.copyWith(
        message: event.message,
      );
    } else if (event is StartMillisecondsChanged) {
      yield state.copyWith(msValue: event.msValue);
    } else if (event is IsNeedFocusChanged) {
      yield state.copyWith(isNeedFocus: event.newFocus);
    } else if (event is InitRegistrationProcessEvent) {
      yield state.copyWith(
        start_date: event.registrationProcess.start_date,
        end_date: event.registrationProcess.end_date,
        registrationProcess: event.registrationProcess,
        requestStatus: LoadedState(),
        //Первая инициализация из события, После этого статуса отображаем в виджете
        formStatus: InitialFormStatus(),
        message: Message(
            regProc: RegProc(
                totalCount: 0,
                isRunning: true,
                isStopping: true,
                id_registered: 0)),
        msValue: null,
        isNeedFocus: event.isNeedFocus,
      );
    } else if (event is ReloadRegistrationProcessEvent) {
      yield state.copyWith(
        requestStatus: LoadingState(),
        formStatus: FormSubmitting(),
        msValue: null,
      );
      try {
        _registrationProcess =
            await _dataService.ReloadAdminRegistrationProcess(
                state.registrationProcess);
        yield state.copyWith(
          registrationProcess: _registrationProcess,
          requestStatus: LoadedState(),
          formStatus: SubmissionSuccess(),
          message: Message(
              regProc: RegProc(
                  totalCount: 0,
                  isRunning: true,
                  isStopping: true,
                  id_registered: 0)),
          msValue: null, // Debug
        );
      } on SocketException catch (e) {
        yield state.copyWith(
          requestStatus: FailedState(e.toString()),
          formStatus: SubmissionFailed(e.toString()),
          msValue: null,
        );
      } catch (e) {
        yield state.copyWith(
            requestStatus: FailedState(e.toString()), msValue: null);
      }
    } else if (event is CompleteRegistrationProcessEvent) {
      yield state.copyWith(
          requestStatus: LoadingState(),
          formStatus: FormSubmitting(),
          msValue: null);
      try {
        _registrationProcess =
            await _dataService.UpdateAdminRegistrationProcess(
                RegistrationProcess(
          id: state.registrationProcess!.id,
          start_date: state.start_date,
          end_date: DateTime.now(),
          registrationBallot: state.registrationProcess!.registrationBallot,
          total_count: state.registrationProcess!.total_count,
          csrf_token: state.registrationProcess!.csrf_token,
        ));
        yield state.copyWith(
          registrationProcess: _registrationProcess,
          requestStatus: LoadedState(),
          formStatus: SubmissionSuccess(),
          message: Message(
              regProc: RegProc(
                  totalCount: 0,
                  isRunning: true,
                  isStopping: true,
                  id_registered: 0)),
          msValue: null, // Debug
        );
      } on SocketException catch (e) {
        yield state.copyWith(
          requestStatus: FailedState(e.toString()),
          formStatus: SubmissionFailed(e.toString()),
          msValue: null,
        );
      } catch (e) {
        yield state.copyWith(
            requestStatus: FailedState(e.toString()), msValue: null);
      }
    } else if (event is StartRegistrationProcessEvent) {
      yield state.copyWith(
          requestStatus: LoadingState(),
          formStatus: FormSubmitting(),
          msValue: null);
      try {
        _registrationProcess =
            await _dataService.UpdateAdminRegistrationProcess(
                RegistrationProcess(
          id: state.registrationProcess!.id,
          start_date: DateTime.now(),
          end_date: state.end_date,
          registrationBallot: state.registrationProcess!.registrationBallot,
          total_count: state.registrationProcess!.total_count,
          csrf_token: state.registrationProcess!.csrf_token,
        ));
        yield state.copyWith(
          registrationProcess: _registrationProcess,
          requestStatus: LoadedState(),
          formStatus: SubmissionSuccess(),
          message: Message(
              regProc: RegProc(
                  totalCount: 0,
                  isRunning: true,
                  isStopping: true,
                  id_registered: 0)),
          msValue: null, // Debug
        );
      } on SocketException catch (e) {
        yield state.copyWith(
          requestStatus: FailedState(e.toString()),
          formStatus: SubmissionFailed(e.toString()),
          msValue: null,
        );
      } catch (e) {
        yield state.copyWith(
            requestStatus: FailedState(e.toString()), msValue: null);
      }
    }
  }

  void dispose() {}
}
