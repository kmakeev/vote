import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:voting_flutter/api/globals.dart' as global;
import 'package:voting_flutter/blocs/states.dart';
import 'package:voting_flutter/blocs/votingProcessAdminBloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:intl/intl.dart';

import 'package:voting_flutter/blocs/adminMeetingBloc.dart';

final _dateFormater = DateFormat('HH:mm:ss');

String _printDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";
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
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text('Необходимо выбрать один из вариантов',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
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
        shadowColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10.0),
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
        ));
  }
}

class VotingEnded extends StatelessWidget {
  final VotingProcess votingProcess;

  VotingEnded({required this.votingProcess});

  List<Color> colors = [
    Colors.yellow,
    Colors.grey,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
            width: 700,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('Результаты',
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                  Text.rich(
                    TextSpan(children: [
                      const WidgetSpan(
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
                  )
                ])),
        votingProcess.answers.length > 0
            ? SizedBox(
                height: 300,
                width: 700,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  controller: ScrollController(),
                  itemCount: votingProcess.answers.length,
                  itemBuilder: (context, index) {
                    return AnswerResultCards(
                      answer: votingProcess.answers[index],
                      total_count: votingProcess.total_count,
                    );
                  },
                ))
            : SizedBox(height: 300, width: 700, child: Container()),
      ],
    );
  }
}

class AnswerResultCards extends StatelessWidget {
  final Answer answer;
  final total_count;

  AnswerResultCards({required this.answer, required this.total_count});

  @override
  Widget build(BuildContext context) {
    // print(answer.total_result!);
    // print(total_count);
    var percent = (total_count > 0) ? answer.total_result! / total_count : 0.0;
    // print(answer.total_result!);
    var percent_format = NumberFormat.percentPattern("ar");
    var percent_str = percent_format.format(percent);

    return Container(
      margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
      color: global.backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text('${answer.name}',
                        style: TextStyle(color: Colors.white, fontSize: 30))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$percent_str',
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.people_outline,
                      color: Colors.grey,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${answer.total_result!}',
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 630,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: LinearPercentIndicator(
                  animation: true,
                  //width: 580,
                  animationDuration: 1000,
                  lineHeight: 8,
                  percent: percent,
                  progressColor: Colors.green,
                ),
              ),
            )
          ],
        ),
      ),
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
        Text('Проголосовало:',
            style: TextStyle(color: Colors.white, fontSize: 60)),
        SizedBox(
            height: 250,
            child: Text.rich(
              TextSpan(children: [
                WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.people_outline,
                      color: Colors.grey,
                      size: 80,
                    )),
                TextSpan(
                  text: ' ${total_registered}',
                ),
              ]),
              style: TextStyle(fontSize: 140, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }
}

class VotingClockWidget extends StatelessWidget {
  final double fontSize;
  final int indexVotingProcess;
  final bool isTimer;

  const VotingClockWidget({
    super.key,
    required this.fontSize,
    required this.indexVotingProcess,
    this.isTimer = false,
  });

  @override
  Widget build(BuildContext context) {
    final votingstate = context.watch<VotingProcessAdminBloc>().state;
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 1000)),
      builder: (context, snapshot) {
        if (votingstate.requestStatus is LoadedState) {
          if (votingstate.msValue != null && votingstate.msValue!.isStarted) {
            var _difference = DateTime.now()
                .difference(votingstate.msValue!.value)
                .inMilliseconds;
            // print('${_difference}');
            if (_difference > global.msInterval &&
                votingstate.msValue!.isStarted != false &&
                indexVotingProcess == votingstate.indexActiveVotingProcess) {
              print('Go Start or End from Voting');
              if (votingstate
                          .votingProcesses[votingstate.indexActiveVotingProcess]
                          .start_date ==
                      null &&
                  votingstate
                          .votingProcesses[votingstate.indexActiveVotingProcess]
                          .end_date ==
                      null) {
                context
                    .read<VotingProcessAdminBloc>()
                    .add(StartVotingProcessEvent());
              } else if (votingstate
                          .votingProcesses[votingstate.indexActiveVotingProcess]
                          .start_date !=
                      null &&
                  votingstate
                          .votingProcesses[votingstate.indexActiveVotingProcess]
                          .end_date ==
                      null) {
                context
                    .read<VotingProcessAdminBloc>()
                    .add(CompleteVotingProcessEvent());
              }
              context
                  .read<VotingProcessAdminBloc>()
                  .add(StartMillisecondsVotingChanged(
                      msValue: Difference(
                    isStarted: false,
                    value: DateTime.now(),
                  )));
            } else {
              context.read<VotingProcessAdminBloc>().add(
                  StartMillisecondsVotingChanged(
                      msValue: votingstate.msValue!));
            }
          }
        }
        return isTimer &&
                votingstate.indexActiveVotingProcess != -1 &&
                votingstate
                        .votingProcesses[votingstate.indexActiveVotingProcess]
                        .start_date !=
                    null
            ? Text(
                _printDuration(DateTime.now().difference(votingstate
                    .votingProcesses[votingstate.indexActiveVotingProcess]
                    .start_date!)),
                style: TextStyle(color: Colors.white, fontSize: fontSize))
            : Text(_dateFormater.format(DateTime.now()),
                style: TextStyle(color: Colors.white, fontSize: fontSize));
      },
    );
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

class VotingProcessCards_ extends StatelessWidget {
  final VotingProcess votingProcess;

  const VotingProcessCards_({required this.votingProcess});

  @override
  Widget build(BuildContext context) {
    return Container(
      // shadowColor: Colors.white,
      color: global.backgroundColor,
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: Text('${votingProcess.question}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  )))),
    );
  }
}
