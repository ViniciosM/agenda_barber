import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/providers/application_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_employee_provider.g.dart';

@riverpod
Future<int> getTotalSchedulesToday(Ref ref, int userId) async {
  final DateTime(:year, :month, :day) = DateTime.now();
  final filter = (date: DateTime(year, month, day, 0, 0, 0), userId: userId);

  final scheduleResult = await ref
      .read(scheduleRepositoryProvider)
      .findScheduleByDate(filter);

  return switch (scheduleResult) {
    Success(value: List(length: final totalSchedules)) => totalSchedules,
    Failure(:final exception) => throw exception,
  };
}
