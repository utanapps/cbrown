import 'package:flutter/cupertino.dart';

class CustomAlertDialog {
  static void show(BuildContext context,
      {String title = '',
      String message = '',
      Color? backgroundColor,
      VoidCallback? onPressed}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: title.isNotEmpty ? Text(title) : null,
          content: message.isNotEmpty
              ? Text(
                  message,
                  style: const TextStyle(fontSize: 16.0),
                )
              : null,
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
