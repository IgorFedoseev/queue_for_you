import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/email_sign_in_model.dart';
import 'package:new_time_tracker_course/button/sign_in.dart';
import 'package:new_time_tracker_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:new_time_tracker_course/services/firebase_auth.dart';
import 'package:new_time_tracker_course/services/validators.dart';
import 'package:provider/provider.dart';

class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInFormStateful({Key? key}) : super(key: key);

  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Некорректные данные',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final _focus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_focus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInFormType.signIn ? 'Войти' : 'Создать аккаунт';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Зарегистрироваться'
        : 'Уже есть аккаунт? Войти';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      const SizedBox(height: 8.0),
      _buildPasswordTextField(submitEnabled),
      const SizedBox(height: 10.0),
      SignInButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
        backgroundColor:
            submitEnabled ? const Color(0xDE0C5FF9) : Colors.blueGrey,
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
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(
          secondaryText,
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
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (String? any) => _updateState(),
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
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
    );
  }

  TextField _buildPasswordTextField(bool submitEnabled) {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete: submitEnabled ? _submit : null,
      onChanged: (password) => _updateState(),
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
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
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

  void _updateState() {
    setState(() {});
  }
}
