import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/services/dataServices.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'dart:io';

abstract class VotingProcessAdminEvent {}

class StartDateChanged extends VotingProcessAdminEvent {
  final DateTime start_date;

  StartDateChanged({required this.start_date});
}

class EndDateChanged extends VotingProcessAdminEvent {
  final DateTime end_date;

  EndDateChanged({required this.end_date});
}

class WSMessageVotingAdminChanged extends VotingProcessAdminEvent {
  final Message message;

  WSMessageVotingAdminChanged({required this.message});
}

class StartMillisecondsVotingChanged extends VotingProcessAdminEvent {
  final Difference msValue;

  StartMillisecondsVotingChanged({required this.msValue});
}

class InitVotingProcessEvent extends VotingProcessAdminEvent {
  List<VotingProcess> votingProcesses;
  int indexActiveVotingProcess;

  InitVotingProcessEvent(
      {required this.votingProcesses, required this.indexActiveVotingProcess});
}

class IndexActiveVotingProcessChangedEvent extends VotingProcessAdminEvent {
  int indexActiveVotingProcess;

  IndexActiveVotingProcessChangedEvent(
      {required this.indexActiveVotingProcess});
}

class ReloadVotingProcessEvent extends VotingProcessAdminEvent {
  int id_votingProcess;

  ReloadVotingProcessEvent(
      {required this.id_votingProcess});

}

class CompleteVotingProcessEvent extends VotingProcessAdminEvent {}

class StartVotingProcessEvent extends VotingProcessAdminEvent {}

class VotingProcessState {
  final DateTime? start_date;
  final DateTime? end_date;
  final List<VotingProcess> votingProcesses;
  final int indexActiveVotingProcess;
  final State requestStatus;
  final FormSubmissionStatus formStatus;
  final Message? message;
  final Difference? msValue;

  VotingProcessState({
    this.start_date,
    this.end_date,
    this.votingProcesses = const [],
    this.indexActiveVotingProcess = 0, //first
    this.requestStatus = const InitState(),
    this.formStatus = const InitialFormStatus(),
    this.message,
    this.msValue,
  });

  VotingProcessState copyWith({
    DateTime? start_date,
    DateTime? end_date,
    List<VotingProcess>? votingProcesses,
    int? indexActiveVotingProcess,
    State? requestStatus,
    FormSubmissionStatus? formStatus,
    Message? message,
    Difference? msValue,
  }) {
    return VotingProcessState(
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      votingProcesses: votingProcesses ?? this.votingProcesses,
      indexActiveVotingProcess:
          indexActiveVotingProcess ?? this.indexActiveVotingProcess,
      requestStatus: requestStatus ?? this.requestStatus,
      formStatus: formStatus ?? this.formStatus,
      message: message ?? this.message,
      msValue: msValue ?? this.msValue,
    );
  }
}

