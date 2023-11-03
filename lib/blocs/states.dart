abstract class State{
  const State();
}

class InitState extends State {
  const InitState();
}

class LoadedState extends State {
  final int? id;
  LoadedState({this.id});
}

class LoadingState extends State {
  final int? id;
  LoadingState({this.id});
}

class FailedState extends State {
  final String error;
  FailedState(this.error);
}