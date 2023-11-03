import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/services/dataServices.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'dart:io';

abstract class VoteProcessUserEvent {}

class WSMessageVotingUserChanged extends VoteProcessUserEvent {
  final Message message;

  WSMessageVotingUserChanged({required this.message});
}

class AnswerChangedEvent extends VoteProcessUserEvent {
  final int index;

  AnswerChangedEvent({required this.index});
}

class InitVotingProcessEvent extends VoteProcessUserEvent {
  List<OnlyMyVotingProcess> votingProcesses;
  int indexActiveVotingProcess;

  InitVotingProcessEvent(
      {required this.votingProcesses, required this.indexActiveVotingProcess});
}

class IndexActiveVotingProcessChangedEvent extends VoteProcessUserEvent {
  int indexActiveVotingProcess;

  IndexActiveVotingProcessChangedEvent(
      {required this.indexActiveVotingProcess});
}

class ReloadVotingProcessEvent extends VoteProcessUserEvent {
  int index_votingProcess;

  ReloadVotingProcessEvent({required this.index_votingProcess});
}

class SubmitVoteBallotFromVotingProcessEvent extends VoteProcessUserEvent {}

class VoteProcessUserState {
  final List<OnlyMyVotingProcess> votingProcesses;
  final int indexActiveVotingProcess;
  final State requestStatus;
  final FormSubmissionStatus formStatus;
  final Message? message;
  final List<List<bool>> isSelected;

  VoteProcessUserState({
    this.votingProcesses = const [],
    this.indexActiveVotingProcess = 0, //first
    this.requestStatus = const InitState(),
    this.formStatus = const InitialFormStatus(),
    this.message,
    this.isSelected = const [[]],
  });

  VoteProcessUserState copyWith({
    List<OnlyMyVotingProcess>? votingProcesses,
    int? indexActiveVotingProcess,
    State? requestStatus,
    FormSubmissionStatus? formStatus,
    Message? message,
    List<List<bool>>? isSelected,
  }) {
    return VoteProcessUserState(
      votingProcesses: votingProcesses ?? this.votingProcesses,
      indexActiveVotingProcess:
          indexActiveVotingProcess ?? this.indexActiveVotingProcess,
      requestStatus: requestStatus ?? this.requestStatus,
      formStatus: formStatus ?? this.formStatus,
      message: message ?? this.message,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class VoteProcessUserBloc
    extends Bloc<VoteProcessUserEvent, VoteProcessUserState> {
  final DataService _dataService;

  VoteProcessUserBloc(this._dataService)
      : assert(_dataService != null),
        super(VoteProcessUserState());

  @override
  Stream<VoteProcessUserState> mapEventToState(
      VoteProcessUserEvent event) async* {
    OnlyMyVotingProcess _votingProcess;
    VoteBallot _voteBallot;

    if (event is WSMessageVotingUserChanged) {
      yield state.copyWith(
        message: event.message,
      );
    } else if (event is IndexActiveVotingProcessChangedEvent) {
      yield state.copyWith(
          indexActiveVotingProcess: event.indexActiveVotingProcess);
    } else if (event is AnswerChangedEvent) {
      for (var i = 0;
          i < state.isSelected[state.indexActiveVotingProcess].length;
          i++) {
        if (i == event.index) {
          state.isSelected[state.indexActiveVotingProcess][event.index] =
              !state.isSelected[state.indexActiveVotingProcess][event.index];
        } else
          state.isSelected[state.indexActiveVotingProcess][i] = false;
      }
      yield state.copyWith(isSelected: state.isSelected);
    } else if (event is InitVotingProcessEvent) {
      yield state.copyWith(
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
        isSelected: List<List<bool>>.generate(event.votingProcesses.length,
            (i) => List.filled(event.votingProcesses[i].answers.length, false)),
      );
    } else if (event is ReloadVotingProcessEvent) {
      print('Reload one VotingProc with ID - ${event.index_votingProcess}');
      yield state.copyWith(
        requestStatus: LoadingState(),
        formStatus: FormSubmitting(),
        message: Message(
            voteProc: VoteProc(
                totalCount: 0,
                isRunning: true,
                isStopping: true,
                id_voting: 0)),
      );
      try {
        _votingProcess = await _dataService.ReloadOnlyMyVotingProcess(
            state.votingProcesses[event.index_votingProcess]);
        var _votingProcesses = state.votingProcesses;
        _votingProcesses[event.index_votingProcess] = _votingProcess;
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
          isSelected: List<List<bool>>.generate(
              _votingProcesses.length,
              (i) => List.filled(
                  _votingProcesses[i].answers.length, false)), // Debug
        );
      } on SocketException catch (e) {
        yield state.copyWith(
          requestStatus: FailedState(e.toString()),
          formStatus: SubmissionFailed(e.toString()),
        );
      } catch (e) {
        yield state.copyWith(requestStatus: FailedState(e.toString()));
      }
    } else if (event is SubmitVoteBallotFromVotingProcessEvent) {
      print('Submit VoteBallot from VotingBloc');
      yield state.copyWith(
        requestStatus: LoadingState(),
        formStatus: FormSubmitting(),
        message: Message(
            voteProc: VoteProc(
                totalCount: 0,
                isRunning: true,
                isStopping: true,
                id_voting: 0)),
      );
      try {
        var _votingProcesses = state.votingProcesses;
        var _modificatedVotingProcess =
            state.votingProcesses[state.indexActiveVotingProcess];
        var _modificatedVoteBallot = _modificatedVotingProcess.voteBallot;
        for (var i = 0;
            i < state.isSelected[state.indexActiveVotingProcess].length;
            i++) {
          if (state.isSelected[state.indexActiveVotingProcess][i] == true) {
            var _newVotingProcess = _modificatedVotingProcess.copyWith(
                voteBallot: _modificatedVoteBallot.copyWith(
                    answer: state
                        .votingProcesses[state.indexActiveVotingProcess]
                        .answers[i]));
            _votingProcesses[state.indexActiveVotingProcess] =
                _newVotingProcess;
          }
        }
        _voteBallot = await _dataService.UpdateVoteBallot(
            _votingProcesses[state.indexActiveVotingProcess].voteBallot);
        yield state.copyWith(
          formStatus: SubmissionSuccess(),
          votingProcesses: _votingProcesses,
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
