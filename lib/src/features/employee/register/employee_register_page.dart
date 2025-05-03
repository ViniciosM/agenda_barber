import 'dart:developer';

import 'package:agenda_barber/src/core/providers/application_providers.dart';
import 'package:agenda_barber/src/core/ui/helpers/form_helper.dart';
import 'package:agenda_barber/src/core/ui/helpers/messages.dart';
import 'package:agenda_barber/src/core/ui/widgets/avatar_widget.dart';
import 'package:agenda_barber/src/core/ui/widgets/barber_loader.dart';
import 'package:agenda_barber/src/core/ui/widgets/hours_panel.dart';
import 'package:agenda_barber/src/core/ui/widgets/weekdays_panel.dart';
import 'package:agenda_barber/src/features/employee/register/employee_register_state.dart';
import 'package:agenda_barber/src/features/employee/register/employee_register_vm.dart';
import 'package:agenda_barber/src/model/barbershop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  var isEmployeeAdm = false;

  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVM = ref.watch(employeeRegisterVMProvider.notifier);
    final barbershopAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(employeeRegisterVMProvider.select((state) => state.status), (
      _,
      status,
    ) {
      switch (status) {
        case EmployeeRegisterStatus.initial:
          break;

        case EmployeeRegisterStatus.success:
          Messages.showSuccess('Colaborador cadastrado com sucesso', context);
          Navigator.of(context).pop();

        case EmployeeRegisterStatus.error:
          Messages.showError('Erro ao registrar colaborador', context);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar colaborador')),
      body: barbershopAsyncValue.when(
        data: (barbershopModel) {
          final BarbershopModel(:openingDays, :openingHours) = barbershopModel;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AvatarWidget(),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            value: false,
                            onChanged: (value) {
                              setState(() {
                                isEmployeeAdm = !isEmployeeAdm;
                                employeeRegisterVM.setRegisterADM(
                                  isEmployeeAdm,
                                );
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              'Sou administrador e quero me cadastrar como colaborador',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      Offstage(
                        offstage: isEmployeeAdm,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: nameEC,
                              onTapOutside: (event) => context.unfocus(),
                              validator:
                                  isEmployeeAdm
                                      ? null
                                      : Validatorless.required(
                                        'Nome é obrigatõrio',
                                      ),
                              decoration: InputDecoration(label: Text('Nome')),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              onTapOutside: (event) => context.unfocus(),
                              controller: emailEC,
                              validator:
                                  isEmployeeAdm
                                      ? null
                                      : Validatorless.multiple([
                                        Validatorless.required(
                                          'E-mail é obrigatório',
                                        ),
                                        Validatorless.email('E-mail inválido'),
                                      ]),
                              decoration: InputDecoration(
                                label: Text('E-mail'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              obscureText: true,
                              onTapOutside: (event) => context.unfocus(),
                              controller: passwordEC,
                              validator:
                                  isEmployeeAdm
                                      ? null
                                      : Validatorless.multiple([
                                        Validatorless.required(
                                          'Senha é obrigatória',
                                        ),
                                        Validatorless.min(
                                          6,
                                          'A senha deve ter pelo menos 6 caracteres',
                                        ),
                                      ]),
                              decoration: InputDecoration(label: Text('Senha')),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      WeekdaysPanel(
                        onDayPressed: employeeRegisterVM.addOrRemoveWorkDays,
                        enabledDays: openingDays,
                      ),
                      const SizedBox(height: 24),
                      HoursPanel(
                        startTime: 6,
                        endTime: 23,
                        onHourPressed: employeeRegisterVM.addOrRemoveWorkHours,
                        enabledTimes: openingHours,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          maximumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () {
                          switch (formKey.currentState?.validate()) {
                            case false || null:
                              Messages.showError(
                                'Existem campos inválidos',
                                context,
                              );
                            case true:
                              final EmployeeRegisterState(
                                workDays: List(isNotEmpty: hasWorkDays),
                                workHours: List(isNotEmpty: hasWorkHours),
                              ) = ref.watch(employeeRegisterVMProvider);

                              if (hasWorkDays || hasWorkHours) {
                                Messages.showError(
                                  'Por favor, selecione os dias da semana e horário de atendimento',
                                  context,
                                );
                                return;
                              }

                              final name = nameEC.text;
                              final email = emailEC.text;
                              final password = passwordEC.text;

                              employeeRegisterVM.register(
                                name: name,
                                email: email,
                                password: password,
                              );
                          }
                        },
                        child: Text('Cadastrar colaborador'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        error: (e, s) {
          log('Erro ao carregar a página', error: e, stackTrace: s);
          return Center(child: Text('Erro ao carregar a página'));
        },
        loading: () {
          return Center(child: BarberLoader());
        },
      ),
    );
  }
}
