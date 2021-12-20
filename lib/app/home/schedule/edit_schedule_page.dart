import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/services/database.dart';
import 'package:provider/provider.dart';

class EditSchedulePage extends StatelessWidget {
  const EditSchedulePage({Key? key, required this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditSchedulePage(database: database),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Создать график', //  widget.job == null ? //: 'Редактировать',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1.0,
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        actions: <Widget>[
          TextButton(
            onPressed: (){}, //_isLoading == false ? _submit : null,
            child: const Text(
              'Сохранить',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          )
        ],
      ),
      body: const Center(child: Text('Выбрать время')),
      backgroundColor: Colors.blueGrey[50],
    );
  }
}
