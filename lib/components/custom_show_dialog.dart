// import 'package:flutter/material.dart';
//
// // CustomDialog2のデザイン部分
// class CustomDialog extends StatelessWidget {
//   final String title;
//   final String message;
//   const CustomDialog({required this.title, required this.message});
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(title),
//       content: Text(message,style: TextStyle(fontSize: 18.0),),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('OK'),
//         ),
//       ],
//     );
//   }
// }
//
// // ダイアログを表示する関数
// void showCustomDialog({
//   required BuildContext context,
//   required String title,
//   required String message,
// }) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return CustomDialog(
//         title: title,
//         message: message,
//       );
//     },
//   );
// }

import 'package:flutter/material.dart';

// CustomDialogのデザイン部分
class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onOkPressed;

  const CustomDialog({
    required this.title,
    required this.message,
    this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        message,
        style: TextStyle(fontSize: 18.0),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onOkPressed != null) {
              onOkPressed!();
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

// ダイアログを表示する関数
void showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  VoidCallback? onOkPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: title,
        message: message,
        onOkPressed: onOkPressed,
      );
    },
  );
}
