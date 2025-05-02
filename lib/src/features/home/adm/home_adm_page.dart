import 'package:agenda_barber/src/core/ui/barbershop_icons.dart';
import 'package:agenda_barber/src/core/ui/constants.dart';
import 'package:agenda_barber/src/features/home/adm/widgets/home_employee_tile.dart';
import 'package:agenda_barber/src/features/home/widgets/home_header.dart';
import 'package:flutter/material.dart';

class HomeAdmPage extends StatelessWidget {
  const HomeAdmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: ColorsConstants.brow,
        onPressed: () {},
        child: CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 12,
          child: Icon(BarbershopIcons.addEmplyeee, color: ColorsConstants.brow),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: HomeHeader()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 20,
              (context, index) => HomeEmployeeTile(),
            ),
          ),
        ],
      ),
    );
  }
}
