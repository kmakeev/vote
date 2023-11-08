import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/navMainScreen.dart';
import 'package:voting_flutter/blocs/userMeetingBloc.dart';
import 'package:voting_flutter/blocs/votingProcessUserBlock.dart';
import 'package:voting_flutter/screens/user/myTabBarChildren.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/blocs/registrationBallotBloc.dart';
import 'package:voting_flutter/blocs/registrationProcessUserBloc.dart';
import 'package:voting_flutter/WebSocket/websocketMng.dart';
import 'package:voting_flutter/api/globals.dart' as global;
import 'package:voting_flutter/screens/all/widgets.dart';

import '../../blocs/votingBallotBloc.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final mainstate = context.watch<NavigatorMainScreenBloc>().state;
      final state = context.watch<UserMeetingBloc>().state;
      final registrationProcessState =
          context.watch<RegistrationProcessUserBloc>().state;
      final votingProcessState = context.watch<VoteProcessUserBloc>().state;
      final registrationBallotState =
          context.watch<RegistrationBallotBloc>().state;
      final voteBallotState = context.watch<RegistrationBallotBloc>().state;
      final loadingstatus = state.requestStatus;
      if ((mainstate is ShowUserScreenState) &&
          (loadingstatus is LoadedState) &&

          ///Необходимо для выхода состояния из InitState
          // (state.meeting!.isRequiredRegistration) &&
          (registrationProcessState.requestStatus is InitState)) {
        context.read<RegistrationProcessUserBloc>().add(
            InitRegistrationProcessEvent(
                registrationProcess: state.meeting!.registrationProcess,
                isNeedFocus: state.meeting!.isRequiredRegistration));
      }
      if ((mainstate is ShowUserScreenState) &&
          (loadingstatus is LoadedState) &&
          (votingProcessState.requestStatus is InitState)) {
        context.read<VoteProcessUserBloc>().add(InitVotingProcessEvent(
            votingProcesses: state.meeting!.votingProcess,
            indexActiveVotingProcess: 0));
      }

      if (mainstate is ShowUserScreenState &&
          loadingstatus is LoadedState &&
          registrationBallotState.requestStatus is InitState)
        context.read<RegistrationBallotBloc>().add(InitRegistrationBallotEvent(
            registrationBallot:
                state.meeting!.registrationProcess.registrationBallot));
      /* if (mainstate is ShowUserScreenState &&
          loadingstatus is LoadedState &&
          voteBallotState.requestStatus is InitState) {
        print('Need to Init BallotState with id ${state.meeting!.votingProcess[votingProcessState
            .indexActiveVotingProcess].voteBallot!.id}');
        context.read<VoteBallotBloc>().add(InitVoteBallotEvent(
          voteBallot_id: state.meeting!.votingProcess[votingProcessState
              .indexActiveVotingProcess].voteBallot!.id,
          //allAnswersCount: state.meeting!.votingProcess[0].answers.length
        ));
      }

       */

      if ((mainstate is ShowUserScreenState) &&
          (loadingstatus is LoadedState) &&
          (votingProcessState.requestStatus is InitState)) {
        final websocketmanager = new WebsocketManager(context);
        websocketmanager.connect();
        Timer.periodic(const Duration(seconds: 15), (timer) {
          print('Ping WS');
          websocketmanager.ping();
        });
      }

      var _tabLength = 1;
      if (mainstate is ShowUserScreenState) {
        if (loadingstatus is LoadedState) {
          _tabLength = state.meeting!.votingProcess.length;
          if (state.meeting!.isRequiredRegistration) {
            _tabLength += 1;
          }
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
                        if (loadingstatus is FailedState &&
                            mainstate is! ShowPasswordRestoreScreenFormState)
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
                            (registrationProcessState.requestStatus
                                    is! InitState ||
                                votingProcessState.requestStatus is! InitState))
                          Expanded(child: MyTabBarChildren()),
                      ]),
                ))),
      );
    });
  }
}
