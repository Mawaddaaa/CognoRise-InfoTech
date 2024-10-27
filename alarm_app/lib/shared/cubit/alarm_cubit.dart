import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../../main.dart';
import '../../models/alarm_model.dart';
import 'alarm_states.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmCubit extends Cubit<AlarmStates> {
  AlarmCubit() : super(AlarmInitialState()) {
    startTimer();
  }

  static AlarmCubit get(context) => BlocProvider.of(context);

  List<AlarmModel> alarms = [];
  Timer? _timer;
  int elapsedSeconds = 0;
  bool isDialogVisible = false;

  Future<void> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    String? alarmsData = prefs.getString('alarms');
    if (alarmsData != null) {
      List alarmsJson = jsonDecode(alarmsData);
      alarms = alarmsJson.map((json) => AlarmModel.fromJson(json)).toList();
      emit(AlarmLoadedState());
    }
  }

  Future<void> saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    List alarmsJson = alarms.map((alarm) => alarm.toJson()).toList();
    prefs.setString('alarms', jsonEncode(alarmsJson));
  }

  void addAlarm(DateTime time, String tone, BuildContext context) {
    alarms.add(AlarmModel(time: time, tone: tone, isOn: true));
    saveAlarms();
    emit(AlarmAddedState());
    Duration remainingDuration = time.difference(DateTime.now());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Alarm is set after ${formatDuration(remainingDuration)}',
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void toggleAlarm(int index) {
    alarms[index].isOn = !alarms[index].isOn;
    saveAlarms();
    emit(AlarmToggledState());
  }

  void removeAlarm(int index) {
    alarms.removeAt(index);
    saveAlarms();
    emit(AlarmRemovedState());
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedSeconds++;
      for (var alarm in alarms) {
        if (alarm.isOn &&
            alarm.time.hour == DateTime.now().hour &&
            alarm.time.minute == DateTime.now().minute &&
            alarm.time.second == DateTime.now().second) {
          _showNotification(alarm);
          emit(AlarmRingingState(alarm));
        }
      }
      emit(TimerUpdatedState(elapsedSeconds));
    });
  }

  Future<void> _showNotification(AlarmModel alarm) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarms',
      channelDescription: 'Channel for alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    String formattedTime = DateFormat('hh:mm a').format(alarm.time);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Alarm',
      'Your alarm at $formattedTime is ringing now!',
      platformChannelSpecifics,
    );
  }

  void checkAndTriggerAlarm(BuildContext context) {
    for (var alarm in alarms) {
      if (alarm.isOn &&
          alarm.time.hour == DateTime.now().hour &&
          alarm.time.minute == DateTime.now().minute &&
          !alarm.hasRung) {
        alarm.hasRung = true;
        _showAlarmDialog(alarm, context);
        break;
      }
    }
  }

  void _showAlarmDialog(AlarmModel alarm, BuildContext context) {
    if (!isDialogVisible) {
      isDialogVisible = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alarm'),
            content: Text('Your alarm is ringing! Time: ${DateFormat('hh:mm a').format(alarm.time)}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  toggleAlarm(alarms.indexOf(alarm));
                  Navigator.of(context).pop();
                  isDialogVisible = false;
                },
                child: const Text('Dismiss'),
              ),
              TextButton(
                onPressed: () {
                  toggleAlarm(alarms.indexOf(alarm));
                  Navigator.of(context).pop();
                  isDialogVisible = false;
                  _showSnoozeSnackBar(context);
                },
                child: const Text('Snooze'),
              ),
            ],
          );
        },
      ).then((_) {
        isDialogVisible = false;
      });
    }
  }

  void _showSnoozeSnackBar(BuildContext context) {
    final snackBar =  SnackBar(
      content: Text('Snoozed for 5 minutes.'),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void stopTimer() {
    _timer?.cancel();
    elapsedSeconds = 0;
    emit(TimerStoppedState());
  }

  @override
  Future<void> close() {
    stopTimer();
    return super.close();
  }
}
