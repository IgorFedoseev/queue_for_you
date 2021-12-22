import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/models/job.dart';
import 'package:new_time_tracker_course/common_widgets/show_alert_dialog.dart';
import 'package:new_time_tracker_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:new_time_tracker_course/services/database.dart';
import 'package:provider/provider.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key? key, required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context, {Job? job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(database: database, job: job),
        // fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _fromKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job?.name;
      _ratePerHour = widget.job?.price;
    }
  }

  bool _validateAndSaveForm() {
    final form = _fromKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null){
          allNames.remove(widget.job?.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Наименование существует',
            content:
                'Данная услуга уже есть в Вашем списке, пожалуйста, выберите другое наименование',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(name: _name, price: _ratePerHour, id: id);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Ошибка синхронизации',
          exception: e,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.job == null ? 'Новая услуга' : 'Редактировать',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1.0,
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        actions: <Widget>[
          TextButton(
            onPressed: _isLoading == false ? _submit : null,
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
      body: _buildContent(),
      backgroundColor: Colors.blueGrey[50],
    );
  }

  _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _fromKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Наименование'),
        validator: (value) =>
            value != null && value.isNotEmpty ? null : 'Заполните поле',
        initialValue: _name,
        onSaved: (value) => _name = value,
        enabled: _isLoading == false,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Стоимость'),
        keyboardType: const TextInputType.numberWithOptions(
          signed: false, // по умолчанию уже так и есть
          decimal: false, // по умолчанию уже так и есть
        ),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        onSaved: (value) => _ratePerHour = int.tryParse(value ?? '') ?? 0,
        enabled: _isLoading == false,
      ),
    ];
  }
}
