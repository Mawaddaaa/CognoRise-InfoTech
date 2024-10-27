import '../../models/alarm_model.dart';

abstract class AlarmStates {}

class AlarmInitialState extends AlarmStates {}

class AlarmLoadedState extends AlarmStates {}

class AlarmAddedState extends AlarmStates {}

class AlarmToggledState extends AlarmStates {}

class AlarmRemovedState extends AlarmStates {}

class AlarmUpdatedState extends AlarmStates {}

class TimerUpdatedState extends AlarmStates {
  final int elapsedSeconds;

  TimerUpdatedState(this.elapsedSeconds);
}

class TimerStoppedState extends AlarmStates {}

class AlarmRingingState extends AlarmStates {
  final AlarmModel alarm;

  AlarmRingingState(this.alarm);
}

