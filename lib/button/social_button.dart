import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/button/custom_elevated_button.dart';

class SocialButton extends CustomElevatedButton {
  SocialButton({
    Key? key,
    String text = 'Кнопонька',
    Color fontColor = Colors.black87,
    required String assetName,
    double logoPadding = 1.1,
    Color backgroundColor = Colors.white,
    VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(logoPadding),
                child: Image.asset(assetName),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: fontColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(logoPadding),
                child: Opacity(
                  opacity: 0.0,
                  child: Image.asset(assetName),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          onPressed: onPressed,
        );
}
