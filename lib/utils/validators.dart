// lib/utils/validators.dart

String? validateEmail(
    String? value, String invalidEmailMessage, String enterEmailMessage) {
  if (value == null || value.isEmpty) {
    return enterEmailMessage; // メールアドレスを入力してください。
  }

  // メールアドレスのフォーマットを確認する正規表現
  final emailRegex = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b');
  if (!emailRegex.hasMatch(value)) {
    return invalidEmailMessage; // 有効なメールアドレスを入力してください。
  }

  return null;
}

String? validatePassword(
    String? value,
    String enterPasswordMessage,
    String passwordTooShortMessage,
    String passwordNeedsUppercaseMessage,
    String passwordNeedsLowercaseMessage,
    String passwordNeedsNumberMessage,
    String passwordNeedsSpecialCharacterMessage) {
  List<String> errors = [];

  if (value == null || value.isEmpty) {
    errors.add(enterPasswordMessage); // "パスワードを入力してください。"
  } else {
    if (value.length < 8) {
      errors.add(passwordTooShortMessage); // "パスワードは8文字以上である必要があります。"
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      errors.add(
          passwordNeedsUppercaseMessage); // "パスワードには少なくとも1つの大文字を含める必要があります（A-Z）。"
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      errors.add(
          passwordNeedsLowercaseMessage); // "パスワードには少なくとも1つの小文字を含める必要があります（a-z）。"
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      errors.add(
          passwordNeedsNumberMessage); // "パスワードには少なくとも1つの数字を含める必要があります（0-9）。"
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.add(
          passwordNeedsSpecialCharacterMessage); // "パスワードには少なくとも1つの特殊文字を含める必要があります (!@#$%^&*(),.?":{}|<>)."
    }
  }

  if (errors.isNotEmpty) {
    return errors.join('\n');
  }

  return null;
}

String? validateSimplePassword(String? value, String enterPasswordMessage) {
  if (value == null || value.isEmpty) {
    return enterPasswordMessage; // "パスワードを入力してください。"
  }

  return null;
}

String? validateMaxLength(String? value, String lengthExceededMessage,
    [int maxLength = 255]) {
  if (value != null && value.length > maxLength) {
    return lengthExceededMessage; // "文字数が多すぎます。"
  }

  return null;
}
