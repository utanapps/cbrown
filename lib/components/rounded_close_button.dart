import 'package:flutter/material.dart';

class RoundedCloseButton extends StatelessWidget {
  final Color backgroundColor; // 背景色
  final Color iconColor; // アイコンの色

  const RoundedCloseButton({
    super.key,
    this.backgroundColor = Colors.lightBlueAccent, // デフォルトの背景色は白
    this.iconColor = Colors.black54, // デフォルトのアイコンの色は黒
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const CircleAvatar(
        backgroundColor: Color(0xff000000),
        child: Icon(
          Icons.close,
          size: 25.0,
          color: Color(0xffffffff),
        ),
      ),
      onPressed: () => Navigator.of(context).pop(), // ここで直接定義
    );
  }
}
