import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voting_flutter/blocs/registrationBallotBloc.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/registrationProcessUserBloc.dart';

/*

class WaitWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
          SpinKitThreeBounce(color: Colors.white54, size: 160),
        ])
      ],
    );
  }
}

class RestorePasswordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Необходимо восстановить доступ!',
              style: TextStyle(color: Colors.white, fontSize: 50)),
        ]),
      ],
    );
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
                    style: TextStyle(color: Colors.white, fontSize: 20)),
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

 // for tests
  Widget _endRegistrationButton() {
    return BlocBuilder<RegistrationProcessBloc, RegistrationProcessState>(
        builder: (context, state) {
          return state.formStatus is FormSubmitting
              ? SizedBox(
            width: 150,
            height: 50,
            child: SpinKitThreeBounce(color: Colors.white54, size: 80),
          )
              : SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    disabledBackgroundColor: Colors.blueGrey.withOpacity(0.9),
                  ),
                  onPressed: state.start_date != null && state.end_date == null
                      ? () {
                    context
                        .read<RegistrationProcessBloc>()
                        .add(EndDateChanged(end_date: DateTime.now()));
                    context
                        .read<RegistrationProcessBloc>()
                        .add(CompleteRegistrationProcessEvent());
                  }
                      : null,
                  child: Text('Завершить',
                      style: TextStyle(color: Colors.white, fontSize: 16))));
        });
  }

}

class UserRegistrationEnded extends StatelessWidget {
  final OnlyMyRegistrationProcess registrationProcess;

  UserRegistrationEnded({required this.registrationProcess});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // _submitButton(),
        SizedBox(
            height: 250,
            width: 600,
            child: Text.rich(
              TextSpan(
                  children: [
                TextSpan(
                  text: 'Всего     ',
                ),
                WidgetSpan(
                    alignment:
                    PlaceholderAlignment
                        .middle,
                    child: Icon(
                      Icons
                          .people_outline,
                      color:
                      Colors.grey,
                      size: 80,
                    )),
                TextSpan(
                  text:
                  ' ${registrationProcess.total_count}',
                ),
              ]),
              style: TextStyle(
                  fontSize: 100,
                  color: Colors.white),
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
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

 */
