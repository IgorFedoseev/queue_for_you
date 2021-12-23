import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/background_delete_panel.dart';
import 'package:new_time_tracker_course/app/home/jobs/edit_job_page.dart';
import 'package:new_time_tracker_course/app/home/jobs/jobs_list_tile.dart';
import 'package:new_time_tracker_course/app/home/jobs/list_item_builder.dart';
import 'package:new_time_tracker_course/app/home/models/job.dart';
import 'package:new_time_tracker_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:new_time_tracker_course/services/database.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Список услуг',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        elevation: 3.0,
      ),
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        onPressed: () => EditJobPage.show(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blueGrey[50],
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: const BackgroundDeletePanel(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobsListTile(
              job: job,
              onTap: () => EditJobPage.show(context, job: job),
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Выполнение прервано', exception: e);
    }
  }
}
