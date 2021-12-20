import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/home_page.dart';
import 'package:new_time_tracker_course/app/sign_in_page.dart';
import 'package:new_time_tracker_course/services/database.dart';
import 'package:new_time_tracker_course/services/firebase_auth.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          } else {
            print(user.uid);
            return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: const HomePage(),
            );
          }
        } return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
      },
    );
  }
}
