import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/navMainScreen.dart';
import 'package:voting_flutter/blocs/userMeetingBloc.dart';
import 'package:voting_flutter/back/userMeetingWidget.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/blocs/registrationBallotBloc.dart';
import 'package:voting_flutter/blocs/registrationProcessUserBloc.dart';
import 'package:voting_flutter/back/userScreenWidget.dart';
import 'package:voting_flutter/WebSocket/websocketMng.dart';
import 'package:voting_flutter/api/globals.dart' as global;

/*
void displayDialog(BuildContext context, String title, String text) =>
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final mainstate = context.watch<NavigatorMainScreenBloc>().state;
      final state = context.watch<UserMeetingBloc>().state;
      final registrationProcessState =
          context.watch<RegistrationProcessBloc>().state;
      final registrationBallotState =
          context.watch<RegistrationBallotBloc>().state;
      final loadingstatus = state.requestStatus;
      if (mainstate is ShowUserScreenState) if (loadingstatus is LoadedState) if (state
          .meeting!
          .isRequiredRegistration) if (registrationProcessState.requestStatus is InitState) {
        context.read<RegistrationProcessBloc>().add(
            InitRegistrationProcessEvent(
                registrationProcess: state.meeting!.registrationProcess));
        final websocketmanager = new WebsocketManager(context);
        websocketmanager.connect();
      }
      if (mainstate is ShowUserScreenState &&
          loadingstatus is LoadedState &&
          registrationBallotState.requestStatus is InitState)
        context.read<RegistrationBallotBloc>().add(InitRegistrationBallotEvent(
            registrationBallot:
            state.meeting!.registrationProcess.registrationBallot));
      var _tabLength = 1;
      if (mainstate is ShowUserScreenState) {
        if (loadingstatus is LoadedState) {
          _tabLength = state.meeting!.votingProcess.length;
          if (state.meeting!.isRequiredRegistration) _tabLength += 1;
        }
      }
      return DefaultTabController(
        length: _tabLength,
        child: MaterialApp(
            home: Scaffold(
                backgroundColor: global.backgroundColor,
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
                        if (loadingstatus is FailedState && mainstate is! ShowPasswordRestoreScreenFormState)
                          Text(
                              'Произошла ошибка! ${loadingstatus.error} \n Попробуйте обновить страницу клавишей F5',
                              style:
                              TextStyle(color: Colors.white, fontSize: 40)),
                        if (mainstate is ShowUserScreenState &&
                            loadingstatus is! LoadingState &&
                            registrationProcessState.requestStatus
                            is! InitState)
                          TabPageSelector(),
                        if (mainstate is ShowUserScreenState &&
                            loadingstatus is! LoadingState &&
                            registrationProcessState.requestStatus
                            is! InitState)
                          Expanded(
                              child: TabBarView(children: [
                                if (state.meeting!.isRequiredRegistration)
                                  RegistrationUserProcessCards(
                                      registrationProcess: registrationProcessState
                                          .registrationProcess!),
                                for (var record in state.meeting!.votingProcess)
                                  VotingUserProcessCards(votingProcess: record),
                              ])),
                      ]),
                ))),
      );
    });
  }
}
*/