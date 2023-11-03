import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/navMainScreen.dart';
import 'package:voting_flutter/screens/user/userScreen.dart';
import 'package:voting_flutter/screens/admin/adminScreen.dart';

// import 'package:voting_flutter/WebSocket/websocketMng.dart';

class NawScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final mainstate = context.watch<NavigatorMainScreenBloc>().state;
      // final websocketmanager = new WebsocketManager(context);
      // websocketmanager.connect();
      if (mainstate is ShowUserScreenState && mainstate.userinfo.is_admin)
        return AdminScreen();
      else
        return UserScreen();
    });
  }
}
