import 'package:agenda_barber/src/core/ui/constants.dart';
import 'package:flutter/material.dart';

class WeekdaysPanel extends StatelessWidget {
  final List<String>? enabledDays;
  final ValueChanged<String> onDayPressed;
  const WeekdaysPanel({
    super.key,
    required this.onDayPressed,
    this.enabledDays,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecione os dias da semana',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonDay(
                label: 'Seg',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Ter',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Qua',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Qui',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Sex',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Sáb',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Dom',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ButtonDay extends StatefulWidget {
  final List<String>? enabledDays;
  final String label;
  final ValueChanged<String> onDayPressed;
  const ButtonDay({
    super.key,
    required this.label,
    required this.onDayPressed,
    this.enabledDays,
  });

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    final ButtonDay(:enabledDays, :label) = widget;
    final disableDay = enabledDays != null && !enabledDays.contains(label);
    if (disableDay) {
      buttonColor = Colors.grey[400]!;
    }

    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap:
            disableDay
                ? null
                : () {
                  widget.onDayPressed(widget.label);
                  setState(() {
                    selected = !selected;
                  });
                },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: buttonColor,
            border: Border.all(color: buttonBorderColor),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
