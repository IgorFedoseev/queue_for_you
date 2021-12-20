import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.photoURl, required this.avatarRadius})
      : super(key: key);
  final String? photoURl;
  final double avatarRadius;

  @override
  Widget build(BuildContext context) {
    final avatarPhoto = photoURl;
    return CircleAvatar(
      radius: avatarRadius,
      backgroundColor: Colors.blueGrey[200],
      backgroundImage: avatarPhoto != null
          ? NetworkImage(avatarPhoto)
          : null,
      child: avatarPhoto == null ? const Icon(
          Icons.camera_alt,
        color: Color.fromRGBO(3, 37, 65, 1),
        size: 52,
      ) : null,
    );
  }
}

