class BarbershopModel {
  final int id;
  final String name;
  final String emaill;
  final List<String> openingDays;
  final List<int> openingHours;

  BarbershopModel({
    required this.id,
    required this.name,
    required this.emaill,
    required this.openingDays,
    required this.openingHours,
  });

  factory BarbershopModel.fromMap(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final int id,
        'name': final String name,
        'email': final String email,
        'opening_days': final List openingDays,
        'opening_hours': final List openingHours,
      } =>
        BarbershopModel(
          id: id,
          name: name,
          emaill: email,
          openingDays: openingDays.cast<String>(),
          openingHours: openingHours.cast<int>(),
        ),
      _ => throw ArgumentError('Invalid Error'),
    };
  }
}
