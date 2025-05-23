import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/providers/application_providers.dart';
import 'package:agenda_barber/src/features/auth/register/user/user_register_providers.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_register_vm.g.dart';

enum UserRegisterStatus { initial, success, error }

@riverpod
class UserRegisterVM extends _$UserRegisterVM {
  @override
  UserRegisterStatus build() => UserRegisterStatus.initial;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final userRegisterAdmService = ref.watch(userRegisterAdmServiceProvider);
    final userDTO = (name: name, email: email, password: password);
    final registerResult =
        await userRegisterAdmService.execute(userDTO).asyncLoader();

    switch (registerResult) {
      case Success():
        ref.invalidate(getMeProvider);
        state = UserRegisterStatus.success;
      case Failure():
        state = UserRegisterStatus.error;
    }
  }
}
