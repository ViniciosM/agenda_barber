import 'package:agenda_barber/src/core/ui/barbershop_icons.dart';
import 'package:agenda_barber/src/core/ui/constants.dart';
import 'package:agenda_barber/src/model/user_model.dart';
import 'package:flutter/material.dart';

class HomeEmployeeTile extends StatelessWidget {
  final UserModel employee;
  const HomeEmployeeTile({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorsConstants.grey),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    switch (employee.avatar) {
                          final avatar? => NetworkImage(avatar),
                          _ => const AssetImage(ImageConstants.avatar),
                        }
                        as ImageProvider,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed('/schedule', arguments: employee);
                      },
                      child: Text('Agendar'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed('/employee/schedule', arguments: employee);
                      },
                      child: Text('Ver agenda'),
                    ),
                    Icon(
                      BarbershopIcons.penEdit,
                      color: ColorsConstants.brow,
                      size: 16,
                    ),
                    Icon(
                      BarbershopIcons.trash,
                      color: ColorsConstants.red,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
