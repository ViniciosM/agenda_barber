import 'dart:developer';

import 'package:agenda_barber/src/core/ui/constants.dart';
import 'package:agenda_barber/src/core/ui/widgets/barber_loader.dart';
import 'package:agenda_barber/src/features/employee/schedule/appointment_ds.dart';
import 'package:agenda_barber/src/features/employee/schedule/employee_schedule_vm.dart';
import 'package:agenda_barber/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EmployeeSchedulePage extends ConsumerStatefulWidget {
  const EmployeeSchedulePage({super.key});

  @override
  ConsumerState<EmployeeSchedulePage> createState() =>
      _EmployeeSchedulePageState();
}

class _EmployeeSchedulePageState extends ConsumerState<EmployeeSchedulePage> {
  late DateTime dateSelected;
  var ignoreFirstLoad = true;

  @override
  void initState() {
    super.initState();
    final DateTime(:year, :month, :day) = DateTime.now();
    dateSelected = DateTime(year, month, day, 0, 0, 0);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel(id: userId, :name) =
        ModalRoute.of(context)?.settings.arguments as UserModel;

    final scheduleAsync = ref.watch(
      employeeScheduleVMProvider(userId, dateSelected),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
      body: Column(
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 36),
          scheduleAsync.when(
            loading: () => const BarberLoader(),
            error: (e, s) {
              const errorMessage = 'Erro ao carregar agendamento';
              log(errorMessage, error: e, stackTrace: s);
              return const Center(child: Text(errorMessage));
            },
            data:
                (schedules) => Expanded(
                  child: SfCalendar(
                    allowViewNavigation: true,
                    view: CalendarView.day,
                    showNavigationArrow: true,
                    todayHighlightColor: ColorsConstants.brow,
                    showDatePickerButton: true,
                    showTodayButton: true,
                    dataSource: AppointmentDS(schedules: schedules),

                    onViewChanged: (viewChangedDetails) {
                      if (ignoreFirstLoad) {
                        ignoreFirstLoad = false;
                        return;
                      }
                      final employeeSchedule = ref.read(
                        employeeScheduleVMProvider(
                          userId,
                          dateSelected,
                        ).notifier,
                      );
                      employeeSchedule.changeDate(
                        userId,
                        viewChangedDetails.visibleDates.first,
                      );
                    },
                    onTap: (calendarTapDetails) {
                      if (calendarTapDetails.appointments?.isNotEmpty ??
                          false) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            final dateFormat = DateFormat('dd//MM/yyyy HH:mm');
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // ignore: avoid_dynamic_calls
                                      'Cliente: ${calendarTapDetails.appointments!.first.subject}',
                                    ),
                                    Text(
                                      'Horário: ${dateFormat.format(calendarTapDetails.date ?? DateTime.now())}',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    //        appointmentBuilder: (context, calendarAppointmentDetails) {
                    //   return Container(
                    //     decoration: BoxDecoration(
                    //       color: ColorsConstants.brow,
                    //       shape: BoxShape.rectangle,
                    //       borderRadius: BorderRadius.circular(5),
                    //     ),

                    //     child: Center(
                    //       child: Text(
                    //         calendarAppointmentDetails.appointments.first.subject,
                    //         style: TextStyle(color: Colors.white, fontSize: 13),
                    //       ),
                    //     ),
                    //   );
                    // },
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
