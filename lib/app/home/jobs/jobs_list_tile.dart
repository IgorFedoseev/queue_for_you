import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/models/job.dart';

class JobsListTile extends StatelessWidget {
  const JobsListTile({Key? key, required this.job, this.onTap})
      : super(key: key);
  final Job job;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        job.name ?? '',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'цена: ${job.price.toString()}',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.blueGrey,
        ),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
