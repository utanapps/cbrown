import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/components/language_dropdown.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/components/custom_text_field.dart';
import 'package:baseapp/utils/constants.dart';
import 'package:baseapp/components/rounded_close_button.dart';
import 'package:baseapp/components/custom_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../components/custom_show_dialog.dart';

class TradingAccountRegistration extends ConsumerStatefulWidget {
  const TradingAccountRegistration({super.key});

  @override
  TradingAccountRegistrationState createState() =>
      TradingAccountRegistrationState();
}

class TradingAccountRegistrationState
    extends ConsumerState<TradingAccountRegistration> {
  final _tradingAccountNumberController = TextEditingController();
  final _tradingAccountEmailController = TextEditingController();
  final _tradingAccountAdditionalInfoController = TextEditingController();
  final _tradingAccountHolderNameController = TextEditingController();
  final _paymentMethodController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String userId = "";
  bool _isLoading = false;
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数

  @override
  void initState() {
    super.initState();
    supabaseService =
        ref.read(supabaseServiceProvider); // SupabaseServiceを一度だけ取得
    userId = supabaseService.supabase.auth.currentUser!.id; // ユーザーIDを一度だけ取得
    _paymentMethodController.text = "auto";
  }

  @override
  void dispose() {
    _tradingAccountNumberController.dispose();
    _tradingAccountEmailController.dispose();
    _tradingAccountAdditionalInfoController.dispose();
    _tradingAccountHolderNameController.dispose();
    _paymentMethodController.dispose();

    super.dispose();
  }

  Future<void> _addTradingAccount() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true); // ローディング開始

    try {
      // 取引口座の登録処理
      await supabaseService.addTradingAccount(
        userId: userId,
        accountNumber: _tradingAccountNumberController.text,
        email: _tradingAccountEmailController.text,
        additionalInfo: _tradingAccountAdditionalInfoController.text,
        accountHolderName: _tradingAccountHolderNameController.text,
      );

      if (mounted) {
        showCustomDialog(
          context: context,
          title: S.of(context).successLabel,
          message: S.of(context).successInsertTradingAccount,
          onOkPressed: () => Navigator.pop(context, true), // 成功時にtrueを返す

          // onOkPressed: () => Navigator.pop(context, true),
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomDialog(
          context: context,
          title: S.of(context).errorLabel,
          message: S.of(context).error,
          onOkPressed: () => Navigator.pop(context, false), // 成功時にtrueを返す

          // onOkPressed: () => Navigator.pop(context, true),
        );
      }
    } finally {
      setState(() => _isLoading = false); // ローディング終了
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = ref.watch(supabaseServiceProvider);
    userId = supabaseService.supabase.auth.currentUser!.id; // ユーザーIDを一度だけ取得
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedCloseButton(),
        actions: const [
          LanguageDropdown(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  PhosphorIcons.userPlus(),
                  size: 70.0, // Set the size of the icon to 50 logical pixels
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    S.of(context).TradingAccountRegistrationTitle,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: _tradingAccountEmailController,
                        label: S.of(context).tradingAccountEmail,
                        keyboardType: TextInputType.emailAddress,
                        fontSize: baseFontSize,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S
                                .of(context)
                                .enterEmail; // メールアドレスを入力してください。
                          }
                          // メールアドレスのフォーマットを確認する正規表現
                          final emailRegex =
                              RegExp(r'\b[\w.-]+@[\w.-]+\.\w{2,4}\b');
                          if (!emailRegex.hasMatch(value)) {
                            return S
                                .of(context)
                                .invalidEmailFormat; // 有効なメールアドレスを入力してください。
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: _tradingAccountNumberController,
                        label: S.of(context).tradingAccountNumber,
                        fontSize: baseFontSize,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S
                                .of(context)
                                .enterTradingAccountNumber; // メールアドレスを入力してください。
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: _tradingAccountHolderNameController,
                        label: S.of(context).tradingAccountHolderName,
                        fontSize: baseFontSize,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S
                                .of(context)
                                .enterTradingAccountHolderName; // メールアドレスを入力してください。
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: _paymentMethodController,
                        label: S.of(context).paymentMethod,
                        fontSize: baseFontSize,
                        // validator: (value) {
                        // },
                      ),
                      const SizedBox(height: 40),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: S
                                  .of(context)
                                  .btnTitleTradingAccountRegistration,
                              onPressed: () => _addTradingAccount(),
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
