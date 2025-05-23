import 'package:agenda_barber/src/core/exceptions/repository_exception.dart';
import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/fp/nil.dart';
import 'package:agenda_barber/src/model/barbershop_model.dart';
import 'package:agenda_barber/src/model/user_model.dart';

abstract interface class BarbershopRepository {
  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
    UserModel userModel,
  );

  Future<Either<RepositoryException, Nil>> save(
    ({
      String name,
      String email,
      List<String> openingDays,
      List<int> openingHours,
    })
    data,
  );
}
