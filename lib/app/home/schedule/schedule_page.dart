import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/schedule/andrea_entrie_page.dart';
import 'package:new_time_tracker_course/services/database.dart';
import 'package:provider/provider.dart';

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
        elevation: 1.0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        onPressed: () => EntryPage.show(context, database),
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
