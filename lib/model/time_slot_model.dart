import 'package:tawasul_application/model/store_details_model.dart';

class TimeSlot {
  final String id;
  final String timeRange;
  final bool available;

  TimeSlot({
    required this.id,
    required this.timeRange,
    required this.available,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id']?.toString() ?? '',
      timeRange: json['time_range'] ?? '',
      available: json['available'] ?? false,
    );
  }

  // Generate time slots from business hours
  static List<TimeSlot> fromBusinessHours(List<BusinessHours> businessHours, DateTime selectedDate) {
    final dayNames = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    final currentDayIndex = selectedDate.weekday - 1;
    final currentDay = dayNames[currentDayIndex];
    
    final todayHours = businessHours.firstWhere(
      (element) => element.day == currentDay,
      orElse: () => BusinessHours(day: currentDay, hours: []),
    );
    
    return todayHours.hours.map((hour) {
      return TimeSlot(
        id: hour,
        timeRange: hour,
        available: hour != 'مغلق', // Assuming 'مغلق' means closed
      );
    }).toList();
  }
}