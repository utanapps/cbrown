import 'package:flutter/material.dart';
import 'package:baseapp/utils/constants.dart';

// 数値を受け取り、フォーマットして表示するカスタムウィジェット
class FormattedNumberText extends StatelessWidget {
  final double number;
  final TextStyle? style;

  const FormattedNumberText(this.number, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    // 数値を小数点以下2桁の文字列に変換
    String formattedNumber = number.toStringAsFixed(2);

    return Text(
      '\$$formattedNumber', // 通貨記号を付けて表示
      style: style ??
          const TextStyle(fontSize: baseFontSize), // スタイルが指定されていない場合のデフォルト値
    );
  }
}
