import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/adminMeetingBloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voting_flutter/blocs/registrationProcessAdminBloc.dart';
import 'package:voting_flutter/blocs/registrationProcessforAllBloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:voting_flutter/api/globals.dart' as global;
import 'package:voting_flutter/blocs/votingProcessAdminBloc.dart';

/*
class VotingProcessCards extends StatelessWidget {
  final int indexVotingProcess;
  final int withoutRegister;

  VotingProcessCards(
      {required this.indexVotingProcess, required this.withoutRegister});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final FocusNode focusNode = FocusNode();
      final int activeFocusIndex = 0;
      final meetingstate = context.watch<AdminMeetingBloc>().state;

      final votingstate = context.watch<VotingProcessAdminBloc>().state;
      final votingProcess = votingstate.votingProcesses[indexVotingProcess];
      final loadingstatus = votingstate.requestStatus;
      var total_registered;
      if (loadingstatus is LoadedState) {
        total_registered = votingProcess!.total_count;
        if (votingstate.message != null) {
          if (votingstate.message!.voteProc!.totalCount > total_registered)
            total_registered = votingstate.message!.voteProc!.totalCount;
        }
        if ((votingProcess!.end_date == null &&
                votingstate.message!.voteProc!.isRunning == false) ||
            (votingProcess!.start_date == null &&
                votingstate.message!.voteProc!.isStopping == false)) {
          context
              .read<VotingProcessAdminBloc>()
              .add(ReloadVotingProcessEvent());
        }
      }
      final TabController controller = DefaultTabController.of(context);

      //controller.removeListener(() {});
      if (!controller.hasListeners) {
        controller.addListener(() {
          if (!controller.indexIsChanging) {
            var current_index = controller.index - withoutRegister;
            print("Change to index ${current_index}");
            context.read<RegistrationProcessAdminBloc>().add(IsNeedFocusChanged(
                newFocus: current_index == -1 ? true : false));
            context.read<VotingProcessAdminBloc>().add(
                IndexActiveVotingProcessChangedEvent(
                    indexActiveVotingProcess: current_index));

          }
        });
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
      return RawKeyboardListener(
          focusNode: focusNode,
          autofocus: indexVotingProcess == votingstate.indexActiveVotingProcess ? true : false,
          onKey:
              (RawKeyEvent rawkey) {
            try {
              String _key = rawkey.data.keyLabel.toString();
              print('Key ${_key} DOWN, ${rawkey.repeat} ');
              print('Checked Key ${indexVotingProcess} , ${votingstate.indexActiveVotingProcess} ');
              if (_key == global.keyByStart &&
                  indexVotingProcess == votingstate.indexActiveVotingProcess) {
                if (rawkey is RawKeyDownEvent && !rawkey.repeat) {
                  context.read<VotingProcessAdminBloc>().add(
                      StartMillisecondsVotingChanged(
                          msValue: Difference(
                              isStarted: true, value: DateTime.now())));
                }
                if (rawkey is RawKeyUpEvent && !rawkey.repeat) {
                  // print('Key ${_key} UP, ${rawkey.repeat} ');
                  context.read<VotingProcessAdminBloc>().add(
                      StartMillisecondsVotingChanged(
                          msValue: Difference(
                              isStarted: false, value: DateTime.now())));
                }
                // context
                //    .read<RegistrationProcessBloc>()
                //    .add(WSMessageChanged(message: _message));
              }
            } on Exception catch (e) {
              print(e);
            }
          },
          child: Card(
            color: Color.fromRGBO(20, 30, 46, 1),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: votingstate.formStatus is FormSubmitting
                  ? const Center(
                      child:
                          SpinKitThreeBounce(color: Colors.white54, size: 160),
                    )
                  : Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                (votingProcess!.start_date != null)
                                    ? VotingClockWidget(
                                        fontSize: 30,
                                        indexVotingProcess: indexVotingProcess,
                                      )
                                    : const SizedBox(
                                        height: 30,
                                      ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularPercentIndicator(
                                  radius: 20,
                                  lineWidth: 4,
                                  percent: indexVotingProcess ==
                                          votingstate.indexActiveVotingProcess
                                      ? _cyrcleProgress
                                      : 0.0,
                                  animation: false,
                                  backgroundColor:
                                      Color.fromRGBO(20, 30, 46, 1),
                                  progressColor: Colors.white38,
                                  center: votingProcess!.start_date == null &&
                                          votingProcess!.end_date == null
                                      ? const Icon(Icons.play_arrow,
                                          color: Colors.lightGreen, size: 30)
                                      : votingProcess!.start_date != null &&
                                              votingProcess!.end_date == null
                                          ? const Icon(Icons.stop,
                                              color: Colors.lightGreen,
                                              size: 30)
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
                                          child: RegistrationInProgress(
                                          total_registered: total_registered,
                                        ))
                                      : votingProcess!.start_date == null &&
                                              votingProcess!.end_date == null
                                          ? Expanded(
                                              child: VotingNotStarted(
                                              indexVotingProcess:
                                                  indexVotingProcess,
                                            ))
                                          : Expanded(
                                              child: VotingEnded(
                                                  votingProcess:
                                                      votingProcess!))),
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
          ));
    });
  }
}

class VotingProcessCards_ extends StatelessWidget {
  final VotingProcess votingProcess;

  const VotingProcessCards_({required this.votingProcess});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(20, 30, 46, 1),
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: Text('${votingProcess.question}',
                  style: TextStyle(color: Colors.white, fontSize: 50)))),
    );
  }
}
*/