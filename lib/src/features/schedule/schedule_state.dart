import 'package:flutter/material.dart';

enum ScheduleStatus { initial, success, error }

class ScheduleState {
  final ScheduleStatus status;
  final int? scheduleHour;
  final DateTime? scheduleDate;

  ScheduleState.initial() : this(status: ScheduleStatus.initial);

  ScheduleState({required this.status, this.scheduleHour, this.scheduleDate});

  ScheduleState copyWith({
    ScheduleStatus? status,
    ValueGetter<int?>? scheduleHour,
    ValueGetter<DateTime?>? scheduleDate,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      scheduleHour: scheduleHour != null ? scheduleHour() : this.scheduleHour,
      scheduleDate: scheduleDate != null ? scheduleDate() : this.scheduleDate,
    );
  }
}
