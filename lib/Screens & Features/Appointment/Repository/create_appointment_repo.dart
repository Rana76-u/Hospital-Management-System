import 'package:flutter/material.dart';

class AppointmentUIUtility {
  Future<DateTime?> pickDate(BuildContext context, DateTime? currentDate) async {
    final now = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: currentDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 30)),
    );
  }

  Future<TimeOfDay?> pickTime(BuildContext context, TimeOfDay? currentTime) async {
    return await showTimePicker(
      context: context,
      initialTime: currentTime ?? TimeOfDay.now(),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day}/${date.month}/${date.year}';
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  DateTime? createDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
