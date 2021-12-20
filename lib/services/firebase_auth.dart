import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  get currentUser;
  Future<void> signOut();
  Stream<User?> authStateChanges();
  Future<User?> signInAnonymously();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithFacebook();

  Future<User?> signInWithEmailAndPassword(String email, String password);

  Future<User?> createUserWithEmailAndPassword(String email, String password);
}

class Auth extends AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return userCredential.user;
      }
      throw FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: 'Не удалось получить Google ID Token',
      );
    }
    throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Регистрация прервана пользователем');
  }

  @override
  Future<User?> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        try {
          final accessToken = response.accessToken!;
          final userCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token),
          );
          return userCredential.user;
        } catch (e) {
          throw FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_FAILED',
            message: 'Ошибка получения токена',
          );
        }
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Регистрация прервана пользователем',
        );
      case FacebookLoginStatus.error:
        try {
          final responseError = response.error!;
          throw FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_FAILED',
            message: responseError.developerMessage,
          );
        } catch (e) {
          throw FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_FAILED',
            message: '$e',
          );
        }
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
    return userCredential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final fb = FacebookLogin();
    await fb.logOut();
    await _firebaseAuth.signOut();
  }
}
