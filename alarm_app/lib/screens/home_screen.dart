import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../shared/cubit/alarm_cubit.dart';
import '../shared/cubit/alarm_states.dart';
import 'alarm_settings_screen.dart';
import '../widgets/alarm_tile.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = AlarmCubit.get(context);
    return BlocConsumer<AlarmCubit, AlarmStates>(
      listener: (context, state){
        if (state is TimerUpdatedState) {
          cubit.checkAndTriggerAlarm(context);
        }
      },
      builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Alarm',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFF5559BA),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      BlocBuilder<AlarmCubit, AlarmStates>(
                        builder: (context, state) {
                          String currentTime = DateFormat('hh:mm a').format(DateTime.now());
                          return Text(
                            currentTime,
                            style: const TextStyle(fontSize: 37, fontWeight: FontWeight.bold, color: Color(0xFF5559BA)),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('EEE, MMM d, yyyy').format(DateTime.now()),
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlarmSettingsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF5559BA),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    'Add New Alarm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: BlocBuilder<AlarmCubit, AlarmStates>(
                    builder: (context, state) {
                      return ListView.builder(
                        itemCount: cubit.alarms.length,
                        itemBuilder: (context, index) {
                          return AlarmTile(
                            alarm: cubit.alarms[index],
                            index: index,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
      },
    );
  }
}

