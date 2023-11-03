import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:voting_flutter/api/globals.dart' as global;
import 'package:voting_flutter/blocs/votingProcessUserBlock.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/formStatus.dart';
import 'package:intl/intl.dart';
// import 'package:voting_flutter/blocs/votingBallotBloc.dart';

final _dateFormater = DateFormat('HH:mm:ss');

String _printDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";
}

class VotingNotStarted extends StatelessWidget {
  final OnlyMyVotingProcess votingProcess;
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
                return AnswerCard(answer: votingProcess.answers[index]);
              },
            )),
      ],
    );
  }
}

class AnswerCard extends StatelessWidget {
  final Answer answer;

  AnswerCard({required this.answer});

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

class EditableAnswerCard extends StatelessWidget {
  final Answer answer;
  final bool isSelected;
  final int index;

  EditableAnswerCard({
    required this.answer,
    required this.isSelected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteProcessUserBloc, VoteProcessUserState>(
        builder: (context, state) {
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
                      activeColor: Colors.greenAccent,

                      /// Прописать отображение галочки другим цветом для уже имеющегося ответа
                      value:
                          state.votingProcesses[state.indexActiveVotingProcess]
                                      .voteBallot.answer ==
                                  null
                              ? isSelected
                              : state
                                          .votingProcesses[
                                              state.indexActiveVotingProcess]
                                          .voteBallot
                                          .answer!
                                          .id ==
                                      answer.id
                                  ? true
                                  : false,
                      onChanged:
                          state.votingProcesses[state.indexActiveVotingProcess]
                                      .voteBallot.answer !=
                                  null
                              ? null
                              : (value) {
                                  context
                                      .read<VoteProcessUserBloc>()
                                      .add(AnswerChangedEvent(index: index));
                                  /*
                              if (value!) {
                                context
                                    .read<VoteBallotBloc>()
                                    .add(AnswerChanged(answer: answer));
                              } else {
                                context
                                    .read<VoteBallotBloc>()
                                    .add(AnswerChanged(answer: null));
                              }

                               */
                                },
                    )),
              ],
            ),
          ));
    });
  }
}

class VotingEnded extends StatelessWidget {
  final OnlyMyVotingProcess votingProcess;

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
  final int total_voting;
  final OnlyMyVotingProcess votingProcess;
  final int myIndex;

  VotingInProgress(
      {required this.total_voting,
      required this.votingProcess,
      required this.myIndex});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final voteProcessState = context.watch<VoteProcessUserBloc>().state;
      // final voteBallotState = context.watch<VoteBallotBloc>().state;

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          voteProcessState
                      .votingProcesses[
                          voteProcessState.indexActiveVotingProcess]
                      .voteBallot
                      .answer !=
                  null
              ? const Text('Вы проголосовали.',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.orange, fontSize: 32))
              : Container(
                  height: 38,
                ),
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
                  return EditableAnswerCard(
                      answer: votingProcess.answers[index],
                      index: index,
                      isSelected: voteProcessState.isSelected[myIndex][index]);
                },
              )),
          _submitButton(),
          SizedBox(
              height: 50,
              width: 400,
              child: Card(
                  color: global.backgroundColor,
                  shadowColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Явка',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Проголосовало ${total_voting}',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )))
        ],
      );
    });
  }

  Widget _submitButton() {
    return BlocBuilder<VoteProcessUserBloc, VoteProcessUserState>(
        builder: (context, state) {
      // final voteProcessState = context.watch<VoteProcessUserBloc>().state;
      final isSelectedAnswerList =
          state.isSelected[state.indexActiveVotingProcess];
      final answerList =
          state.votingProcesses[state.indexActiveVotingProcess].answers;
      // var isNotSelectAnswer = true;
      Answer? answer;
      for (var i = 0; i < isSelectedAnswerList.length; i++) {
        if (isSelectedAnswerList[i]) answer = answerList[i];
      }
      return state.formStatus is FormSubmitting
          ? const SizedBox(
              width: 350,
              height: 70,
              child: SpinKitThreeBounce(color: Colors.white54, size: 80),
            )
          : SizedBox(
              width: 350,
              height: 70,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.blueGrey.withOpacity(0.9),
                  ),

                  ///Если уже проголосовал или не выбран ни один из ответов, кнопка не активна
                  onPressed:
                      (state.votingProcesses[state.indexActiveVotingProcess]
                                      .voteBallot!.answer !=
                                  null ||
                              answer == null)
                          ? null
                          : () {
                              context
                                  .read<VoteProcessUserBloc>()
                                  .add(SubmitVoteBallotFromVotingProcessEvent());

                              /// Странным образом чтение идет до обновления есть предложение объеденить два BLOCа в один
                              ///
                              /*
                              context.read<VoteProcessUserBloc>().add(
                                  ReloadVotingProcessEvent(
                                      id_votingProcess: state
                                          .votingProcesses[state
                                              .indexActiveVotingProcess]
                                          .id!));

                               */
                            },
                  child: Text('Проголосовать',
                      style: TextStyle(color: Colors.white, fontSize: 30))));
    });
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
    final votingstate = context.watch<VoteProcessUserBloc>().state;
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 1000)),
      builder: (context, snapshot) {
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
  final OnlyMyVotingProcess votingProcess;

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
  final OnlyMyVotingProcess votingProcess;

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
