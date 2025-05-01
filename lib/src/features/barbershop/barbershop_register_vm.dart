import 'package:agenda_barber/src/core/fp/either.dart';

import 'package:agenda_barber/src/core/providers/application_providers.dart';
import 'package:agenda_barber/src/features/barbershop/barbershop_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barbershop_register_vm.g.dart';

@riverpod
class BarbershopRegisterVM extends _$BarbershopRegisterVM {
  @override
  BarbershopRegisterState build() => BarbershopRegisterState.initial();

  void addOrRemoveOpenDay({required String weekDay}) {
    final openingDays = state.openingDays;

    if (openingDays.contains(weekDay)) {
      openingDays.remove(weekDay);
    } else {
      openingDays.add(weekDay);
    }

    state.copyWith(openingDays: openingDays);
  }

  void addOrRemoveOpenHour({required int hour}) {
    final openingHours = state.openingHours;

    if (openingHours.contains(hour)) {
      openingHours.remove(hour);
    } else {
      openingHours.add(hour);
    }

    state.copyWith(openingHours: openingHours);
  }

  Future<void> register(String name, String email) async {
    final repository = ref.watch(barbershopRepositoryProvider);
    final BarbershopRegisterState(:openingDays, :openingHours) = state;

    final dto = (
      name: name,
      email: email,
      openingDays: openingDays,
      openingHours: openingHours,
    );

    final registerResult = await repository.save(dto);

    switch (registerResult) {
      case Success():
        ref.invalidate(getMyBarbershopProvider);
        state = state.copyWith(status: BarbershopRegisterStatus.success);
      case Failure():
        state = state.copyWith(status: BarbershopRegisterStatus.error);
    }
  }
}
