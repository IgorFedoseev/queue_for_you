import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/schedule/format.dart';
import 'package:new_time_tracker_course/common_widgets/input_dropdown.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key? key,
    this.firstLabelText,
    this.secondLabelText,
    required this.selectedDate,
    required this.selectedTime,
    required this.onSelectedDate,
    required this.onSelectedTime,
  }) : super(key: key);

  final String? secondLabelText;
  final String? firstLabelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> onSelectedDate;
  final ValueChanged<TimeOfDay> onSelectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      helpText: 'ВЫБЕРИТЕ ДАТУ',
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      cancelText: 'Отмена',
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onSelectedDate(pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      helpText: 'ВЫБЕРИТЕ ВРЕМЯ',
      cancelText: 'Отмена',
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      onSelectedTime(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle =
        Theme.of(context).textTheme.headline6 ?? const TextStyle();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: InputDropdown(
            labelText: firstLabelText,
            valueText: Format.date(selectedDate),
            valueStyle: valueStyle,
            onPressed: () => _selectDate(context),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: InputDropdown(
            labelText: secondLabelText,
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () => _selectTime(context),
          ),
        ),
      ],
    );
  }
}
