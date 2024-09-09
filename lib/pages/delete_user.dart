import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/components/rounded_close_button.dart';
import 'package:baseapp/components/custom_text_field.dart';
import 'package:baseapp/components/custom_button.dart';
import 'package:baseapp/components/custom_snack_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:baseapp/pages/welcome.dart';

import '../components/custom_show_dialog.dart';

class DeleteUser extends ConsumerStatefulWidget {
  const DeleteUser({super.key});

  @override
  DeleteUserState createState() => DeleteUserState();
}

class DeleteUserState extends ConsumerState<DeleteUser> {
  final _passwordController = TextEditingController();

  late final SupabaseService supabaseService;
  String userId = '';
  final bool _isLoading = false; // 追加: データ取得中のローディング状態を管理
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    supabaseService =
        ref.read(supabaseServiceProvider); // SupabaseServiceを一度だけ取得
    userId = supabaseService.supabase.auth.currentUser!.id; // ユーザーIDを一度だけ取得
  }

  @override
  void dispose() {
    // TextEditingControllerのリソースを解放
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _deleteUser() async {
    try {
      final currentUser = supabaseService.getCurrentUser();
      if (currentUser == null) {
        return;
      }

      String userEmail = currentUser.email!;
      bool isCurrentPasswordValid = await supabaseService.verifyUser(
        userEmail,
        _passwordController.text,
      );

      if (!isCurrentPasswordValid) {
        throw Exception("The current password is incorrect.");
      }

      await supabaseService.deleteUser(userId);

      if (mounted) {
        showCustomDialog(
            title: S.of(context).successLabel,
            message: S.of(context).successDeleteUser,
            context: context,
            onOkPressed: () => {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const WelcomePage()),
                    // ログインページへ移動
                    (Route<dynamic> route) => false,
                  ),
                });
      }
    } catch (e) {
      if (mounted) {
        if (e is Exception) {
          String message = e.toString();
          if (message.contains('The current password is incorrect.')) {
            errorMessage = S.of(context).currentPasswordInvalid;
          } else {
            errorMessage = S.of(context).error;
          }
        }
      }
      if (mounted) {
        showCustomDialog(
            title: S.of(context).errorLabel,
            message: errorMessage,
            context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedCloseButton(),
      ),
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          PhosphorIcons.bank(),
                          size: 70.0,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          label: S.of(context).password,
                          validator: (value) {
                            return null;
                          },
                        ),
                        CustomButton(
                          text: S.of(context).delete,
                          onPressed: () {
                            // ボタンが押された時の処理
                            _deleteUser();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
