import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voting_flutter/blocs/userMeetingBloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:voting_flutter/blocs/registrationProcessUserBloc.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/api/globals.dart' as global;
import 'package:voting_flutter/screens/user/widget/forRegister.dart';
import 'package:voting_flutter/blocs/registrationBallotBloc.dart';

class RegistrationProcessCards extends StatelessWidget {
  final OnlyMyRegistrationProcess registrationProcess;

  RegistrationProcessCards({required this.registrationProcess});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final meetingstate = context.watch<UserMeetingBloc>().state;
      final registrationstate =
          context.watch<RegistrationProcessUserBloc>().state;
      final registrationBallotstate =
          context.watch<RegistrationBallotBloc>().state;
      final loadingstatus = registrationstate.requestStatus;
      var total_registered;
      if (loadingstatus is LoadedState) {
        total_registered = registrationstate.registrationProcess!.total_count;
        if (registrationstate.message != null) {
          if (registrationstate.message!.regProc!.totalCount > total_registered)
            total_registered = registrationstate.message!.regProc!.totalCount;
        }
        if ((registrationstate.registrationProcess!.end_date == null &&
                registrationstate.message!.regProc!.isRunning == false) ||
            (registrationstate.registrationProcess!.start_date == null &&
                registrationstate.message!.regProc!.isStopping == false))
          context
              .read<RegistrationProcessUserBloc>()
              .add(ReloadRegistrationProcessEvent());
      } //before voting stops
      return Card(
        color: global.backgroundColor,
        shadowColor: Colors.white,
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
                          Expanded(
                              flex: 2,
                              child: registrationstate.registrationProcess!
                                              .start_date !=
                                          null &&
                                      registrationstate
                                              .registrationProcess!.end_date !=
                                          null
                                  ? Container()
                                  : RegisterProcessCards_(
                                      registrationBallot:
                                          registrationBallotstate
                                              .registrationBallot!,
                                    )),
                          Expanded(
                              flex: 7,
                              child: Container(
                                  width: 600,
                                  child: registrationstate.registrationProcess!
                                                  .start_date !=
                                              null &&
                                          registrationstate.registrationProcess!
                                                  .end_date ==
                                              null
                                      ? RegistrationUserInProgress(
                                          total_registered: total_registered,
                                          registrationBallot:
                                              registrationBallotstate
                                                  .registrationBallot!)
                                      : UserRegistrationEnded(
                                          registrationProcess: registrationstate
                                              .registrationProcess!))),
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
