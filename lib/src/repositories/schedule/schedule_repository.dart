import 'package:agenda_barber/src/core/exceptions/repository_exception.dart';
import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/fp/nil.dart';

abstract interface class ScheduleRepository {
  Future<Either<RepositoryException, Nil>> scheduleClient(
    ({int barbershopId, int userId, String clientName, DateTime date, int time})
    scheduleData,
  );
}
