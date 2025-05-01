import 'package:agenda_barber/src/core/exceptions/service_exception.dart';
import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/fp/nil.dart';

abstract interface class UserRegisterAdmService {
  Future<Either<ServiceException, Nil>> execute(
    ({String name, String email, String password}) userData,
  );
}
