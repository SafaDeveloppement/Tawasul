// class SlotModel {
//   final String idSlot;
//   final String startTime; 
//   final String endTime; 
//   final String quota;

//   SlotModel({
//     required this.idSlot,
//     required this.startTime,
//     required this.endTime,
//     required this.quota,
//   });

//   factory SlotModel.fromJson(Map<String, dynamic> j) {
//     return SlotModel(
//       idSlot: j['idSlot']?.toString() ?? '${j['start']}-${j['end']}',
//       startTime: j['startTime'] ?? j['start'] ?? '',
//       endTime: j['endTime'] ?? j['end'] ?? '',
//       quota: j['quota']?.toString() ?? '1',
//     );
//   }

// }

// Check your lib/model/slot_model.dart file to see the actual properties
class SlotModel {
  final String? slot;
  final String? time;
  final String? hour;
  final String? period;
  final String? startTime;
  final String? endTime;
  final String? displayText;
  final String? value;
  
  SlotModel({
    this.slot,
    this.time,
    this.hour,
    this.period,
    this.startTime,
    this.endTime,
    this.displayText,
    this.value,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      slot: json['slot'],
      time: json['time'],
      hour: json['hour'],
      period: json['period'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      displayText: json['display_text'],
      value: json['value'],
    );
  }
}