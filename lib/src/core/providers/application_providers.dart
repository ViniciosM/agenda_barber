import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/restClient/rest_client.dart';
import 'package:agenda_barber/src/model/user_model.dart';
import 'package:agenda_barber/src/repositories/user/user_repository.dart';
import 'package:agenda_barber/src/repositories/user/user_repository_impl.dart';
import 'package:agenda_barber/src/services/users_login/user_login_service.dart';
import 'package:agenda_barber/src/services/users_login/user_login_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_providers.g.dart';

@Riverpod(keepAlive: true)
RestClient restClient(Ref ref) => RestClient();

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) =>
    UserRepositoryImpl(restClient: ref.read(restClientProvider));

@Riverpod(keepAlive: true)
UserLoginService userLoginService(Ref ref) =>
    UserLoginServiceImpl(userRepository: ref.read(userRepositoryProvider));

@Riverpod(keepAlive: true)
Future<UserModel> getMe(Ref ref) async {
  final result = await ref.watch(userRepositoryProvider).me();

  return switch (result) {
    Success(value: final userModel) => userModel,
    Failure(:final exception) => throw exception,
  };
}
