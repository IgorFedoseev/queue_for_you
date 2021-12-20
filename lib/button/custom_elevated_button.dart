import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    this.child = const Text(
      'Вход с Google Account',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
    this.onPressed,
    this.backgroundColor = Colors.white,
    this.borderRadius = 10.0,
    this.height = 50.0,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double borderRadius;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        child: child,
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(3.0),
          backgroundColor: MaterialStateProperty.all<Color>(
            backgroundColor,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
