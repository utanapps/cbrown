import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/utils/constants.dart';
import 'package:baseapp/components/rounded_close_button.dart';
import 'package:baseapp/components/custom_text_field.dart';
import 'package:baseapp/components/custom_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:baseapp/components/custom_show_dialog.dart';

import '../models/app_user.dart';
import '../utils/validators.dart';

class EditBankInfo extends ConsumerStatefulWidget {
  const EditBankInfo({super.key});

  @override
  EditBankInfoState createState() => EditBankInfoState();
}

class EditBankInfoState extends ConsumerState<EditBankInfo> {
  final _bankNameController = TextEditingController();
  final _bankCodeController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _branchCodeController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数
  String userId = '';
  bool _isLoading = true; // 追加: データ取得中のローディング状態を管理
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    supabaseService =
        ref.read(supabaseServiceProvider); // SupabaseServiceを一度だけ取得
    userId = supabaseService.supabase.auth.currentUser!.id; // ユーザーIDを一度だけ取得
    _fetchProfileData();
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _bankCodeController.dispose();
    _branchNameController.dispose();
    _branchCodeController.dispose();
    _bankAccountNumberController.dispose();
    _accountHolderNameController.dispose();
    super.dispose();
  }

  void _fetchProfileData() async {
    try {
      final uid = supabaseService.getCurrentUser()?.id;
      if (uid != null) {
        final profiles = await supabaseService.fetchProfiles(uid);

        _bankNameController.text = profiles['bank_name'] ?? '';
        _bankCodeController.text = profiles['bank_code'] ?? '';
        _branchNameController.text = profiles['branch_name'] ?? '';
        _branchCodeController.text = profiles['branch_code'] ?? '';
        _bankAccountNumberController.text = profiles['account_number'] ?? '';
        _accountHolderNameController.text =
            profiles['account_holder_name'] ?? '';
      }
    } catch (e) {
      if (mounted) {
        showCustomDialog(
          context: context,
          title: S.of(context).errorLabel,
          message: S.of(context).error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true); // ローディング開始
    try {
      final updates = {
        'bank_name': _bankNameController.text,
        'bank_code': _bankCodeController.text,
        'branch_name': _branchNameController.text,
        'branch_code': _branchCodeController.text,
        'account_number': _bankAccountNumberController.text,
        'account_holder_name': _accountHolderNameController.text,
      };

      await supabaseService.updateProfile(
        updates: updates,
        userId: userId,
      );

      final userProfile = await supabaseService.getUserProfile(userId);
      ref.read(appUserProvider.notifier).state = AppUser.fromJson(userProfile);

      if (mounted) {
        showCustomDialog(
          context: context,
          title: S.of(context).successLabel,
          message: S.of(context).successChangeProfile,
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
    } finally {
      setState(() => _isLoading = false); // ローディング終了
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
                          controller: _bankNameController,
                          label: S.of(context).bankName,
                          validator: (value) {
                            return validateMaxLength(value,
                                S.of(context).lengthExceededMessage, 255);
                          },
                        ),
                        CustomTextField(
                          controller: _bankCodeController,
                          label: S.of(context).bankCode,
                          validator: (value) {
                            return validateMaxLength(value,
                                S.of(context).lengthExceededMessage, 255);
                          },
                        ),
                        CustomTextField(
                          controller: _branchNameController,
                          label: S.of(context).branchName,
                          validator: (value) {
                            return validateMaxLength(value,
                                S.of(context).lengthExceededMessage, 255);
                          },
                        ),
                        CustomTextField(
                          controller: _branchCodeController,
                          label: S.of(context).branchCode,
                          fontSize: baseFontSize,
                          validator: (value) {
                            return validateMaxLength(value,
                                S.of(context).lengthExceededMessage, 255);
                          },
                        ),
                        CustomTextField(
                          controller: _bankAccountNumberController,
                          label: S.of(context).bankAccountNumber,
                          validator: (value) {
                            return validateMaxLength(value,
                                S.of(context).lengthExceededMessage, 255);
                          },
                        ),
                        CustomTextField(
                          controller: _accountHolderNameController,
                          label: S.of(context).accountHolderName,
                          validator: (value) {
                            return null;
                          },
                        ),
                        CustomButton(
                          text: S.of(context).update,
                          onPressed: () {
                            // ボタンが押された時の処理
                            _updateProfile();
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
