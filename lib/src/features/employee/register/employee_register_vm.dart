import 'package:agenda_barber/src/core/exceptions/repository_exception.dart';
import 'package:agenda_barber/src/core/fp/either.dart';
import 'package:agenda_barber/src/core/fp/nil.dart';
import 'package:agenda_barber/src/core/providers/application_providers.dart';
import 'package:agenda_barber/src/features/employee/register/employee_register_state.dart';
import 'package:agenda_barber/src/model/barbershop_model.dart';
import 'package:agenda_barber/src/repositories/user/user_repository.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_register_vm.g.dart';

@riverpod
class EmployeeRegisterVM extends _$EmployeeRegisterVM {
  @override
  EmployeeRegisterState build() => EmployeeRegisterState.initial();

  void setRegisterADM(bool isRegisterADM) {
    state = state.copyWith(registerAdm: isRegisterADM);
  }

  void addOrRemoveWorkDays(String weekDay) {
    final EmployeeRegisterState(:workDays) = state;

    if (workDays.contains(weekDay)) {
      workDays.remove(weekDay);
    } else {
      workDays.add(weekDay);
    }

    state = state.copyWith(workDays: workDays);
  }

  void addOrRemoveWorkHours(int hour) {
    final EmployeeRegisterState(:workHours) = state;

    if (workHours.contains(hour)) {
      workHours.remove(hour);
    } else {
      workHours.add(hour);
    }

    state = state.copyWith(workHours: workHours);
  }

  Future<void> register({String? name, String? email, String? password}) async {
    final EmployeeRegisterState(:registerAdm, :workDays, :workHours) = state;

    final asyncLoaderHandler = AsyncLoaderHandler()..start();

    final UserRepository(:registerAdmAsEmployee, :registerEmployee) = ref.read(
      userRepositoryProvider,
    );

    final Either<RepositoryException, Nil> resultRegister;

    if (registerAdm) {
      final dto = (workDays: workDays, workHours: workHours);

      resultRegister = await registerAdmAsEmployee(dto);
    } else {
      final BarbershopModel(:id) = await ref.watch(
        getMyBarbershopProvider.future,
      );
      final dto = (
        barbershopId: id,
        name: name!,
        email: email!,
        password: password!,
        workDays: workDays,
        workHours: workHours,
      );

      resultRegister = await registerEmployee(dto);
    }

    switch (resultRegister) {
      case Success():
        state = state.copyWith(status: EmployeeRegisterStatus.success);

      case Failure():
        state = state.copyWith(status: EmployeeRegisterStatus.error);
    }

    asyncLoaderHandler.close();
  }
}
