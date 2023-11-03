import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/adminMeetingBloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:voting_flutter/blocs/registrationProcessAdminBloc.dart';
import 'package:voting_flutter/blocs/states.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:voting_flutter/api/globals.dart' as global;

/*

class RegistrationProcessCards extends StatelessWidget {
  final RegistrationProcess registrationProcess;


  RegistrationProcessCards({required this.registrationProcess});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final FocusNode focusNode = FocusNode();
      final meetingstate = context.watch<AdminMeetingBloc>().state;
      final registrationstate =
          context.watch<RegistrationProcessAdminBloc>().state;
      // final registrationBallotstate =
      //    context.watch<RegistrationBallotBloc>().state;
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
              .read<RegistrationProcessAdminBloc>()
              .add(ReloadRegistrationProcessEvent());
      } //before voting stops
      // final keyboardmanager = new KeyboardManager(context).connect();
      double _cyrcleProgress = 0.0;
      if (registrationstate.msValue != null &&
          registrationstate.msValue!.isStarted) {
        _cyrcleProgress = DateTime.now()
                .difference(registrationstate.msValue!.value)
                .inMilliseconds /
            global.msInterval;
        _cyrcleProgress = (_cyrcleProgress > 1.0) ? 1 : _cyrcleProgress;
        // print(_cyrcleProgress);
      }

      return RawKeyboardListener(
          focusNode: focusNode,
          autofocus: registrationstate.isNeedFocus,
          onKey: (RawKeyEvent rawkey) {
            try {
              String _key = rawkey.data.keyLabel.toString();
              print('Key ${_key} DOWN, ${rawkey.repeat} ');
              print('Checked Key ${registrationstate.isNeedFocus} ');
              if (_key == global.keyByStart) {
                if (rawkey is RawKeyDownEvent && !rawkey.repeat) {
                  // print('Key ${_key} DOWN, ${rawkey.repeat} ');
                  context.read<RegistrationProcessAdminBloc>().add(
                      StartMillisecondsChanged(
                          msValue: Difference(
                              isStarted: true, value: DateTime.now())));
                }
                if (rawkey is RawKeyUpEvent && !rawkey.repeat) {
                  // print('Key ${_key} UP, ${rawkey.repeat} ');
                  context.read<RegistrationProcessAdminBloc>().add(
                      StartMillisecondsChanged(
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
              child: registrationstate.formStatus is FormSubmitting
                  ? Center(
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
                                (registrationstate
                                            .registrationProcess!.start_date !=
                                        null)
                                    ? RegistrationClockWidget(
                                        fontSize: 30,
                                      )
                                    : SizedBox(
                                        height: 30,
                                      ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularPercentIndicator(
                                  radius: 20,
                                  lineWidth: 4,
                                  percent: registrationstate.isNeedFocus ? _cyrcleProgress : 0.0,
                                  animation: false,
                                  backgroundColor:
                                      Color.fromRGBO(20, 30, 46, 1),
                                  progressColor: Colors.white38,
                                  center: registrationstate.registrationProcess!
                                                  .start_date ==
                                              null &&
                                          registrationstate.registrationProcess!
                                                  .end_date ==
                                              null
                                      ? new Icon(Icons.play_arrow,
                                          color: Colors.lightGreen, size: 30)
                                      : registrationstate.registrationProcess!
                                                      .start_date !=
                                                  null &&
                                              registrationstate
                                                      .registrationProcess!
                                                      .end_date ==
                                                  null
                                          ? new Icon(Icons.stop,
                                              color: Colors.lightGreen,
                                              size: 30)
                                          : new Icon(Icons.stop,
                                              color: Colors.grey, size: 30),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
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
                              Container(
                                  // width: 600,
                                  child: registrationstate.registrationProcess!
                                                  .start_date !=
                                              null &&
                                          registrationstate.registrationProcess!
                                                  .end_date ==
                                              null
                                      ? Expanded(
                                          child: RegistrationInProgress(
                                          total_registered: total_registered,
                                        ))
                                      : registrationstate.registrationProcess!
                                                      .start_date ==
                                                  null &&
                                              registrationstate
                                                      .registrationProcess!
                                                      .end_date ==
                                                  null
                                          ? Expanded(
                                              child: RegistrationNotStarted())
                                          : Expanded(
                                              child: RegistrationEnded(
                                                  registrationProcess:
                                                      registrationstate
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
          ));
    });
  }
}


 */

