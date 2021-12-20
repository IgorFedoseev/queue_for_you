import 'package:flutter/material.dart';

class BackgroundDeletePanel extends StatelessWidget {
  const BackgroundDeletePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 6),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.chevron_left, color: Colors.white70),
          const Icon(Icons.chevron_left, color: Colors.white70),
          const Icon(Icons.chevron_left, color: Colors.white70),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.delete, color: Colors.white70),
              Text('Удалить',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
