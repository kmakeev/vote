import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/api/globals.dart' as global;
import 'package:voting_flutter/screens/user/widget/forVoting.dart';
import 'package:voting_flutter/blocs/registrationProcessUserBloc.dart';
import 'package:voting_flutter/blocs/votingProcessUserBlock.dart';
import 'package:voting_flutter/blocs/userMeetingBloc.dart';

import 'package:voting_flutter/blocs/votingBallotBloc.dart';

class VotingProcessCards extends StatelessWidget {
  final int indexVotingProcess;
  final int withoutRegister;
  final TabController controller;
  final BuildContext forControllerContext;

  VotingProcessCards(
      {required this.indexVotingProcess,
      required this.withoutRegister,
      required this.controller,
      required this.forControllerContext});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final meetingstate = context.watch<UserMeetingBloc>().state;
      final votingstate = context.watch<VoteProcessUserBloc>().state;
      final votingProcess = votingstate.votingProcesses[indexVotingProcess];
      final loadingstatus = votingstate.requestStatus;

      //final TabController controller = DefaultTabController.of(context);

      //controller.removeListener(() {});
      if (!controller.hasListeners) {
        controller.addListener(() {
          if (!controller.indexIsChanging) {
            if (controller.index != null && controller.index >= 0) {
              var current_index = controller.index - withoutRegister;
              print("Change to index ${current_index}");

              if (forControllerContext.mounted) {
                print('Widgets context is mounted');
                if (meetingstate.meeting!.isRequiredRegistration)
                  forControllerContext.read<RegistrationProcessUserBloc>().add(
                      IsNeedFocusChanged(
                          newFocus: current_index == -1 ? true : false));
                forControllerContext.read<VoteProcessUserBloc>().add(
                    IndexActiveVotingProcessChangedEvent(
                        indexActiveVotingProcess: current_index != -1 ? current_index : 0));
                // forControllerContext.read<VoteBallotBloc>().add(ChangeVoteBallotEvent(
                //    voteBallot: meetingstate
                //        .meeting!.votingProcess[current_index != -1 ? current_index : 0].voteBallot,
                    // allAnswersCount: meetingstate
                    //    .meeting!.votingProcess[current_index].answers.length
                //    ));
              } else
                print('Wisget context IS NOT mounted');
            }
          }
        });
      }

      var total_voting;
      if (loadingstatus is LoadedState) {
        total_voting = votingProcess!.total_count;
        if (votingstate.message != null) {
          if (votingstate.message!.voteProc!.totalCount > total_voting)
            total_voting = votingstate.message!.voteProc!.totalCount;
        }

      }
      return Card(
        color: global.backgroundColor,
        shadowColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: votingstate.formStatus is FormSubmitting
              ? const Center(
                  child: SpinKitThreeBounce(color: Colors.white54, size: 160),
                )
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            VotingProcessStateCard(
                              votingProcess: votingProcess!,
                            ),
                          ]),
                      Container(
                          child: Expanded(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          VotingProcessCards_(
                            votingProcess: votingProcess!,
                          ),
                          Container(
                              // width: 600,
                              child: votingProcess!.start_date != null &&
                                      votingProcess!.end_date == null
                                  ? Expanded(
                                      child: VotingInProgress(
                                        total_voting: total_voting,
                                      votingProcess: votingProcess,
                                        myIndex: indexVotingProcess,
                                    ))
                                  : votingProcess!.start_date == null &&
                                          votingProcess!.end_date == null
                                      ? Expanded(
                                          child: VotingNotStarted(
                                          indexVotingProcess:
                                              indexVotingProcess,
                                          votingProcess: votingProcess,
                                        ))
                                      : Expanded(
                                          child: VotingEnded(
                                              votingProcess: votingProcess!))),
                          Row(children: [
                            Expanded(
                                child: Text('${meetingstate.meeting!.name}',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 40)))
                          ])
                        ],
                      )))
                    ])),
        ),
      );
    });
  }
}
