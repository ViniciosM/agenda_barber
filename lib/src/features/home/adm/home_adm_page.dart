import 'dart:developer';

import 'package:agenda_barber/src/core/ui/barbershop_icons.dart';
import 'package:agenda_barber/src/core/ui/constants.dart';
import 'package:agenda_barber/src/core/ui/widgets/barber_loader.dart';
import 'package:agenda_barber/src/features/home/adm/home_adm_state.dart';
import 'package:agenda_barber/src/features/home/adm/home_adm_vm.dart';
import 'package:agenda_barber/src/features/home/adm/widgets/home_employee_tile.dart';
import 'package:agenda_barber/src/features/home/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAdmPage extends ConsumerWidget {
  const HomeAdmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeAdmVMProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: ColorsConstants.brow,
        onPressed: () {
          Navigator.of(context).pushNamed('/employee/register');
          ref.invalidate(homeAdmVMProvider);
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 12,
          child: Icon(BarbershopIcons.addEmplyeee, color: ColorsConstants.brow),
        ),
      ),
      body: homeState.when(
        data: (HomeAdmState data) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: HomeHeader()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: data.employees.length,
                  (context, index) =>
                      HomeEmployeeTile(employee: data.employees[index]),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          log(
            'Erro ao buscar colaboradores',
            error: error,
            stackTrace: stackTrace,
          );
          return const Center(child: Text('Erroa ao carregar página'));
        },
        loading: () {
          return const BarberLoader();
        },
      ),
    );
  }
}
