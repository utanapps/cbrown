import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged; // テキストが変更されたときのコールバック
  final double fontSize;
  final VoidCallback? onEditingComplete;
  final bool enabled; // テキストフィールドを有効/無効にする
  final int? maxLength; // 最大文字数の制限
  final InputDecoration? decoration; // テキストフィールドの装飾をカスタマイズ

  const CustomTextField({
    super.key, // Use super parameter for key
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.fontSize = 20.0,
    this.onEditingComplete,
    this.enabled = true,
    this.maxLength,
    this.decoration,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = !widget.isPassword; // 初期状態でパスワードを表示するかどうか
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: widget.decoration ??
          InputDecoration(
            // デフォルトの装飾か、渡された装飾を使用
            labelText: widget.label,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
          ),
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && !_isPasswordVisible,
      validator: widget.validator,
      onChanged: widget.onChanged,
      // onChangedイベントをTextFormFieldに組み込む
      style: TextStyle(fontSize: widget.fontSize),
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
      // 有効/無効を設定
      maxLength: widget.maxLength, // 最大文字数を設定
    );
  }
}
