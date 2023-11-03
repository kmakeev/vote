import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voting_flutter/blocs/registrationProcessAdminBloc.dart';
import 'package:voting_flutter/api/globals.dart' as global;
import 'package:voting_flutter/blocs/votingProcessAdminBloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:intl/intl.dart';

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

class VotingNotStarted extends StatelessWidget {
  final VotingProcess votingProcess;
  final int indexVotingProcess;

  const VotingNotStarted(
      {required this.votingProcess, required this.indexVotingProcess});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Необходимо выбрать один из вариантов',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        SizedBox(
            height: 300,
            width: 400,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              controller: ScrollController(),
              itemCount: votingProcess.answers.length,
              itemBuilder: (context, index) {
                return AnswerCards(answer: votingProcess.answers[index]);
              },
            )),
      ],
    );
  }
}

class AnswerCards extends StatelessWidget {
  final Answer answer;

  AnswerCards({required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
      color: global.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${answer.name}',
              style: TextStyle(color: Colors.white, fontSize: 30)),
          Transform.scale(
              scale: 2.0,
              child: Checkbox(
                side: BorderSide(color: Colors.grey),
                value: false,
                onChanged: null,
              )),
        ],
      ),
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

class VotingEnded extends StatelessWidget {
  final VotingProcess votingProcess;

  VotingEnded({required this.votingProcess});

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
                  text: 'Тут будут результаты голосования',
                ),
                WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.people_outline,
                      color: Colors.grey,
                      size: 60,
                    )),
                TextSpan(
                  text: ' ${votingProcess.total_count}',
                ),
              ]),
              style: TextStyle(fontSize: 70, color: Colors.white),
              maxLines: 3,
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

class VotingInProgress extends StatelessWidget {
  final int total_registered;

  VotingInProgress({required this.total_registered});

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

class VotingClockWidget extends StatelessWidget {
  final double fontSize;
  final int indexVotingProcess;

  const VotingClockWidget(
      {super.key, required this.fontSize, required this.indexVotingProcess});

  @override
  Widget build(BuildContext context) {
    final votingstate = context.watch<VotingProcessAdminBloc>().state;
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 1000)),
      builder: (context, snapshot) {
        if (votingstate.msValue != null && votingstate.msValue!.isStarted) {
          var _difference = DateTime.now()
              .difference(votingstate.msValue!.value)
              .inMilliseconds;
          // print('${_difference}');
          context.read<VotingProcessAdminBloc>().add(
              StartMillisecondsVotingChanged(msValue: votingstate.msValue!));
          if (_difference > global.msInterval &&
              indexVotingProcess == votingstate.indexActiveVotingProcess) {
            print('Go Start or End from Voting');
            context
                .read<VotingProcessAdminBloc>()
                .add(StartMillisecondsVotingChanged(
                    msValue: Difference(
                  isStarted: false,
                  value: DateTime.now(),
                )));
            if (votingstate
                        .votingProcesses[votingstate.indexActiveVotingProcess]
                        .start_date ==
                    null &&
                votingstate
                        .votingProcesses[votingstate.indexActiveVotingProcess]
                        .end_date ==
                    null)
              context
                  .read<VotingProcessAdminBloc>()
                  .add(StartVotingProcessEvent());
            if (votingstate
                        .votingProcesses[votingstate.indexActiveVotingProcess]
                        .start_date !=
                    null &&
                votingstate
                        .votingProcesses[votingstate.indexActiveVotingProcess]
                        .end_date ==
                    null)
              context
                  .read<VotingProcessAdminBloc>()
                  .add(CompleteVotingProcessEvent());
            // context
            //    .read<RegistrationProcessAdminBloc>()
            //    .add(StartMillisecondsChanged(msValue: startValue + global.msInterval));
          }
        }
        return Text(_dateFormater.format(DateTime.now()),
            style: TextStyle(color: Colors.white, fontSize: fontSize));
      },
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
        if (registrationstate.isNeedFocus) if (registrationstate.msValue !=
                null &&
            registrationstate.msValue!.isStarted) {
          var _difference = DateTime.now()
              .difference(registrationstate.msValue!.value)
              .inMilliseconds;
          // print('${_difference}');
          context.read<RegistrationProcessAdminBloc>().add(
              StartMillisecondsChanged(msValue: registrationstate.msValue!));
          if (_difference > global.msInterval &&
              registrationstate.isNeedFocus) {
            print('Go Start or End from Registrating');
            context.read<RegistrationProcessAdminBloc>().add(
                StartMillisecondsChanged(
                    msValue:
                        Difference(isStarted: false, value: DateTime.now())));
            if (registrationstate.registrationProcess!.start_date == null &&
                registrationstate.registrationProcess!.end_date == null)
              context
                  .read<RegistrationProcessAdminBloc>()
                  .add(StartRegistrationProcessEvent());
            if (registrationstate.registrationProcess!.start_date != null &&
                registrationstate.registrationProcess!.end_date == null)
              context
                  .read<RegistrationProcessAdminBloc>()
                  .add(CompleteRegistrationProcessEvent());
            // context
            //    .read<RegistrationProcessAdminBloc>()
            //    .add(StartMillisecondsChanged(msValue: startValue + global.msInterval));
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

class VotingProcessStateCard extends StatelessWidget {
  final VotingProcess votingProcess;

  const VotingProcessStateCard({required this.votingProcess});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: (votingProcess.start_date == null &&
                  votingProcess.end_date == null)
              ? Colors.orangeAccent
              : (votingProcess.start_date != null &&
                      votingProcess.end_date == null)
                  ? Colors.green
                  : Colors.red,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
            padding: EdgeInsets.all(6.0),
            child: (votingProcess.start_date == null &&
                    votingProcess.end_date == null)
                ? Text('Ожидание голосования',
                    style: TextStyle(color: Colors.white, fontSize: 30))
                : (votingProcess.start_date != null &&
                        votingProcess.end_date == null)
                    ? Text('Идет голосование',
                        style: TextStyle(color: Colors.white, fontSize: 30))
                    : Text('Голосование завершено',
                        style: TextStyle(color: Colors.white, fontSize: 30))));
  }
}

/*
Widget _endRegistrationButton() {
  return BlocBuilder<RegistrationProcessAdminBloc, RegistrationProcessState>(
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
                      .read<RegistrationProcessAdminBloc>()
                      .add(EndDateChanged(end_date: DateTime.now()));
                  context
                      .read<RegistrationProcessAdminBloc>()
                      .add(CompleteRegistrationProcessEvent());
                }
                    : null,
                child: Text('Завершить',
                    style: TextStyle(color: Colors.white, fontSize: 16))));
      });
}

*/
