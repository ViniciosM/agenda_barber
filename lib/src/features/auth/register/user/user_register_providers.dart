import 'package:agenda_barber/src/core/providers/application_providers.dart';
import 'package:agenda_barber/src/services/user_register/user_register_adm_service.dart';
import 'package:agenda_barber/src/services/user_register/user_register_adm_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_register_providers.g.dart';

@riverpod
UserRegisterAdmService userRegisterAdmService(Ref ref) =>
    UserRegisterAdmServiceImpl(
      userRepository: ref.watch(userRepositoryProvider),
      userLoginService: ref.watch(userLoginServiceProvider),
    );
