import 'package:agenda_barber/src/core/ui/barbershop_icons.dart';
import 'package:agenda_barber/src/core/ui/constants.dart';
import 'package:agenda_barber/src/core/ui/helpers/form_helper.dart';
import 'package:agenda_barber/src/core/ui/helpers/messages.dart';
import 'package:agenda_barber/src/core/ui/widgets/avatar_widget.dart';
import 'package:agenda_barber/src/core/ui/widgets/hours_panel.dart';
import 'package:agenda_barber/src/features/schedule/schedule_state.dart';
import 'package:agenda_barber/src/features/schedule/schedule_vm.dart';
import 'package:agenda_barber/src/features/schedule/widgets/schedule_calendar.dart';
import 'package:agenda_barber/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  var dateFormat = DateFormat('dd/MM/yyyy');
  var showCalendar = false;
  final formKey = GlobalKey<FormState>();
  final clientEC = TextEditingController();
  final dateEC = TextEditingController();

  @override
  void dispose() {
    clientEC.dispose();
    dateEC.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;
    final scheduleVM = ref.watch(scheduleVMProvider.notifier);

    final employeeData = switch (userModel) {
      UserModelADM(:final workDays, :final workHours) => (
        workDays: workDays!,
        workHours: workHours!,
      ),
      UserModelEmployee(:final workDays, :final workHours) => (
        workDays: workDays,
        workHours: workHours,
      ),
    };

    ref.listen(scheduleVMProvider.select((state) => state.status), (_, status) {
      switch (status) {
        case ScheduleStatus.initial:
          break;
        case ScheduleStatus.success:
          Messages.showSuccess('Cliente agendado com sucesso', context);
          Navigator.of(context).pop();
        case ScheduleStatus.error:
          Messages.showError('Erro ao agendar cliente', context);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Agendar cliente')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const AvatarWidget(hideUploadButton: true),
                  const SizedBox(height: 24),
                  Text(
                    userModel.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 37),
                  TextFormField(
                    controller: clientEC,
                    validator: Validatorless.required('Cliente é obrigatório'),
                    decoration: InputDecoration(label: Text('Cliente')),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: dateEC,
                    validator: Validatorless.required('Data é obrigatória'),
                    readOnly: true,
                    onTap: () {
                      setState(() {
                        showCalendar = true;
                      });
                      context.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'Selecione uma data',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      label: Text('Selecione uma data'),
                      suffixIcon: Icon(
                        BarbershopIcons.calendar,
                        color: ColorsConstants.brow,
                        size: 18,
                      ),
                    ),
                  ),

                  Offstage(
                    offstage: !showCalendar,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        ScheduleCalendar(
                          cancelPressed: () {
                            setState(() {
                              showCalendar = false;
                            });
                          },
                          okPressed: (value) {
                            setState(() {
                              dateEC.text = dateFormat.format(value);
                              scheduleVM.dateSelect(value);
                              showCalendar = false;
                            });
                          },
                          workDays: employeeData.workDays,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  HoursPanel.singleSelection(
                    startTime: 6,
                    endTime: 23,
                    enabledTimes: employeeData.workHours,
                    onHourPressed: scheduleVM.hourSelect,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      switch (formKey.currentState?.validate()) {
                        case null || false:
                          Messages.showError('Dados incompletos', context);
                        case true:
                          final hourSelected = ref.watch(
                            scheduleVMProvider.select(
                              (state) => state.scheduleHour != null,
                            ),
                          );

                          if (hourSelected) {
                            scheduleVM.register(
                              userModel: userModel,
                              clientName: clientEC.text,
                            );
                          } else {
                            Messages.showError(
                              'Por favor selecione um horário de atendimento',
                              context,
                            );
                          }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: Text('Agendar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
