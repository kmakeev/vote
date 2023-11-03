import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voting_flutter/blocs/adminMeetingBloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:voting_flutter/blocs/registrationProcessAdminBloc.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/api/globals.dart' as global;
import 'package:voting_flutter/blocs/votingProcessAdminBloc.dart';
import 'package:voting_flutter/screens/admin/adminRegistrationProcessScreen.dart';
import 'package:voting_flutter/screens/admin/adminVotingProcessesScreen.dart';

class MyTabBarChildren extends StatelessWidget {
  const MyTabBarChildren({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final FocusNode focusNode = FocusNode();
      final meetingstate = context.watch<AdminMeetingBloc>().state;
      final registrationstate =
          context.watch<RegistrationProcessAdminBloc>().state;
      final votingstate = context.watch<VotingProcessAdminBloc>().state;
      final loadingstatus = registrationstate.requestStatus;
      var total_registered;
      if (loadingstatus is LoadedState) {
        total_registered = registrationstate.registrationProcess!.total_count;
        if (registrationstate.message != null) {
          if (registrationstate.message!.regProc!.totalCount >
              total_registered) {
            total_registered = registrationstate.message!.regProc!.totalCount;
          }
        }
        if ((registrationstate.registrationProcess!.end_date == null &&
                registrationstate.message!.regProc!.isRunning == false) ||
            (registrationstate.registrationProcess!.start_date == null &&
                registrationstate.message!.regProc!.isStopping == false)) {
          context
              .read<RegistrationProcessAdminBloc>()
              .add(ReloadRegistrationProcessEvent());
        }
        if ((votingstate.message!.voteProc!.isRunning == false) ||
            (votingstate.message!.voteProc!.isStopping == false)) {
          print('WS Message has end/start signal');
          context
              .read<VotingProcessAdminBloc>()
              .add(ReloadVotingProcessEvent(id_votingProcess: votingstate.message!.voteProc!.id_voting));
        }
      }
      final TabController controller = DefaultTabController.of(context);

      return RawKeyboardListener(
          focusNode: focusNode,
          autofocus: true,
          onKey: (RawKeyEvent rawkey) {
            try {
              String _key = rawkey.data.keyLabel.toString();
              // print('Key ${_key}, ${rawkey.repeat} ');
              //print(
              //    'Checked states in regSate ${registrationstate.isNeedFocus}; in votState ${votingstate.indexActiveVotingProcess} ');
              if (_key == global.keyByStart) {
                if (rawkey is RawKeyDownEvent && !rawkey.repeat) {
                  // print('Key ${_key} DOWN, ${rawkey.repeat} ');
                  /// Start/Stop for registration process only not ended registration
                  if (registrationstate.isNeedFocus &&
                      (registrationstate.registrationProcess!.start_date ==
                              null ||
                          registrationstate.registrationProcess!.end_date ==
                              null) &&
                      registrationstate.msValue != null &&
                      registrationstate.msValue!.isStarted != true) {
                    print('Accept start MillisecondsChanged');
                    context.read<RegistrationProcessAdminBloc>().add(
                        StartMillisecondsChanged(
                            msValue: Difference(
                                isStarted: true, value: DateTime.now())));
                  }

                  /// Проверяем на возможность запуска голосования при наличии уже запущенных
                  /// Проверяем что запуск не возможен для уже завершенных
                  if (!registrationstate.isNeedFocus) {
                    bool isOtherVoteStarted = false;
                    bool isThisVoteEnded = (votingstate
                                .votingProcesses[
                                    votingstate.indexActiveVotingProcess]
                                .start_date !=
                            null &&
                        votingstate
                                .votingProcesses[
                                    votingstate.indexActiveVotingProcess]
                                .end_date !=
                            null);
                    for (var index = 0;
                        index < votingstate.votingProcesses.length;
                        index++) {
                      if (votingstate.votingProcesses[index].start_date !=
                              null &&
                          votingstate.votingProcesses[index].end_date == null &&
                          index != votingstate.indexActiveVotingProcess) {
                        isOtherVoteStarted = true;
                        break;
                      }
                    }
                    if (((registrationstate.registrationProcess!.start_date !=
                                    null &&
                                registrationstate.registrationProcess!
                                        .end_date != //Start/Stop only not ended registration
                                    null) ||
                            !meetingstate.meeting!.isRequiredRegistration) &&
                        !isOtherVoteStarted &&
                        !isThisVoteEnded) {
                      print('Accept start MillisecondsVotingChanged');
                      context.read<VotingProcessAdminBloc>().add(
                          StartMillisecondsVotingChanged(
                              msValue: Difference(
                                  isStarted: true, value: DateTime.now())));
                    }
                  }
                } else if (rawkey is RawKeyUpEvent && !rawkey.repeat) {
                  // print('Key ${_key} UP, ${rawkey.repeat} ');
                  /// Start/Stop for registration process only not ended registration
                  if (registrationstate.isNeedFocus &&
                      (registrationstate.registrationProcess!.start_date ==
                              null ||
                          registrationstate.registrationProcess!.end_date ==
                              null) &&
                      registrationstate.msValue != null &&
                      registrationstate.msValue!.isStarted != false) {
                    print('Accept stop MillisecondsChanged');
                    context.read<RegistrationProcessAdminBloc>().add(
                        StartMillisecondsChanged(
                            msValue: Difference(
                                isStarted: false, value: DateTime.now())));
                  }

                  /// Start/Stop for votings process only registration is ended
                  if (!registrationstate.isNeedFocus &&
                      ((registrationstate.registrationProcess!.start_date !=
                                  null &&
                              registrationstate.registrationProcess!.end_date !=
                                  null) ||
                          !meetingstate.meeting!.isRequiredRegistration) &&
                      registrationstate.msValue != null &&
                      votingstate.msValue!.isStarted != false) {
                    print('Accept stop MillisecondsVotingChanged');
                    context.read<VotingProcessAdminBloc>().add(
                        StartMillisecondsVotingChanged(
                            msValue: Difference(
                                isStarted: false, value: DateTime.now())));
                  }
                }
                // context
                //    .read<RegistrationProcessBloc>()
                //    .add(WSMessageChanged(message: _message));
              }
            } on Exception catch (e) {
              print(e);
            }
          },
          child: TabBarView(children: [
            if (meetingstate.meeting!.isRequiredRegistration)
              RegistrationProcessCards(
                  registrationProcess: registrationstate.registrationProcess!),
            for (var index = 0;
                index < meetingstate.meeting!.votingProcess.length;
                index++)
              VotingProcessCards(
                indexVotingProcess: index,
                withoutRegister:
                    meetingstate.meeting!.isRequiredRegistration ? 1 : 0,
                controller: controller,
                forControllerContext: context,
              ),
          ]));
    });
  }
}
