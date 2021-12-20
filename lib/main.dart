import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/landing_page.dart';
import 'package:new_time_tracker_course/services/firebase_auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Time Tracker App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          backgroundColor: Colors.blueGrey[50],
          //brightness: Brightness.dark,
        ),
        home: const LandingPage(),
      ),
    );
  }
}

