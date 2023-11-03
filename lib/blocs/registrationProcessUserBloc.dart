import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/services/dataServices.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'dart:io';

abstract class RegistrationProcessEvent {}

class StartDateChanged extends RegistrationProcessEvent {
  final DateTime start_date;

  StartDateChanged({required this.start_date});
}

class EndDateChanged extends RegistrationProcessEvent {
  final DateTime end_date;

  EndDateChanged({required this.end_date});
}

class WSMessageChanged extends RegistrationProcessEvent {
  final Message message;

  WSMessageChanged({required this.message});
}

class IsNeedFocusChanged extends RegistrationProcessEvent {
  final bool newFocus;

  IsNeedFocusChanged({required this.newFocus});
}

class InitRegistrationProcessEvent extends RegistrationProcessEvent {
  final OnlyMyRegistrationProcess registrationProcess;
  bool isNeedFocus;

  InitRegistrationProcessEvent(
      {required this.registrationProcess, this.isNeedFocus = true});
}

class ReloadRegistrationProcessEvent extends RegistrationProcessEvent {}

class CompleteRegistrationProcessEvent extends RegistrationProcessEvent {}

class RegistrationProcessState {
  final DateTime? start_date;
  final DateTime? end_date;
  final OnlyMyRegistrationProcess? registrationProcess;
  final State requestStatus;
  final FormSubmissionStatus formStatus;
  final Message? message;
  final bool isNeedFocus;

  RegistrationProcessState({
    this.start_date,
    this.end_date,
    this.registrationProcess,
    this.requestStatus = const InitState(),
    this.formStatus = const InitialFormStatus(),
    this.message,
    this.isNeedFocus = true,
  });

  RegistrationProcessState copyWith({
    DateTime? start_date,
    DateTime? end_date,
    OnlyMyRegistrationProcess? registrationProcess,
    State? requestStatus,
    FormSubmissionStatus? formStatus,
    Message? message,
    bool? isNeedFocus,
  }) {
    return RegistrationProcessState(
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      registrationProcess: registrationProcess ?? this.registrationProcess,
      requestStatus: requestStatus ?? this.requestStatus,
      formStatus: formStatus ?? this.formStatus,
      message: message ?? this.message,
      isNeedFocus: isNeedFocus ?? this.isNeedFocus,
    );
  }
}

class RegistrationProcessUserBloc
    extends Bloc<RegistrationProcessEvent, RegistrationProcessState> {
  final DataService _dataService;

  RegistrationProcessUserBloc(this._dataService)
      : assert(_dataService != null),
        super(RegistrationProcessState());

  @override
  Stream<RegistrationProcessState> mapEventToState(
      RegistrationProcessEvent event) async* {
    OnlyMyRegistrationProcess _registrationProcess;
    if (event is IsNeedFocusChanged) {
      yield state.copyWith(isNeedFocus: event.newFocus);
    } else if (event is WSMessageChanged) {
      yield state.copyWith(
        message: event.message,
      );
    } else if (event is InitRegistrationProcessEvent) {
      yield state.copyWith(
        start_date: event.registrationProcess.start_date,
        end_date: event.registrationProcess.end_date,
        registrationProcess: event.registrationProcess,
        requestStatus: LoadedState(),
        //Первая инициализация из события, После этого статуса отображаем в виждете
        formStatus: InitialFormStatus(),
        message: Message(
            regProc: RegProc(
                totalCount: 0,
                isRunning: true,
                isStopping: true,
                id_registered: 0)),
      );
    } else if (event is ReloadRegistrationProcessEvent) {
      yield state.copyWith(
          requestStatus: LoadingState(), formStatus: FormSubmitting());
      try {
        _registrationProcess =
            await _dataService.ReloadOnlyMyRegistrationProcess(
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
                  id_registered: 0)), // Debug
        );
      } on SocketException catch (e) {
        yield state.copyWith(
          requestStatus: FailedState(e.toString()),
          formStatus: SubmissionFailed(e.toString()),
        );
      } catch (e) {
        yield state.copyWith(requestStatus: FailedState(e.toString()));
      }
    }
    /*
    else if (event is CompleteRegistrationProcessEvent) {
      yield state.copyWith(
          requestStatus: LoadingState(), formStatus: FormSubmitting());
      try {
        _registrationProcess =
            await _dataService.updateOnlyMyRegistrationProcess(
                //Временно, т.к. должно завершаться для всех
                OnlyMyRegistrationProcess(
          id: state.registrationProcess!.id,
          start_date: state.start_date,
          end_date: DateTime.now(),
          registrationBallot: state.registrationProcess!.registrationBallot,
          total_count: state.registrationProcess!.total_count,
        ));
        yield state.copyWith(
          registrationProcess: _registrationProcess,
          requestStatus: LoadedState(),
          formStatus: SubmissionSuccess(),
          message: Message(
              regProc: RegProc(totalCount: 0, isRunning: true, id_registered:0)), // Debug
        );
      } on SocketException catch (e) {
        yield state.copyWith(
          requestStatus: FailedState(e.toString()),
          formStatus: SubmissionFailed(e.toString()),
        );
      } catch (e) {
        yield state.copyWith(requestStatus: FailedState(e.toString()));
      }
    }

*/
  }

  void dispose() {}
}
