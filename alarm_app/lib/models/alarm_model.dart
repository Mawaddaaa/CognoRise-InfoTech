class AlarmModel {
  late final DateTime time;
  final String tone;
  bool isOn;
  bool hasRung;

  AlarmModel({
    required this.time,
    required this.tone,
    required this.isOn,
    this.hasRung = false
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      time: DateTime.parse(json['time']),
      tone: json['tone'],
      isOn: json['isOn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'tone': tone,
      'isOn': isOn,
    };
  }
}
