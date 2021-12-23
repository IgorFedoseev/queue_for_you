import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_time_tracker_course/common_widgets/date_time_picker.dart';
import 'package:new_time_tracker_course/app/home/models/schedule.dart';
import 'package:new_time_tracker_course/common_widgets/show_alert_dialog.dart';
import 'package:new_time_tracker_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:new_time_tracker_course/services/database.dart';
import 'package:intl/date_symbol_data_local.dart';

class EditSchedulePage extends StatefulWidget {
  const EditSchedulePage({Key? key, required this.database, this.entry})
      : super(key: key);
  final Database database;
  final Schedule? entry;

  static Future<void> show(BuildContext context, Database database,
      {Schedule? entry}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditSchedulePage(database: database, entry: entry),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String? _comment;
  bool _isLoading = false;

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

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final timeStart = DateTime(_startDate.year, _startDate.month,
          _startDate.day, _startTime.hour, _startTime.minute);
      final timeEnd = DateTime(_endDate.year, _endDate.month, _endDate.day,
          _endTime.hour, _endTime.minute);
      final allTheTime =
          timeEnd.millisecondsSinceEpoch - timeStart.millisecondsSinceEpoch;
      int daysNumber = (allTheTime ~/ 86400000) + 1;
      final oneDayTime = allTheTime - ((daysNumber - 1) * 86400000);
      int start = timeStart.millisecondsSinceEpoch;
      int end = start + oneDayTime;
      if (start == end) {
        end = end + 86400000;
        daysNumber = daysNumber - 1;
      } final millisecondsNumbers = daysNumber * 86400000;
      if (timeEnd.millisecondsSinceEpoch > timeStart.millisecondsSinceEpoch) {
         for (int i = 0; i < millisecondsNumbers; i += 86400000) {
          final id = widget.entry?.id ??
              '${documentIdFromCurrentDate()}.${i ~/ 86400000 + 1}';
          final entry = Schedule(
            id: id,
            start: DateTime.fromMillisecondsSinceEpoch(start + i),
            end: DateTime.fromMillisecondsSinceEpoch(end + i),
            comment: _comment,
          );
          await widget.database.setSchedule(entry);
        }
        Navigator.of(context).pop();
      } else {
        showAlertDialog(
          context,
          title: 'Некорректные данные',
          content:
              'Время окончания рабочего дня не должно быть раньше начала или совпадать с ним',
          defaultActionText: 'ОК',
        );
      }
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 3.0,
        title: const Text(
          'Создать график', //  widget.entry == null ? //: 'Редактировать',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              widget.entry != null ? Icons.edit : Icons.add,
              size: 28.0,
            ),
            onPressed: () =>
                _isLoading == false ? _setEntryAndDismiss(context) : null,
          ),
        ],
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
      ),
      body: _buildContent(),
      backgroundColor: Colors.blueGrey[50],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SingleChildScrollView(
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
      );
    }
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
    final timeStart = DateTime(_startDate.year, _startDate.month,
        _startDate.day, _startTime.hour, _startTime.minute);
    final timeEnd = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final allTheTime =
        timeEnd.millisecondsSinceEpoch - timeStart.millisecondsSinceEpoch;
    final daysNumber = (allTheTime ~/ 86400000) + 1;
    final oneDayTime = allTheTime - ((daysNumber - 1) * 86400000);
    final durationFormatted = ((oneDayTime / 3600000) * 10 ~/ 1) / 10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Продолжительность: $durationFormatted ч.',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.5,
          ),
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
        labelText: 'Комментарий',
        labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      style: const TextStyle(fontSize: 18.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
      enabled: _isLoading == false,
    );
  }
}
