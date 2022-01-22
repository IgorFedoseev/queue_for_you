import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/background_delete_panel.dart';
import 'package:new_time_tracker_course/app/home/jobs/jobs_list_item_builder.dart';
import 'package:new_time_tracker_course/app/home/schedule/edit_schedule_page.dart';
import 'package:new_time_tracker_course/app/home/schedule/schedule_list_tile.dart';
import 'package:new_time_tracker_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:new_time_tracker_course/services/database.dart';
import 'package:provider/provider.dart';
import 'package:new_time_tracker_course/app/home/models/schedule.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'График работы',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        elevation: 3.0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        onPressed: () => EditSchedulePage.show(context, database),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: _buildContent(context),
      ),
      backgroundColor: Colors.blueGrey[50],
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Schedule>>(
      stream: database.scheduleStream(),
      builder: (context, snapshot) {
        return JobsListItemsBuilder<Schedule>(
          snapshot: snapshot,
          itemBuilder: (context, schedule) => Dismissible(
            key: Key('schedule-${schedule.id}'),
            background: const BackgroundDeletePanel(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, schedule),
            child: ScheduleListTile(
              schedule: schedule,
              onTap: () => EditSchedulePage.show(
                context, database, schedule: schedule
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, Schedule schedule) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteSchedule(schedule);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Выполнение прервано', exception: e);
    }
  }

}
