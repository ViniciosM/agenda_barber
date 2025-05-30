enum EmployeeRegisterStatus { initial, success, error }

class EmployeeRegisterState {
  final EmployeeRegisterStatus status;
  final bool registerAdm;
  final List<String> workDays;
  final List<int> workHours;

  EmployeeRegisterState.initial()
    : this(
        status: EmployeeRegisterStatus.initial,
        registerAdm: false,
        workDays: <String>[],
        workHours: <int>[],
      );

  EmployeeRegisterState({
    required this.status,
    required this.registerAdm,
    required this.workDays,
    required this.workHours,
  });

  EmployeeRegisterState copyWith({
    EmployeeRegisterStatus? status,
    bool? registerAdm,
    List<String>? workDays,
    List<int>? workHours,
  }) {
    return EmployeeRegisterState(
      status: status ?? this.status,
      registerAdm: registerAdm ?? this.registerAdm,
      workDays: workDays ?? this.workDays,
      workHours: workHours ?? this.workHours,
    );
  }
}
