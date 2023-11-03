import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/registrationProcessUserBloc.dart';
import 'package:voting_flutter/api/globals.dart' as globals;



class KeyboardManager {
  final BuildContext context;
  late RawKeyboardListener listener;
  late FocusNode focusNode = FocusNode();

  KeyboardManager(this.context);

   connect() {
    return RawKeyboardListener(
      focusNode: focusNode,
      child: Container(),
      onKey: (rawkey) {
        try {
          String _key = rawkey.data.keyLabel.toString();
          print(_key);
          // context
          //    .read<RegistrationProcessBloc>()
          //    .add(WSMessageChanged(message: _message));
        } on Exception catch (e) {
          print(e);
        }

      },
    );
  }
}