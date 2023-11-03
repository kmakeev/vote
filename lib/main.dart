import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/services/dataServices.dart';
import 'package:voting_flutter/blocs/navMainScreen.dart';
import 'package:voting_flutter/blocs/registrationBallotBloc.dart';
import 'package:voting_flutter/blocs/userMeetingBloc.dart';
import 'package:voting_flutter/blocs/adminMeetingBloc.dart';
import 'package:voting_flutter/blocs/registrationProcessUserBloc.dart';
import 'package:voting_flutter/blocs/registrationProcessAdminBloc.dart';
import 'package:voting_flutter/screens/nawScreen.dart';
import 'package:voting_flutter/blocs/votingProcessAdminBloc.dart';
import 'package:voting_flutter/blocs/votingProcessUserBlock.dart';
import 'package:voting_flutter/blocs/votingBallotBloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // theme: ThemeData(
        //   useMaterial3: true,
        // ),
        home: Navigator(
            pages: [
          MaterialPage(
              child: MultiBlocProvider(providers: [
            BlocProvider(
              lazy: false,
              create: (context) => NavigatorMainScreenBloc(DataService())
                ..add(InitMainScreenEvent()),
            ),
            BlocProvider(
              create: (context) =>
                  UserMeetingBloc(DataService())..add(InitUserMeetingEvent()),
            ),
            BlocProvider(
              create: (context) =>
                  AdminMeetingBloc(DataService())..add(InitAdminMeetingEvent()),
            ),
            BlocProvider(
              create: (context) => RegistrationProcessUserBloc(DataService()),
            ),
            BlocProvider(
              create: (context) => RegistrationProcessAdminBloc(DataService()),
            ),
            BlocProvider(
              create: (context) => VotingProcessAdminBloc(DataService()),
            ),
            BlocProvider(
              create: (context) => VoteProcessUserBloc(DataService()),
            ),
            BlocProvider(
                create: (context) => RegistrationBallotBloc(DataService())
            ),
            BlocProvider(
                create: (context) => VoteBallotBloc(DataService())
            ),
          ], child: NawScreen())),
        ],
            onPopPage: (route, result) {
              print('Route  onPop App Navigator $result');
              return false;
            }));
  }
}
