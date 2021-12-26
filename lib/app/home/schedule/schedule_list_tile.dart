import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/models/schedule.dart';
import 'package:new_time_tracker_course/app/home/schedule/format.dart';

class ScheduleListTile extends StatelessWidget {
  const ScheduleListTile(
      {Key? key, required this.schedule, required this.onTap})
      : super(key: key);
  final Schedule schedule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      leading: _leading(context),
      title: _title(),
      subtitle: _subtitle(),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _leading(BuildContext context) {
    final timeStart = TimeOfDay.fromDateTime(schedule.start).format(context);
    final timeEnd = TimeOfDay.fromDateTime(schedule.end).format(context);
    return Text('$timeStart  \n$timeEnd');
  }

  Widget _title() {
    final dateStart = Format.dateSchedule(schedule.start);
    final dateEnd = Format.dateSchedule(schedule.end);
    final String dateText;
    if (dateStart == dateEnd) {
      dateText = dateStart;
    } else {
      dateText = '$dateStart -\n$dateEnd';
    }
    return Text(
      dateText,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _subtitle(){
    final String comment = schedule.comment ?? '';
    return Text(
      comment,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.blueGrey,
      ),
    );
  }
}
