import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/email_sign_in_page.dart';
import 'package:new_time_tracker_course/app/sign_in_manager.dart';
import 'package:new_time_tracker_course/button/sign_in.dart';
import 'package:new_time_tracker_course/button/social_button.dart';
import 'package:new_time_tracker_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:new_time_tracker_course/services/firebase_auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.manager, required this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Object exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Вход не выполнен',
      exception: exception,
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => const EmailSignInPage(),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Time Tracker',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1.0,
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
      ),
      body: _buildContent(context),
      backgroundColor: Colors.blueGrey[50],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: _signInLoadState(),
            height: 50.0,
          ),
          const SizedBox(
            height: 50.0,
          ),
          SocialButton(
            text: 'Войти через Google+',
            fontColor: Colors.black87,
            assetName: 'sign_in_images/google/g_logo.png',
            logoPadding: 8.0,
            onPressed: () => isLoading ? null : _signInWithGoogle(context),
          ),
          const SizedBox(
            height: 10,
          ),
          SocialButton(
            text: 'Войти через Facebook',
            fontColor: Colors.white,
            assetName: 'sign_in_images/facebook/f_logo.png',
            logoPadding: 3.0,
            backgroundColor: const Color(0xDE3B5998),
            onPressed: () => isLoading ? null : _signInWithFacebook(context),
          ),
          const SizedBox(
            height: 10,
          ),
          SocialButton(
            text: 'Войти через почту',
            fontColor: Colors.white,
            assetName: 'sign_in_images/mail.png',
            backgroundColor: const Color(0xDE0C5FF9),
            logoPadding: 12.0,
            onPressed: () => isLoading ? null : _signInWithEmail(context),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'или',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(3, 37, 65, 1),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SignInButton(
            text: 'Войти как гость',
            fontColor: Colors.black,
            backgroundColor: Colors.tealAccent,
            onPressed: () => isLoading ? null : _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _signInLoadState() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      'Добро пожаловать!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.5,
        color: Color.fromRGBO(3, 37, 65, 1),
      ),
    );
  }
}