class VotingProcessAdminBloc
    extends Bloc<VotingProcessAdminEvent, VotingProcessState> {
  final DataService _dataService;

  VotingProcessAdminBloc(this._dataService)
      : assert(_dataService != null),
        super(VotingProcessState());

  @override
  Stream<VotingProcessState> mapEventToState(
      VotingProcessAdminEvent event) async* {
    VotingProcess _votingProcess;
    if (event is StartDateChanged) {
      yield state.copyWith(
        start_date: event.start_date,
      );
    } else if (event is EndDateChanged) {
      yield state.copyWith(
        end_date: event.end_date,
      );
    } else if (event is WSMessageVotingAdminChanged) {
      yield state.copyWith(
        message: event.message,
      );
    } else if (event is StartMillisecondsVotingChanged) {
      yield state.copyWith(msValue: event.msValue);
    } else if (event is IndexActiveVotingProcessChangedEvent) {
      yield state.copyWith(
          indexActiveVotingProcess: event.indexActiveVotingProcess);
    } else if (event is InitVotingProcessEvent) {
      yield state.copyWith(
        start_date:
            event.votingProcesses[event.indexActiveVotingProcess].start_date,
        end_date:
            event.votingProcesses[event.indexActiveVotingProcess].end_date,
        votingProcesses: event.votingProcesses,
        indexActiveVotingProcess: event.indexActiveVotingProcess,
        requestStatus: LoadedState(),
        //Первая инициализация из события, После этого статуса отображаем в виджете
        formStatus: InitialFormStatus(),
        message: Message(
            voteProc: VoteProc(
                totalCount: 0,
                isRunning: true,
                isStopping: true,
                id_voting:
                    event.votingProcesses[event.indexActiveVotingProcess].id!)),
        msValue: null,
      );
    } else if (event is ReloadVotingProcessEvent) {
      yield state.copyWith(
        requestStatus: LoadingState(),
        formStatus: FormSubmitting(),
        msValue: null,
        message: Message(
            voteProc: VoteProc(
                totalCount: 0,
                isRunning: true,
                isStopping: true,
                id_voting: 0)),

      );
      try {
        _votingProcess = await _dataService.ReloadAdminVotingProcess(
            state.votingProcesses[state.indexActiveVotingProcess]);
        var _votingProcesses = state.votingProcesses;
        _votingProcesses[state.indexActiveVotingProcess] = _votingProcess;
        yield state.copyWith(
          votingProcesses: _votingProcesses,
          requestStatus: LoadedState(),
          formStatus: SubmissionSuccess(),
          message: Message(
              voteProc: VoteProc(
                  totalCount: 0,
                  isRunning: true,
                  isStopping: true,
                  id_voting: 0)),
          msValue: null,
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
    } else if (event is CompleteVotingProcessEvent) {
      yield state.copyWith(
          requestStatus: LoadingState(),
          formStatus: FormSubmitting(),
          msValue: null);
      try {
        var _votingProcesses = state.votingProcesses;
        _votingProcess = await _dataService.UpdateAdminVotingProcess(//меняем
            VotingProcess(
          id: state.votingProcesses[state.indexActiveVotingProcess].id,
          start_date:
              state.votingProcesses[state.indexActiveVotingProcess].start_date,
          end_date: DateTime.now(),
          question:
              state.votingProcesses[state.indexActiveVotingProcess].question,
          answers:
              state.votingProcesses[state.indexActiveVotingProcess].answers,
          voteBallot:
              state.votingProcesses[state.indexActiveVotingProcess].voteBallot,
          total_count:
              state.votingProcesses[state.indexActiveVotingProcess].total_count,
          csrf_token:
              state.votingProcesses[state.indexActiveVotingProcess].csrf_token,
        ));
        _votingProcesses[state.indexActiveVotingProcess] = _votingProcess;
        yield state.copyWith(
          votingProcesses: _votingProcesses,
          requestStatus: LoadedState(),
          formStatus: SubmissionSuccess(),
          message: Message(
              voteProc: VoteProc(
                  totalCount: 0,
                  isRunning: true,
                  isStopping: true,
                  id_voting: 0)),
          //edit for all
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
    } else if (event is StartVotingProcessEvent) {
      yield state.copyWith(
          requestStatus: LoadingState(),
          formStatus: FormSubmitting(),
          msValue: null);
      try {
        var _votingProcesses = state.votingProcesses;
        _votingProcess = await _dataService.UpdateAdminVotingProcess(//Update
            VotingProcess(
          id: state.votingProcesses[state.indexActiveVotingProcess].id,
          start_date: DateTime.now(),
          end_date:
              state.votingProcesses[state.indexActiveVotingProcess].end_date,
          question:
              state.votingProcesses[state.indexActiveVotingProcess].question,
          answers:
              state.votingProcesses[state.indexActiveVotingProcess].answers,
          voteBallot:
              state.votingProcesses[state.indexActiveVotingProcess].voteBallot,
          total_count:
              state.votingProcesses[state.indexActiveVotingProcess].total_count,
          csrf_token:
              state.votingProcesses[state.indexActiveVotingProcess].csrf_token,
        ));
        _votingProcesses[state.indexActiveVotingProcess] = _votingProcess;
        yield state.copyWith(
          votingProcesses: _votingProcesses,
          requestStatus: LoadedState(),
          formStatus: SubmissionSuccess(),
          message: Message(
              voteProc: VoteProc(
                  totalCount: 0,
                  isRunning: true,
                  isStopping: true,
                  id_voting: 0)),
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
