import 'package:agenda_barber/src/core/ui/barbershop_nav_global_key.dart';
import 'package:agenda_barber/src/core/ui/barbershop_theme.dart';
import 'package:agenda_barber/src/core/ui/widgets/barber_loader.dart';
import 'package:agenda_barber/src/features/auth/login/login_page.dart';
import 'package:agenda_barber/src/features/barbershop/barbershop_register_page.dart';
import 'package:agenda_barber/src/features/employee/register/employee_register_page.dart';
import 'package:agenda_barber/src/features/home/adm/home_adm_page.dart';
import 'package:agenda_barber/src/features/splash/splash_page.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: BarberLoader(),
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          navigatorKey: BarbershopNavGlobalKey.instance.navKey,
          debugShowCheckedModeBanner: false,
          theme: BarbershopTheme.themeData,
          navigatorObservers: [asyncNavigatorObserver],
          title: 'Agenda Barber',
          routes: {
            '/': (_) => const SplashPage(),
            '/auth/login': (_) => const EmployeeRegisterPage(),
            '/auth/register/user': (_) => const BarbershopRegisterPage(),
            '/auth/register/barbershop': (_) => const BarbershopRegisterPage(),
            '/home/adm': (_) => const HomeAdmPage(),
            '/home/employee': (_) => const Text('Employee'),
            '/home/employee/register': (_) => const EmployeeRegisterPage(),
          },
        );
      },
    );
  }
}
