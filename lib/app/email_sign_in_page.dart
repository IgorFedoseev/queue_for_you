import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Вход через Email',
          style: TextStyle(
            fontSize: 21.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1.0,
        backgroundColor: const Color(0xDE0C5FF9),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            color: Colors.white,
            child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[50],
    );
  }
}
