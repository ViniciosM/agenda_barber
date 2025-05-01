import 'package:agenda_barber/src/core/ui/helpers/form_helper.dart';
import 'package:agenda_barber/src/core/ui/helpers/messages.dart';
import 'package:agenda_barber/src/core/ui/widgets/hours_panel.dart';
import 'package:agenda_barber/src/core/ui/widgets/weekdays_panel.dart';
import 'package:agenda_barber/src/features/barbershop/barbershop_register_state.dart';
import 'package:agenda_barber/src/features/barbershop/barbershop_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class BarbershopRegisterPage extends ConsumerStatefulWidget {
  const BarbershopRegisterPage({super.key});

  @override
  ConsumerState<BarbershopRegisterPage> createState() =>
      _BarbershopRegisterPageState();
}

class _BarbershopRegisterPageState
    extends ConsumerState<BarbershopRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barbershopRegisterVM = ref.watch(
      barbershopRegisterVMProvider.notifier,
    );

    ref.listen(barbershopRegisterVMProvider, (_, state) {
      switch (state.status) {
        case BarbershopRegisterStatus.initial:
          break;
        case BarbershopRegisterStatus.success:
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home/adm', (route) => false);
        case BarbershopRegisterStatus.error:
          Messages.showError('Ocorreu um erro ao registrar barbearia', context);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Criar Estabelecimento')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: nameEC,
                  onTapOutside: (event) => context.unfocus(),
                  validator: Validatorless.multiple([
                    Validatorless.required('Nome é obrigatõrio'),
                    Validatorless.min(6, 'Nome muito curto'),
                  ]),
                  decoration: InputDecoration(label: Text('Nome')),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: emailEC,
                  onTapOutside: (event) => context.unfocus(),
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail é obrigatõrio'),
                    Validatorless.email('E-mail invãlido'),
                  ]),
                  decoration: InputDecoration(label: Text('E-mail')),
                ),
                const SizedBox(height: 24),
                WeekdaysPanel(
                  onDayPressed: (value) {
                    barbershopRegisterVM.addOrRemoveOpenDay(weekDay: value);
                  },
                ),
                const SizedBox(height: 24),
                HoursPanel(
                  startTime: 9,
                  endTime: 18,
                  onHourPressed: (int value) {
                    barbershopRegisterVM.addOrRemoveOpenHour(hour: value);
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(56),
                  ),
                  onPressed: () async {
                    switch (formKey.currentState?.validate()) {
                      case (false || null):
                        Messages.showError('Campos inválidos', context);
                        break;
                      case true:
                        barbershopRegisterVM.register(
                          nameEC.text,
                          emailEC.text,
                        );
                    }
                  },
                  child: Text('Cadastrar estabelecimento'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
