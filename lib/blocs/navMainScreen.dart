import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/services/dataServices.dart';
import 'dart:io';

abstract class MainScreenNavigatorEvent {}

class InitMainScreenEvent extends MainScreenNavigatorEvent {}

class ShowPasswordRestoreFormEvent extends MainScreenNavigatorEvent {}

abstract class MainNavigatorState {}

class WaitMainScreenState extends MainNavigatorState {}

class ShowUserScreenState extends MainNavigatorState {
  final UserInfo userinfo;

  ShowUserScreenState({required this.userinfo});
}

class ShowPasswordRestoreScreenFormState extends MainNavigatorState {}

class NavigatorMainScreenBloc
    extends Bloc<MainScreenNavigatorEvent, MainNavigatorState> {
  final DataService _dataService;

  NavigatorMainScreenBloc(this._dataService)
      : assert(_dataService != null),
        super(WaitMainScreenState());

  @override
  Stream<MainNavigatorState> mapEventToState(
      MainScreenNavigatorEvent event) async* {
    UserInfo _userinfo;

    if (event is InitMainScreenEvent) {
      yield WaitMainScreenState();
      try {
         _userinfo = await _dataService.GetUserInfo();
        yield ShowUserScreenState(userinfo: _userinfo);
      } on SocketException catch (e) {
        yield ShowPasswordRestoreScreenFormState();
      } catch (e) {
        yield ShowPasswordRestoreScreenFormState();
      }
    } else
      yield ShowPasswordRestoreScreenFormState();
  }
}
