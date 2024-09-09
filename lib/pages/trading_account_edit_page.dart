import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/components/rounded_close_button.dart';
import 'package:baseapp/components/custom_snack_bar.dart';
import 'package:baseapp/components/custom_button.dart';
import 'package:baseapp/components/custom_text_field.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../components/custom_show_dialog.dart';

class EditTradingAccountPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> accountData;

  const EditTradingAccountPage({super.key, required this.accountData});

  @override
  EditTradingAccountPageState createState() => EditTradingAccountPageState();
}

class EditTradingAccountPageState
    extends ConsumerState<EditTradingAccountPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _accountNumberController;
  late TextEditingController _emailController;
  late TextEditingController _additionalInfoController;
  late String _status;
  bool _isLoading = false; // 追加: データ取得中のローディング状態を管理
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider); // SupabaseServiceを一度だけ取得
    _accountNumberController =
        TextEditingController(text: widget.accountData['account_number']);
    _emailController = TextEditingController(text: widget.accountData['email']);
    _additionalInfoController =
        TextEditingController(text: widget.accountData['additional_info']);
    _status = widget.accountData['status'];
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _emailController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _updateTradingAccount() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true); // ローディング開始

    final supabaseService = ref.read(supabaseServiceProvider);
    try {

      final accountId = widget.accountData['id'];
      final updates = {
        'account_number': _accountNumberController.text,
        'email': _emailController.text,
        'additional_info': _additionalInfoController.text,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await supabaseService.supabase
          .from('trading_accounts')
          .update(updates)
          .eq('id', accountId);

      if (mounted) {
        showCustomDialog(
            context: context,
            title: S.of(context).successLabel,
            message: S.of(context).successfullyCompleted,
            onOkPressed: () => Navigator.pop(context, true),
        );
      }

    } catch (e) {
      if (mounted) {
        showCustomDialog(
            context: context,
            title: S.of(context).errorLabel,
            message: S.of(context).error,
        );
      }
    }finally {
      setState(() => _isLoading = false); // ローディング終了
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).editTradingAccount),
        leading: const RoundedCloseButton(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  PhosphorIcons.eraser(),
                  size: 70.0, // Set the size of the icon to 50 logical pixels
                ),
                const SizedBox(height: 40),
                const Text('ステータスが承認されるまでは変更可能です'),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _accountNumberController,
                        label: S.of(context).accountNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).fieldCannotBeEmpty;
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: _emailController,
                        label: S.of(context).email,
                        validator: (value) {
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: _additionalInfoController,
                        label: S.of(context).additionalInfo,
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if(_status !="approved")
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                        text: S.of(context).save,
                        onPressed: () => _updateTradingAccount(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
