import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/button/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    Key? key,
    String text = 'Кнопка',
    Color fontColor = Colors.black,
    VoidCallback? onPressed,
    Color backgroundColor = Colors.white,
  }) : super(
          key: key,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: fontColor,
            ),
          ),
          onPressed: onPressed,
          backgroundColor: backgroundColor,
        );
}
