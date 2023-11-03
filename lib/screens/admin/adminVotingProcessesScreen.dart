import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/adminMeetingBloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voting_flutter/blocs/registrationProcessAdminBloc.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:voting_flutter/api/globals.dart' as global;
import 'package:voting_flutter/screens/admin/widget/forVoting.dart';
import 'package:voting_flutter/blocs/votingProcessAdminBloc.dart';
import 'package:voting_flutter/models/models.dart';

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
      final meetingstate = context.watch<AdminMeetingBloc>().state;
      final votingstate = context.watch<VotingProcessAdminBloc>().state;
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

                ///Stop all MSValue
                forControllerContext.read<RegistrationProcessAdminBloc>().add(
                    StartMillisecondsChanged(
                        msValue: Difference(
                            isStarted: false, value: DateTime.now())));
                forControllerContext
                    .read<VotingProcessAdminBloc>()
                    .add(StartMillisecondsVotingChanged(
                        msValue: Difference(
                      isStarted: false,
                      value: DateTime.now(),
                    )));
                if (meetingstate.meeting!.isRequiredRegistration)
                  forControllerContext.read<RegistrationProcessAdminBloc>().add(
                      IsNeedFocusChanged(
                          newFocus: current_index == -1 ? true : false));
                forControllerContext.read<VotingProcessAdminBloc>().add(
                    IndexActiveVotingProcessChangedEvent(
                        indexActiveVotingProcess: current_index));
              } else
                print('Wisget context IS NOT mounted');
            }
          }
        });
      }

      var total_registered;
      if (loadingstatus is LoadedState) {
        total_registered = votingProcess!.total_count;
        if (votingstate.message != null) {
          if (votingstate.message!.voteProc!.totalCount > total_registered)
            total_registered = votingstate.message!.voteProc!.totalCount;
        }
      }
      //before voting stops
      // final keyboardmanager = new KeyboardManager(context).connect();
      double _cyrcleProgress = 0.0;
      if (votingstate.msValue != null && votingstate.msValue!.isStarted) {
        _cyrcleProgress = DateTime.now()
                .difference(votingstate.msValue!.value)
                .inMilliseconds /
            global.msInterval;
        _cyrcleProgress = (_cyrcleProgress > 1.0) ? 1 : _cyrcleProgress;
        // print(_cyrcleProgress);
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (votingProcess!.start_date != null &&
                                    votingProcess!.end_date == null)

                                /// Для таймера от начала
                                ? VotingClockWidget(
                                    fontSize: 30,
                                    indexVotingProcess: indexVotingProcess,
                                    isTimer: true,
                                  )
                                : VotingClockWidget(
                                    fontSize: 30,
                                    indexVotingProcess: indexVotingProcess,
                                  ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 20,
                              lineWidth: 4,
                              percent: ((indexVotingProcess ==
                                          votingstate
                                              .indexActiveVotingProcess) &&
                                      (votingProcess!.start_date == null ||
                                          votingProcess!.end_date == null))
                                  ? _cyrcleProgress
                                  : 0.0,
                              animation: false,
                              backgroundColor: global.backgroundColor,
                              progressColor: Colors.white38,
                              center: votingProcess!.start_date == null &&
                                      votingProcess!.end_date == null
                                  ? const Icon(Icons.play_arrow,
                                      color: Colors.lightGreen, size: 30)
                                  : votingProcess!.start_date != null &&
                                          votingProcess!.end_date == null
                                      ? const Icon(Icons.stop,
                                          color: Colors.lightGreen, size: 30)
                                      : const Icon(Icons.stop,
                                          color: Colors.grey, size: 30),
                            ),
                            SizedBox(
                              width: 30,
                            ),
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
                                      total_registered: total_registered,
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
