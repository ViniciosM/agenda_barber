import 'package:agenda_barber/src/core/providers/application_providers.dart';
import 'package:agenda_barber/src/features/home/adm/home_adm_state.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_adm_vm.g.dart';

@riverpod
class HomeAdmVM extends _$HomeAdmVM {
  Future<HomeAdmState> build() async {
    return HomeAdmState(status: HomeAdmStatus.loaded, employees: []);
  }

  Future<void> logout() => ref.read(logoutProvider.future).asyncLoader();
}
