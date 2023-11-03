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

class InitRegistrationProcessEvent extends RegistrationProcessEvent {
  final OnlyMyRegistrationProcess registrationProcess;

  InitRegistrationProcessEvent({required this.registrationProcess});
}

class StartRegistrationProcessEvent extends RegistrationProcessEvent {}

class StopRegistrationProcessEvent extends RegistrationProcessEvent {}

class RegistrationProcessState {
  final DateTime? start_date;
  final DateTime? end_date;
  final OnlyMyRegistrationProcess? registrationProcess;
  final State requestStatus;
  final FormSubmissionStatus formStatus;

  RegistrationProcessState({
    this.start_date,
    this.end_date,
    this.registrationProcess,
    this.requestStatus = const InitState(),
    this.formStatus = const InitialFormStatus(),
  });

  RegistrationProcessState copyWith({
    DateTime? start_date,
    DateTime? end_date,
    OnlyMyRegistrationProcess? registrationProcess,
    State? requestStatus,
    FormSubmissionStatus? formStatus,
  }) {
    return RegistrationProcessState(
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      registrationProcess: registrationProcess ?? this.registrationProcess,
      requestStatus: requestStatus ?? this.requestStatus,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}

class RegistrationProcessBloc
    extends Bloc<RegistrationProcessEvent, RegistrationProcessState> {
  final DataService _dataService;

  RegistrationProcessBloc(this._dataService)
      : assert(_dataService != null),
        super(RegistrationProcessState());

  @override
  Stream<RegistrationProcessState> mapEventToState(
      RegistrationProcessEvent event) async* {
    OnlyMyRegistrationProcess _registrationProcess;
    if (event is StartDateChanged) {
      yield state.copyWith(
          start_date: event.start_date,
          requestStatus: InitState(),
          formStatus: InitialFormStatus());
    } else if (event is EndDateChanged) {
      yield state.copyWith(
          end_date: event.end_date,
          requestStatus: InitState(),
          formStatus: InitialFormStatus());
    } else if (event is InitRegistrationProcessEvent) {
      yield state.copyWith(
          registrationProcess: event.registrationProcess,
          requestStatus: InitState(),
          formStatus: InitialFormStatus());
    } else if (event is StartRegistrationProcessEvent) {
      yield state.copyWith(
          start_date: DateTime.now(), //
          formStatus: FormSubmitting());
      try {
        //_registrationProcess = await _dataService.updateRegistrationProcess(
        //    OnlyMyRegistrationProcess(
        //      id: state.registrationProcess!.id,
        //      start_date: state.start_date,
        //     end_date: state.end_date,
        //     registrationBallot: state.registrationProcess!.registrationBallot,
        //   ));
        //yield state.copyWith(
        //    registrationProcess: _registrationProcess,
        //    requestStatus: LoadedState(),
        //    formStatus: SubmissionSuccess());
      } on SocketException catch (e) {
        yield state.copyWith(
          requestStatus: FailedState(e.toString()),
          formStatus: SubmissionFailed(e.toString()),
        );
      } catch (e) {
        yield state.copyWith(requestStatus: FailedState(e.toString()));
      }
    } else if (event is StartRegistrationProcessEvent) {
      yield state.copyWith(
          end_date: DateTime.now(), //
          formStatus: FormSubmitting());
      try {
        // _registrationProcess = await _dataService.updateRegistrationProcess(
        //    OnlyMyRegistrationProcess(
        //      id: state.registrationProcess!.id,
        //      start_date: state.start_date,
        //      end_date: state.end_date,
        //      registrationBallot: state.registrationProcess!.registrationBallot,
        //    ));
        //yield state.copyWith(
        //    registrationProcess: _registrationProcess,
        //    requestStatus: LoadedState(),
        //    formStatus: SubmissionSuccess());
      } on SocketException catch (e) {
        yield state.copyWith(
          requestStatus: FailedState(e.toString()),
          formStatus: SubmissionFailed(e.toString()),
        );
      } catch (e) {
        yield state.copyWith(requestStatus: FailedState(e.toString()));
      }
    }

    void dispose() {}
  }
}
