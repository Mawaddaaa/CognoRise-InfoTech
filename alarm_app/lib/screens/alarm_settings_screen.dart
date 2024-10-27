import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../shared/cubit/alarm_cubit.dart';

class AlarmSettingsScreen extends StatefulWidget {
  const AlarmSettingsScreen({super.key});

  @override
  _AlarmSettingsScreenState createState() => _AlarmSettingsScreenState();
}

class _AlarmSettingsScreenState extends State<AlarmSettingsScreen> {
  DateTime? _alarmTime;
  String _selectedTone = 'Default';

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = AlarmCubit.get(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5559BA),
        title: const Text(
          'Set Alarm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimePickerSpinner(
            is24HourMode: false,
            normalTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            highlightedTextStyle: const TextStyle(
              color: Color(0xFF5559BA),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            onTimeChange: (time) {
              setState(() {
                _alarmTime = time;
              });
            },
          ),
          const SizedBox(height: 25),
          DropdownButton<String>(
            value: _selectedTone,
            onChanged: (value) {
              setState(() {
                _selectedTone = value!;
              });
            },
            items: ['Default', 'Tone 1', 'Tone 2'].map((String tone) {
              return DropdownMenuItem<String>(
                value: tone,
                child: Text(tone),
              );
            }).toList(),
          ),
          SizedBox(height: 70),
          ElevatedButton(
            onPressed: () {
              if (_alarmTime != null) {
                cubit.addAlarm(_alarmTime!, _selectedTone, context);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select a time for the alarm.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF5559BA), // Button color
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40), // Rounded corners
              ),
              elevation: 8, // Shadow effect
            ),
            child: const Text(
              'Save Alarm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

        ],
      ),
    );
  }
}
