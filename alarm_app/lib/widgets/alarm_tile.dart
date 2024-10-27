import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alarm_model.dart';
import '../shared/cubit/alarm_cubit.dart';

class AlarmTile extends StatelessWidget {
  final AlarmModel alarm;
  final int index;

  const AlarmTile({required this.alarm, required this.index});

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('hh:mm a').format(alarm.time);

    return Dismissible(
      key: Key(alarm.time.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        AlarmCubit.get(context).removeAlarm(index);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alarm deleted'),

          ),
        );
      },
      child: ListTile(
        title: Text(
          formattedTime,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        subtitle: Text(
          '${alarm.tone}',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
        trailing: Switch(
          value: alarm.isOn,
          onChanged: (value) {
            AlarmCubit.get(context).toggleAlarm(index);
          },
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF5559BA),
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey[300],
        ),
      ),
    );
  }
}
