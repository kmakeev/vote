import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/blocs/votingProcessAdminBloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/blocs/registrationProcessUserBloc.dart';
import 'package:voting_flutter/blocs/registrationProcessAdminBloc.dart';
import 'package:voting_flutter/api/globals.dart' as globals;

import 'package:voting_flutter/blocs/votingProcessUserBlock.dart';

class WebsocketManager {
  final BuildContext context;
  late WebSocketChannel _channel;
  late StreamSubscription _subscription;

  WebsocketManager(this.context);

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse(globals.base_ws),
    );
    _listenForConnection();
  }

  void _reconnect() {
    Timer(Duration(seconds: 3), () {
      print('Reconnecting websocket');
      _channel = WebSocketChannel.connect(Uri.parse(globals.base_ws));
      _listenForConnection();
    });
  }

  void ping() {
    _channel.sink.add('ping');
  }

  void _listenForConnection() {
    _subscription = _channel.stream.listen((msg) {
      try {
        var _message = new Message.fromJson(json.decode(msg));
        if (_message.regProc != null) {
          print(_message.regProc!.totalCount);
          context
              .read<RegistrationProcessUserBloc>()
              .add(WSMessageChanged(message: _message));
          context
              .read<RegistrationProcessAdminBloc>()
              .add(WSMessageAdminChanged(message: _message));
        } else if (_message.voteProc != null) {
          print(_message.voteProc!.id_voting);
          context
              .read<VotingProcessAdminBloc>()
              .add(WSMessageVotingAdminChanged(message: _message));
          context
              .read<VoteProcessUserBloc>()
              .add(WSMessageVotingUserChanged(message: _message));
        }
      } on Exception catch (e) {
        print(e);
      }
    }, onDone: () {
      print('Socket disconnected');
      _subscription.cancel();
      _reconnect();
    }, onError: (error) {
      print('Socket disconnected: $error');
      _subscription.cancel();
      _reconnect();
    });
  }
}
