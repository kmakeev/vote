import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/services/dataServices.dart';
import 'package:voting_flutter/blocs/states.dart' as st;
import 'package:voting_flutter/blocs/formStatus.dart';
import 'dart:io';

abstract class VoteBallotEvent {}

class AnswerChanged extends VoteBallotEvent {
  final Answer? answer;

  AnswerChanged({this.answer});
}

class InitVoteBallotEvent extends VoteBallotEvent {
  final int? voteBallot_id;

  // final int allAnswersCount;

  InitVoteBallotEvent({
    this.voteBallot_id,
  });
}

class ToInitVoteBallotEvent extends VoteBallotEvent {
}

class ChangeVoteBallotEvent extends VoteBallotEvent {
  final VoteBallot voteBallot;

  // final int allAnswersCount;

  ChangeVoteBallotEvent({
    required this.voteBallot,
    //required this.allAnswersCount
  });
}

class SubmitVoteBallotEvent extends VoteBallotEvent {}

class ReloadVoteBallotEvent extends VoteBallotEvent {
  final int voteBallot_id;

  ReloadVoteBallotEvent({
    required this.voteBallot_id,
  });
}

class VoteBallotState {
  final Answer? answer;
  final VoteBallot? voteBallot;
  final st.State requestStatus;
  final FormSubmissionStatus formStatus;

  // final List<bool> isSelected;

  VoteBallotState({
    this.answer,
    this.voteBallot,
    this.requestStatus = const st.InitState(),
    this.formStatus = const InitialFormStatus(),
    // this.isSelected = const [],
  });

  VoteBallotState copyWith({
    ValueGetter<Answer?>? answer,
    VoteBallot? voteBallot,
    st.State? requestStatus,
    FormSubmissionStatus? formStatus,
    // List<bool>? isSelected,
  }) {
    return VoteBallotState(
      answer: answer != null ? answer() : this.answer,
      voteBallot: voteBallot ?? this.voteBallot,
      requestStatus: requestStatus ?? this.requestStatus,
      formStatus: formStatus ?? this.formStatus,
      // isSelected: isSelected ?? this.isSelected,
    );
  }
}

class VoteBallotBloc extends Bloc<VoteBallotEvent, VoteBallotState> {
  final DataService _dataService;

  VoteBallotBloc(this._dataService)
      : assert(_dataService != null),
        super(VoteBallotState());

  @override
  Stream<VoteBallotState> mapEventToState(VoteBallotEvent event) async* {
    VoteBallot _voteBallot;

    if (event is AnswerChanged) {
      yield state.copyWith(answer: () => event.answer);
    } else if (event is ToInitVoteBallotEvent) {
      print('To restore Init State');
      yield state.copyWith(requestStatus: st.InitState());
    } else if (event is InitVoteBallotEvent) {
      print('Init VoteBallot ${event.voteBallot_id}');
      if (event.voteBallot_id != null) {
        yield state.copyWith(
          requestStatus: st.LoadingState(),
        );

        try {
          _voteBallot = await _dataService.ReloadVoteBallot(VoteBallot(
              id: event.voteBallot_id,
              answer: state.answer,
              participant: state.voteBallot!.participant,
              csrf_token: state.voteBallot!.csrf_token));
          yield state.copyWith(
            answer: () => state.answer,
            voteBallot: _voteBallot,
            requestStatus: st.LoadedState(),
            formStatus: SubmissionSuccess(),
          );
        } on SocketException catch (e) {
          yield state.copyWith(
            requestStatus: st.FailedState(e.toString()),
            formStatus: SubmissionFailed(e.toString()),
          );
        } catch (e) {
          yield state.copyWith(requestStatus: st.FailedState(e.toString()));
        }
      }
    } else if (event is ChangeVoteBallotEvent) {
      print('Change Vote ballot ${event.voteBallot} ${event.voteBallot.answer}');
      yield state.copyWith(
        voteBallot: event.voteBallot,
        requestStatus: st.LoadedState(),
        formStatus: SubmissionSuccess(),
        answer: () => event.voteBallot.answer,
        // isSelected: List.filled(
        //     event.allAnswersCount, false),
      );
    } else if (event is SubmitVoteBallotEvent) {
      print('Submit Voteballot ${state.voteBallot!.id}');
      yield state.copyWith(
          answer: () => state.answer, formStatus: FormSubmitting());
      try {
        _voteBallot = await _dataService.UpdateVoteBallot(VoteBallot(
            id: state.voteBallot!.id,
            answer: state.answer,
            participant: state.voteBallot!.participant,
            csrf_token: state.voteBallot!.csrf_token));
        yield state.copyWith(
            answer: () => state.answer,
            voteBallot: _voteBallot,
            requestStatus: st.LoadedState(),
            formStatus: SubmissionSuccess());
      } on SocketException catch (e) {
        yield state.copyWith(
          requestStatus: st.FailedState(e.toString()),
          formStatus: SubmissionFailed(e.toString()),
        );
      } catch (e) {
        yield state.copyWith(requestStatus: st.FailedState(e.toString()));
      }
    } else if (event is ReloadVoteBallotEvent) {
      print('Reload VoteBallot ${event.voteBallot_id}');
      if (event.voteBallot_id != null) {
        yield state.copyWith(
          requestStatus: st.LoadingState(),
        );
        try {
          _voteBallot = await _dataService.ReloadVoteBallot(VoteBallot(
              id: event.voteBallot_id,
              answer: state.answer,
              participant: state.voteBallot!.participant,
              csrf_token: state.voteBallot!.csrf_token));
          yield state.copyWith(
            answer: () => state.answer,
            voteBallot: _voteBallot,
            requestStatus: st.LoadedState(),
          );
        } on SocketException catch (e) {
          yield state.copyWith(
            requestStatus: st.FailedState(e.toString()),
            formStatus: SubmissionFailed(e.toString()),
          );
        } catch (e) {
          yield state.copyWith(requestStatus: st.FailedState(e.toString()));
        }
      }
    }

    void dispose() {}
  }
}
