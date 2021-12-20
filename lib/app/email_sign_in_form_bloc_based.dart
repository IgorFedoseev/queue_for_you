import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/email_sign_in_bloc.dart';
import 'package:new_time_tracker_course/app/email_sign_in_model.dart';
import 'package:new_time_tracker_course/button/sign_in.dart';
import 'package:new_time_tracker_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:new_time_tracker_course/services/firebase_auth.dart';
import 'package:provider/provider.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  const EmailSignInFormBlocBased({Key? key, required this.bloc})
      : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Некорректные данные',
        exception: e,
      );
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final _focus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_focus);
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      const SizedBox(height: 8.0),
      _buildPasswordTextField(model, model.canSubmit),
      const SizedBox(height: 10.0),
      SignInButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
        backgroundColor:
            model.canSubmit ? const Color(0xDE0C5FF9) : Colors.blueGrey,
        fontColor: Colors.white,
      ),
      const SizedBox(height: 16.0),
      const Text(
        'или',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey,
        ),
      ),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(
          model.secondaryButtonText,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: Color(0xDE0C5FF9),
          ),
        ),
      )
    ];
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: widget.bloc.updateEmail,
      style: const TextStyle(color: Color.fromRGBO(3, 37, 65, 1)),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(
          //color: Color.fromRGBO(3, 37, 65, 1),
          color: Colors.blueGrey,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
        hintText: 'example@mail.ru',
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
    );
  }

  TextField _buildPasswordTextField(
      EmailSignInModel model, bool submitEnabled) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete: submitEnabled ? _submit : null,
      onChanged: widget.bloc.updatePassword,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: 'Пароль',
        labelStyle: const TextStyle(
          color: Colors.blueGrey,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data ?? EmailSignInModel();
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
