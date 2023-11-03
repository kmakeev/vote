import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/navMainScreen.dart';
import 'package:voting_flutter/blocs/adminMeetingBloc.dart';
import 'package:voting_flutter/screens/admin/adminRegistrationProcessScreen.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/blocs/registrationProcessAdminBloc.dart';
import 'package:voting_flutter/back/userScreenWidget.dart';
import 'package:voting_flutter/WebSocket/websocketMng.dart';

import 'package:voting_flutter/blocs/votingProcessAdminBloc.dart';
import 'package:voting_flutter/screens/admin/adminVotingProcessesScreen.dart';
/*
class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final mainstate = context.watch<NavigatorMainScreenBloc>().state;
      final state = context.watch<AdminMeetingBloc>().state;
      final registrationProcessState =
          context.watch<RegistrationProcessAdminBloc>().state;
      final votingProcessState = context.watch<VotingProcessAdminBloc>().state;
      // final registrationBallotState =
      //    context.watch<RegistrationBallotBloc>().state;
      final loadingstatus = state.requestStatus;
      if (mainstate is ShowUserScreenState) if (loadingstatus is LoadedState) if (state
          .meeting!
          .isRequiredRegistration) if (registrationProcessState.requestStatus is InitState) {
        context.read<RegistrationProcessAdminBloc>().add(
            InitRegistrationProcessEvent(
                registrationProcess: state.meeting!.registrationProcess));
      }
      if (mainstate is ShowUserScreenState) if (loadingstatus
      is LoadedState) if (votingProcessState.requestStatus is InitState) {
        context.read<VotingProcessAdminBloc>().add(InitVotingProcessEvent(
            votingProcesses: state.meeting!.votingProcess,
            indexActiveVotingProcess: 0));
      }
      //    votingProcess: meetingstate
      //        .meeting!.votingProcess[controller.index + withoutRegister]));
      // if (mainstate is ShowUserScreenState &&
      //    loadingstatus is LoadedState &&
      //    registrationBallotState.requestStatus is InitState)
      //  context.read<RegistrationBallotBloc>().add(InitRegistrationBallotEvent(
      //      registrationBallot:
      //      state.meeting!.registrationProcess.registrationBallot));
      if (mainstate is ShowUserScreenState) if (loadingstatus
      is LoadedState) if (votingProcessState.requestStatus is InitState) {
        final websocketmanager = new WebsocketManager(context);
        websocketmanager.connect();
      }
      var _tabLength = 1;
      var _withoutRegister = 0;
      if (mainstate is ShowUserScreenState) {
        if (loadingstatus is LoadedState) {
          _tabLength = state.meeting!.votingProcess.length;
          if (state.meeting!.isRequiredRegistration) {
            _tabLength += 1;
            _withoutRegister = 1;
          }
        }
      }
      return DefaultTabController(
        length: _tabLength,
        child: MaterialApp(
            home: Scaffold(
                backgroundColor: Color.fromRGBO(20, 30, 46, 1),
                body: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (mainstate is WaitMainScreenState) WaitWidget(),
                        if (mainstate is ShowUserScreenState &&
                            loadingstatus is LoadingState &&
                            registrationProcessState.requestStatus is InitState)
                          WaitWidget(),
                        if (mainstate is ShowPasswordRestoreScreenFormState)
                          RestorePasswordWidget(),
                        if (mainstate is ShowUserScreenState &&
                            loadingstatus is! LoadingState &&
                            registrationProcessState.requestStatus
                            is! InitState)
                          TabPageSelector(),
                        if (mainstate is ShowUserScreenState &&
                            loadingstatus is! LoadingState &&
                            (registrationProcessState.requestStatus
                            is! InitState ||
                                votingProcessState.requestStatus is! InitState))
                          Expanded(
                              child: TabBarView(children: [
                                if (state.meeting!.isRequiredRegistration)
                                  RegistrationProcessCards(
                                      registrationProcess: registrationProcessState
                                          .registrationProcess!),
                                for (var index = 0;
                                index < state.meeting!.votingProcess.length;
                                index++)
                                  VotingProcessCards(
                                    indexVotingProcess: index,
                                    withoutRegister: _withoutRegister,
                                  ),
                              ])),
                      ]),
                ))),
      );
    });
  }
}
*/