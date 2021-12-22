import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_time_tracker_course/common_widgets/date_time_picker.dart';
import 'package:new_time_tracker_course/app/home/schedule/format.dart';
import 'package:new_time_tracker_course/app/home/models/entry.dart';
import 'package:new_time_tracker_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:new_time_tracker_course/services/database.dart';
import 'package:intl/date_symbol_data_local.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key, required this.database, this.entry})
      : super(key: key);
  final Database database;
  final Entry? entry;

  static Future<void> show(BuildContext context, Database database,
      {Entry? entry}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EntryPage(database: database, entry: entry),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String? _comment;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
  }

  // Entry _entryFromState() {
  //   final timeStart = DateTime(_startDate.year, _startDate.month, _startDate.day,
  //       _startTime.hour, _startTime.minute);
  //   final timeEnd = DateTime(_endDate.year, _endDate.month, _endDate.day,
  //       _endTime.hour, _endTime.minute);
  //   final allTheTime = timeStart.millisecondsSinceEpoch - timeEnd.millisecondsSinceEpoch;
  //   final int daysNumber = timeEnd.difference(timeStart).inHours.toDouble() ~/ 24.0;
  //   final oneDayTime = allTheTime - allTheTime ~/ (daysNumber * 86400000);
  //   var start = timeStart.millisecondsSinceEpoch;
  //   var end = start + oneDayTime;
  //   final id = widget.entry?.id ?? documentIdFromCurrentDate();
  //
  //   // return Entry(
  //   //   id: id,
  //   //   start: start,
  //   //   end: end,
  //   //   comment: _comment,
  //   // );
  // }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final timeStart = DateTime(_startDate.year, _startDate.month, _startDate.day,
          _startTime.hour, _startTime.minute);
      final timeEnd = DateTime(_endDate.year, _endDate.month, _endDate.day,
          _endTime.hour, _endTime.minute);
      final allTheTime = timeEnd.millisecondsSinceEpoch - timeStart.millisecondsSinceEpoch;
      final daysNumber = (allTheTime ~/ 86400000) + 1;
      final oneDayTime = allTheTime - ((daysNumber - 1) * 86400000);
      var start = timeStart.millisecondsSinceEpoch;
      var end = start + oneDayTime;
      final millisecondsNumbers = daysNumber * 86400000;
      for (int i = 0; i < millisecondsNumbers; i += 86400000) {
        final id = widget.entry?.id ?? '${documentIdFromCurrentDate()} + $i';
        final entry = Entry(
          id: id,
          start: DateTime.fromMillisecondsSinceEpoch(start + i),
          end: DateTime.fromMillisecondsSinceEpoch(end + i),
          comment: _comment,
        );
        await widget.database.setEntry(entry);
      }
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: const Text('Example'),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.entry != null ? 'Редактировать' : 'Создать',
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildStartDate(),
              _buildEndDate(),
              const SizedBox(height: 8.0),
              _buildDuration(),
              const SizedBox(height: 8.0),
              _buildComment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      firstLabelText: 'Начало',
      secondLabelText: 'с',
      selectedDate: _startDate,
      selectedTime: _startTime,
      onSelectedDate: (date) => setState(() => _startDate = date),
      onSelectedTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      firstLabelText: 'Завершение',
      secondLabelText: 'до',
      selectedDate: _endDate,
      selectedTime: _endTime,
      onSelectedDate: (date) => setState(() => _endDate = date),
      onSelectedTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildDuration() {
    final timeStart = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final timeEnd = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final allTheTime = timeEnd.millisecondsSinceEpoch - timeStart.millisecondsSinceEpoch;
    final daysNumber = (allTheTime ~/ 86400000) + 1;
    final oneDayTime = allTheTime - ((daysNumber - 1) * 86400000);
    final durationFormatted = ((oneDayTime / 3600000) * 10 ~/ 1) / 10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Продолжительность: $durationFormatted ч.',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: const InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
    );
  }
}
