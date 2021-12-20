import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/common_widgets/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Object exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: _message(exception),
      defaultActionText: 'ОК',
    );

String _message(Object exception){
  if (exception is FirebaseException){
    return exception.message ?? 'Непредвиденная ошибка';
  } return exception.toString();
}
