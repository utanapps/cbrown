import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor; // デフォルトの背景色を設定
  final Color textColor; // デフォルトのフォントカラーを設定
  final EdgeInsetsGeometry padding;
  final double textSize; // テキストサイズ

  const CustomButton({
    super.key, // Use super parameter for key
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue, // デフォルトの背景色を青に設定
    this.textColor = Colors.white, // デフォルトのフォントカラーを白に設定
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.textSize = 16.0, // デフォルトのテキストサイズを16に設定
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff25282B),
          // backgroundColorを使用
          foregroundColor: Colors.white,
          // textColorを使用
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          minimumSize: const Size(100, 50),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor, // textColorを使用
            fontSize: textSize, // textSizeを使用
          ),
        ),
      ),
    );
  }
}
