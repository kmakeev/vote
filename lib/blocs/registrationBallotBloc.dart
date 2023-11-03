import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/services/dataServices.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'dart:io';

abstract class RegistrationBallotEvent {}

class IsRegisteredChanged extends RegistrationBallotEvent {
  final bool isRegistered;

  IsRegisteredChanged({required this.isRegistered});
}

class InitRegistrationBallotEvent extends RegistrationBallotEvent {
  final RegistrationBallot registrationBallot;

  InitRegistrationBallotEvent({required this.registrationBallot});
}

class SubmitRegistrationBallotEvent extends RegistrationBallotEvent {}

class ReloadRegistrationBallotEvent extends RegistrationBallotEvent {}

class RegistrationBallotState {
  final bool isRegistered;
  final RegistrationBallot? registrationBallot;
  final State requestStatus;
  final FormSubmissionStatus formStatus;

  RegistrationBallotState({
    this.isRegistered = false,
    this.registrationBallot,
    this.requestStatus = const InitState(),
    this.formStatus = const InitialFormStatus(),
  });

  RegistrationBallotState copyWith({
    bool? isRegistered,
    RegistrationBallot? registrationBallot,
    State? requestStatus,
    FormSubmissionStatus? formStatus,
  }) {
    return RegistrationBallotState(
      isRegistered: isRegistered ?? this.isRegistered,
      registrationBallot: registrationBallot ?? this.registrationBallot,
      requestStatus: requestStatus ?? this.requestStatus,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}

class RegistrationBallotBloc
    extends Bloc<RegistrationBallotEvent, RegistrationBallotState> {
  final DataService _dataService;

  RegistrationBallotBloc(this._dataService)
      : assert(_dataService != null),
        super(RegistrationBallotState());

  @override
  Stream<RegistrationBallotState> mapEventToState(
      RegistrationBallotEvent event) async* {
    RegistrationBallot _registrationBallot;
    if (event is IsRegisteredChanged) {
      yield state.copyWith(isRegistered: event.isRegistered);
    } else if (event is InitRegistrationBallotEvent) {
      yield state.copyWith(
          registrationBallot: event.registrationBallot,
          requestStatus: LoadedState(),
          formStatus: SubmissionSuccess());
    } else if (event is SubmitRegistrationBallotEvent) {
      yield state.copyWith(
          isRegistered: state.isRegistered, formStatus: FormSubmitting());
      try {
        _registrationBallot = await _dataService.UpdateRegistrationBallot(
            RegistrationBallot(
                id: state.registrationBallot!.id,
                isRegistered: state.isRegistered,
                participant: state.registrationBallot!.participant,
                csrf_token: state.registrationBallot!.csrf_token));
        yield state.copyWith(
            isRegistered: state.isRegistered,
            registrationBallot: _registrationBallot,
            requestStatus: LoadedState(),
            formStatus: SubmissionSuccess());
      } on SocketException catch (e) {
        yield state.copyWith(
          requestStatus: FailedState(e.toString()),
          formStatus: SubmissionFailed(e.toString()),
        );
      } catch (e) {
        yield state.copyWith(requestStatus: FailedState(e.toString()));
      }
    } else if (event is ReloadRegistrationBallotEvent) {
      yield state.copyWith(
        requestStatus: LoadingState(),
      );
      try {
        _registrationBallot = await _dataService.ReloadRegistrationBallot(
            RegistrationBallot(
                id: state.registrationBallot!.id,
                isRegistered: state.isRegistered,
                participant: state.registrationBallot!.participant,
                csrf_token: state.registrationBallot!.csrf_token));
        yield state.copyWith(
          isRegistered: state.isRegistered,
          registrationBallot: _registrationBallot,
          requestStatus: LoadedState(),
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
  }

  void dispose() {}
}
