import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/registrationProcessAdminBloc.dart';
import 'package:voting_flutter/api/globals.dart' as global;
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:intl/intl.dart';

import 'package:voting_flutter/blocs/states.dart';

final _dateFormater = DateFormat('HH:mm:ss');

class RegistrationNotStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 250,
          child: RegistrationClockWidget(
            fontSize: 100,
          ),
        ),
      ],
    );
  }
}

class RegistrationEnded extends StatelessWidget {
  final RegistrationProcess registrationProcess;

  RegistrationEnded({required this.registrationProcess});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // _submitButton(),
        SizedBox(
            height: 250,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: 'Всего     ',
                ),
                WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.people_outline,
                      color: Colors.grey,
                      size: 80,
                    )),
                TextSpan(
                  text: ' ${registrationProcess.total_count}',
                ),
              ]),
              style: TextStyle(fontSize: 100, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
        // Row(
        //  mainAxisAlignment:
        //      MainAxisAlignment.start,
        //  children: [
        //    _endRegistrationButton(),
        //  ],
        //),
      ],
    );
  }
}

class RegistrationInProgress extends StatelessWidget {
  final int total_registered;

  RegistrationInProgress({required this.total_registered});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Зарегистрировано:',
            style: TextStyle(color: Colors.white, fontSize: 60)),
        SizedBox(
          height: 250,
          child: Text('${total_registered}',
              style: TextStyle(color: Colors.white, fontSize: 160)),
        ),
      ],
    );
  }
}

class RegistrationClockWidget extends StatelessWidget {
  final double fontSize;

  const RegistrationClockWidget({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final registrationstate =
        context.watch<RegistrationProcessAdminBloc>().state;
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 1000)),
      builder: (context, snapshot) {
        if (registrationstate.msValue != null &&
            registrationstate.msValue!.isStarted) {
          var _difference = DateTime.now()
              .difference(registrationstate.msValue!.value)
              .inMilliseconds;
          // print('${_difference}');
          if (registrationstate.requestStatus is LoadedState) {
            if (_difference > global.msInterval &&
                registrationstate.msValue!.isStarted != false &&
                registrationstate.isNeedFocus) {
              print('Go Start or End from Registrating');
              context.read<RegistrationProcessAdminBloc>().add(
                  StartMillisecondsChanged(
                      msValue:
                          Difference(isStarted: false, value: DateTime.now())));
              if (registrationstate.registrationProcess!.start_date == null &&
                  registrationstate.registrationProcess!.end_date == null) {
                context
                    .read<RegistrationProcessAdminBloc>()
                    .add(StartRegistrationProcessEvent());
              } else if (registrationstate.registrationProcess!.start_date !=
                      null &&
                  registrationstate.registrationProcess!.end_date == null) {
                context
                    .read<RegistrationProcessAdminBloc>()
                    .add(CompleteRegistrationProcessEvent());
              }
              // context
              //    .read<RegistrationProcessAdminBloc>()
              //    .add(StartMillisecondsChanged(msValue: startValue + global.msInterval));
            } else {
              context.read<RegistrationProcessAdminBloc>().add(
                  StartMillisecondsChanged(msValue: registrationstate.msValue!));
            }
          }
        }
        return Text(_dateFormater.format(DateTime.now()),
            style: TextStyle(color: Colors.white, fontSize: fontSize));
      },
    );
  }
}

class RegisterProcessStateCard extends StatelessWidget {
  final RegistrationProcess registrationProcess;

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
        child: Padding(
            padding: EdgeInsets.all(6.0),
            child: (registrationProcess.start_date == null &&
                    registrationProcess.end_date == null)
                ? Text('Ожидание регистрации',
                    style: TextStyle(color: Colors.white, fontSize: 30))
                : (registrationProcess.start_date != null &&
                        registrationProcess.end_date == null)
                    ? Text('Идет регистрация',
                        style: TextStyle(color: Colors.white, fontSize: 30))
                    : Text('Регистрация завершена',
                        style: TextStyle(color: Colors.white, fontSize: 30))));
  }
}
