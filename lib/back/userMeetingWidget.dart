import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/userMeetingBloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/registrationBallotBloc.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:voting_flutter/blocs/registrationProcessUserBloc.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/back/userScreenWidget.dart';
import 'package:voting_flutter/api/globals.dart' as global;

/*

class RegistrationUserProcessCards extends StatelessWidget {
  final OnlyMyRegistrationProcess registrationProcess;

  RegistrationUserProcessCards({required this.registrationProcess});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final meetingstate = context.watch<UserMeetingBloc>().state;
      final registrationstate = context.watch<RegistrationProcessBloc>().state;
      final registrationBallotstate =
          context.watch<RegistrationBallotBloc>().state;
      final loadingstatus = registrationBallotstate.requestStatus;
      var total_registered;
      if (loadingstatus is LoadedState) {
        total_registered = registrationstate.registrationProcess!.total_count;
        if (registrationstate.message != null) {
          if (registrationstate.message!.regProc!.totalCount > total_registered)
            total_registered = registrationstate.message!.regProc!.totalCount;
          if (!registrationBallotstate.registrationBallot!.isRegistered &&
              registrationstate.message!.regProc!.id_registered ==
                  registrationBallotstate.registrationBallot!.id)
            context
                .read<RegistrationBallotBloc>()
                .add(ReloadRegistrationBallotEvent());
          if (registrationstate.registrationProcess!.end_date == null &&
              registrationstate.message!.regProc!.isRunning == false)
            context
                .read<RegistrationProcessBloc>()
                .add(ReloadRegistrationProcessEvent());
        }
      } //before voting stops

      return Card(
        color: global.backgroundColor,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: registrationstate.formStatus is FormSubmitting
              ? Center(
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
                            RegisterProcessStateCard(
                              registrationProcess:
                                  registrationstate.registrationProcess!,
                            ),
                          ]),
                      Container(
                          child: Expanded(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          if (registrationstate
                              .registrationProcess!.start_date !=
                              null)
                          Text(
                              registrationBallotstate
                                      .registrationBallot!.isRegistered
                                  ? 'Вы зарегистрировались!'
                                  : 'Для регистрации нажмите кнопку:',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50)),
                          Container(
                            width: 600,
                            child: registrationstate
                                            .registrationProcess!.start_date !=
                                        null &&
                                    registrationstate
                                            .registrationProcess!.end_date ==
                                        null
                                ? RegistrationUserInProgress(
                                    total_registered: total_registered,
                                    registrationBallot: registrationBallotstate
                                        .registrationBallot!)
                                : UserRegistrationEnded(
                                registrationProcess:
                                registrationstate
                                    .registrationProcess!)),


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


class VotingUserProcessCards extends StatelessWidget {
  final OnlyMyVotingProcess votingProcess;

  const VotingUserProcessCards({required this.votingProcess});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: global.backgroundColor,
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: Text('${votingProcess.question}',
                  style: TextStyle(color: Colors.white, fontSize: 50)))),
    );
  }
}

class RegisterProcessStateCard extends StatelessWidget {
  final OnlyMyRegistrationProcess registrationProcess;

  const RegisterProcessStateCard({required this.registrationProcess});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: (registrationProcess.start_date == null &&
                  registrationProcess.end_date == null)
              ? Colors.orangeAccent
              : (registrationProcess.start_date != null &&
                      registrationProcess.end_date == null)
                  ? Colors.green
                  : Colors.red,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: (registrationProcess.start_date == null &&
                registrationProcess.end_date == null)
            ? Text('Ожидание регистрации',
                style: TextStyle(color: Colors.white, fontSize: 30))
            : (registrationProcess.start_date != null &&
                    registrationProcess.end_date == null)
                ? Text('Идет регистрация',
                    style: TextStyle(color: Colors.white, fontSize: 30))
                : Text('Регистрация завершена',
                    style: TextStyle(color: Colors.white, fontSize: 30)));
  }
}

*/
