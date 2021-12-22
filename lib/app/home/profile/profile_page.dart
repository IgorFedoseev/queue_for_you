import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/profile/avatar.dart';
import 'package:new_time_tracker_course/common_widgets/show_alert_dialog.dart';
import 'package:new_time_tracker_course/services/firebase_auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<void> _onSignOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didYouReallyWantToLogOut = await showAlertDialog(
      context,
      title: 'Выход из учётной записи',
      content: 'Вы действительно хотите выйти?',
      defaultActionText: 'Выйти',
      cancelActionText: 'Отменить',
    );
    if (didYouReallyWantToLogOut == true) {
      _onSignOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            onPressed: () => _confirmSignOut(context),
            iconSize: 30,
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(66),
          child: _buildUserInfo(auth.currentUser),
        ),
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        elevation: 1.0,
      ),
      body: const Center(
        child: Text('Личный кабинет'),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    final _userName = user.displayName ?? 'Имя пользователя';
    return Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 0.0,
            bottom: 6.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Avatar(
                avatarRadius: 30,
                photoURl: user.photoURL,
              ),
              Text(
                _userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 30,
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
  }
}
