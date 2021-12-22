import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/email_sign_in_change_model.dart';
import 'package:new_time_tracker_course/button/sign_in.dart';
import 'package:new_time_tracker_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:new_time_tracker_course/services/firebase_auth.dart';
import 'package:provider/provider.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier({Key? key, required this.model})
      : super(key: key);
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

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
      await model.submit();
      Navigator.of(context).pop();
    } catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Некорректные данные',
        exception: e,
      );
    }
  }

  void _emailEditingComplete() {
    final _focus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_focus);
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      const SizedBox(height: 8.0),
      _buildPasswordTextField(model.canSubmit),
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

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail,
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

  TextField _buildPasswordTextField(bool submitEnabled) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete: submitEnabled ? _submit : null,
      onChanged: model.updatePassword,
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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
