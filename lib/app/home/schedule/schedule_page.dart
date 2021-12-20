import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/schedule/edit_schedule_page.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        elevation: 1.0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        onPressed: () => EditSchedulePage.show(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: const Center(
        child: Text('Расписание'),
      ),
    );
  }
}
