import 'package:agenda_barber/src/core/exceptions/repository_exception.dart';

import 'package:agenda_barber/src/core/fp/either.dart';

import 'package:agenda_barber/src/model/user_model.dart';

import './barbershop_repository.dart';

class BarbershopRepositoryImpl implements BarbershopRepository {
  @override
  Future<Either<RepositoryException, BarbershopRepository>> getMyBarbershop(
    UserModel userModel,
  ) {
    // TODO: implement getMyBarbershop
    throw UnimplementedError();
  }
}
