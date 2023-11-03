import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/screens/user/userRegistrationProcessScreen.dart';
import 'package:voting_flutter/screens/user/userVotingProcessesScreen.dart';
import 'package:voting_flutter/blocs/userMeetingBloc.dart';
import 'package:voting_flutter/blocs/registrationProcessUserBloc.dart';
import 'package:voting_flutter/blocs/votingProcessUserBlock.dart';

import 'package:voting_flutter/blocs/votingBallotBloc.dart';

class MyTabBarChildren extends StatelessWidget {
  const MyTabBarChildren({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // final FocusNode focusNode = FocusNode();
      final meetingstate = context.watch<UserMeetingBloc>().state;
      final registrationstate =
          context.watch<RegistrationProcessUserBloc>().state;
      final votingstate = context.watch<VoteProcessUserBloc>().state;
      final loadingstatus = registrationstate.requestStatus;
      final TabController controller = DefaultTabController.of(context);

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
              .read<RegistrationProcessUserBloc>()
              .add(ReloadRegistrationProcessEvent());
          controller.animateTo(0); //Goto Registration Tab
        }

        if ((votingstate.message!.voteProc!.isRunning == false) ||
            (votingstate.message!.voteProc!.isStopping == false)) {
          var withoutRegister = meetingstate.meeting!.isRequiredRegistration ? 1 : 0;
          var changedindex = 0;
          print(
              'WS Message has end/start signal id - ${votingstate.message!.voteProc!.id_voting}');
          if (votingstate.message!.voteProc!.id_voting != null) {
            for (var index = 0;
                index < votingstate.votingProcesses.length;
                index++) {
              if (votingstate.votingProcesses[index].id ==
                  votingstate.message!.voteProc!.id_voting) {
                changedindex = index;
                print('Animate to $changedindex tab');
                controller.animateTo(index + withoutRegister);
              }
            }
          }
          context.read<VoteProcessUserBloc>().add(ReloadVotingProcessEvent(
              index_votingProcess: changedindex));
          // print('WS Message has reload VoteBallot signal');
          // context.read<VoteBallotBloc>().add(ToInitVoteBallotEvent());
        }
      }

      return TabBarView(children: [
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
      ]);
    });
  }
}
