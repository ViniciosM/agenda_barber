import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/restClient/rest_client.dart';
import 'package:agenda_barber/src/core/ui/barbershop_nav_global_key.dart';
import 'package:agenda_barber/src/model/barbershop_model.dart';
import 'package:agenda_barber/src/model/user_model.dart';
import 'package:agenda_barber/src/repositories/barbershop/barbershop_repository.dart';
import 'package:agenda_barber/src/repositories/barbershop/barbershop_repository_impl.dart';
import 'package:agenda_barber/src/repositories/schedule/schedule_repository.dart';
import 'package:agenda_barber/src/repositories/schedule/schedule_repository_impl.dart';
import 'package:agenda_barber/src/repositories/user/user_repository.dart';
import 'package:agenda_barber/src/repositories/user/user_repository_impl.dart';
import 'package:agenda_barber/src/services/users_login/user_login_service.dart';
import 'package:agenda_barber/src/services/users_login/user_login_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

@Riverpod(keepAlive: true)
BarbershopRepository barbershopRepository(Ref ref) =>
    BarbershopRepositoryImpl(restClient: ref.watch(restClientProvider));

@Riverpod(keepAlive: true)
Future<BarbershopModel> getMyBarbershop(Ref ref) async {
  final userModel = await ref.watch(getMeProvider.future);

  final barbershopRepository = ref.watch(barbershopRepositoryProvider);

  final result = await barbershopRepository.getMyBarbershop(userModel);

  return switch (result) {
    Success(value: final barbershop) => barbershop,
    Failure(:final exception) => throw exception,
  };
}

@riverpod
Future<void> logout(Ref ref) async {
  final sp = await SharedPreferences.getInstance();
  sp.clear();

  ref.invalidate(getMeProvider);
  ref.invalidate(getMyBarbershopProvider);

  Navigator.of(
    BarbershopNavGlobalKey.instance.navKey.currentContext!,
  ).pushNamedAndRemoveUntil('/auth/login', (route) => false);
}

@riverpod
ScheduleRepository scheduleRepository(Ref ref) =>
    ScheduleRepositoryImpl(restClient: ref.read(restClientProvider));
