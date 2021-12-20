import 'package:flutter/material.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Записи моих клиентов',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        elevation: 1.0,
      ),
      body: const Center(
        child: Text('Список заказов'),
      ),
    );
  }
}
