import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(ScaffoldMessengerState scaffoldMessenger, String message,
      {Color? backgroundColor}) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 60),
        content: Text(
          message,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 6.0,
        action: SnackBarAction(
          // textColor: Colors.black, // SnackBarActionのテキスト色を変更
          label: 'Close',
          onPressed: () {
            // スナックバーを閉じるアクション
          },
        ),
      ),
    );
  }
}
