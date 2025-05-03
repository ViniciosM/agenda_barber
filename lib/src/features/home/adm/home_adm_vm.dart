import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/providers/application_providers.dart';
import 'package:agenda_barber/src/features/home/adm/home_adm_state.dart';
import 'package:agenda_barber/src/model/barbershop_model.dart';
import 'package:agenda_barber/src/model/user_model.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_adm_vm.g.dart';

@riverpod
class HomeAdmVM extends _$HomeAdmVM {
  @override
  Future<HomeAdmState> build() async {
    final repository = ref.read(userRepositoryProvider);
    final BarbershopModel(id: barbarshopId) = await ref.read(
      getMyBarbershopProvider.future,
    );

    final me = await ref.watch(getMeProvider.future);

    final employeesResult = await repository.getEmployees(barbarshopId);

    switch (employeesResult) {
      case Success(value: var employeesData):
        final employees = <UserModel>[];

        if (me case UserModelADM(workDays: _?, workHours: _?)) {
          employees.add(me);
        }

        employees.addAll(employeesData);

        return HomeAdmState(status: HomeAdmStatus.loaded, employees: employees);
      case Failure():
        return HomeAdmState(
          status: HomeAdmStatus.loaded,
          employees: <UserModel>[],
        );
    }
  }

  Future<void> logout() => ref.read(logoutProvider.future).asyncLoader();
}
