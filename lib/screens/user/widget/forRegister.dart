import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/registrationBallotBloc.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:voting_flutter/api/globals.dart' as global;

class RegisterProcessCards_ extends StatelessWidget {
  final RegistrationBallot registrationBallot;

  const RegisterProcessCards_({required this.registrationBallot});

  @override
  Widget build(BuildContext context) {
    return Container(
        // shadowColor: Colors.white,
        color: global.backgroundColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(4, 80, 4, 4),
          child: Center(
              child: Text(
                  registrationBallot!.isRegistered
                      ? 'Вы зарегистрировались!'
                      : 'Для регистрации нажмите кнопку:',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: registrationBallot!.isRegistered ? Colors.green : Colors.white, fontSize: 50))),
        ));
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

class RegistrationUserInProgress extends StatelessWidget {
  final int total_registered;
  final RegistrationBallot registrationBallot;

  RegistrationUserInProgress(
      {required this.total_registered, required this.registrationBallot});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _submitButton(),
        SizedBox(
          height: 30,
        ),
        Divider(
          thickness: 2,
          endIndent: 10.0,
          indent: 10.0,
          color: Colors.grey,
        ),
        SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height: 80,
                    child: registrationBallot.isRegistered
                        ? Text(
                            'Результаты появятся на экране когда организатор завершит регистрацию',
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 20))
                        : Text('Вы не зарегистрировались.',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.white, fontSize: 32))),
                Text('Зарегистировалось всего - ${total_registered}',
                    style: TextStyle(color: Colors.white, fontSize: 30)),
              ],
            )),
        Divider(
          thickness: 2,
          endIndent: 10.0,
          indent: 10.0,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _submitButton() {
    return BlocBuilder<RegistrationBallotBloc, RegistrationBallotState>(
        builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? SizedBox(
              width: 350,
              height: 100,
              child: SpinKitThreeBounce(color: Colors.white54, size: 80),
            )
          : SizedBox(
              width: 350,
              height: 100,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.blueGrey.withOpacity(0.9),
                  ),
                  onPressed: state.registrationBallot!.isRegistered
                      ? null
                      : () {
                          context
                              .read<RegistrationBallotBloc>()
                              .add(IsRegisteredChanged(isRegistered: true));
                          context
                              .read<RegistrationBallotBloc>()
                              .add(SubmitRegistrationBallotEvent());
                        },
                  child: Text('Зарегистрироваться',
                      style: TextStyle(color: Colors.white, fontSize: 30))));
    });
  }
}

class UserRegistrationEnded extends StatelessWidget {
  final OnlyMyRegistrationProcess registrationProcess;

  UserRegistrationEnded({required this.registrationProcess});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // _submitButton(),
        SizedBox(
            height: 250,
            width: 600,
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
