import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/components/rounded_close_button.dart';
import 'package:baseapp/components/custom_text_field.dart';
import 'package:baseapp/components/custom_button.dart';
import 'package:baseapp/components/custom_snack_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../components/custom_show_dialog.dart';
import '../models/app_user.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends ConsumerState<EditProfile> {
  final _formKey = GlobalKey<FormState>(); // Formのキーを追加
  final _userNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  bool _isUsernameAvailable = true; // ユーザー名の利用可能状態を追跡
  // String? _usernameError;

  bool _isLoading = true; // 追加: データ取得中のローディング状態を管理
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数
  String userId = '';

  @override
  void initState() {
    super.initState();

    supabaseService =
        ref.read(supabaseServiceProvider); // SupabaseServiceを一度だけ取得
    userId = supabaseService.supabase.auth.currentUser!.id;
    _paymentMethodController.text = "auto pay";
    _fetchProfileData();
  }

  @override
  void dispose() {
    // TextEditingControllerのリソースを解放
    _userNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _paymentMethodController.dispose();

    super.dispose();
  }

  void _fetchProfileData() async {
    try {
      final uid = supabaseService.getCurrentUser()?.id;
      if (uid != null) {
        final profiles = await supabaseService.fetchProfiles(uid);
        _userNameController.text = profiles['username'] ?? '';
        _firstNameController.text = profiles['first_name'] ?? '';
        _lastNameController.text = profiles['last_name'] ?? '';
      }
    } catch (e) {
      if (mounted)
        CustomSnackBar.show(ScaffoldMessenger.of(context), S.of(context).error);
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
        'username': _userNameController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
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

  void _checkUsernameAvailability() async {
    final username = _userNameController.text.trim();
    // final userId = ref.read(appUserProvider)?.id ?? '';

    if (username.isEmpty) {
      setState(() {
        _isUsernameAvailable = false;
        // _usernameError = 'このフィールドは必須です';
      });
      return;
    }

    if (username.length < 2) {
      setState(() {
        _isUsernameAvailable = false;
        // _usernameError = 'ユーザー名は2文字以上でなければなりません';
      });
      return;
    }

    try {
      final isAvailable = await ref
          .read(supabaseServiceProvider)
          .checkUsernameAvailability(username: username, userId: userId);

      setState(() {
        _isUsernameAvailable = isAvailable;
        // _usernameError = isAvailable ? null : 'このユーザー名は既に使用されています';
      });
    } catch (e) {
      setState(() {
        _isUsernameAvailable = false;
        // _usernameError = 'エラーが発生しました';
      });
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
                  child: Form(
                    // Formウィジェットを追加
                    key: _formKey, // キーを割り当て
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            PhosphorIcons.identificationCard(),
                            size:
                                70.0, // Set the size of the icon to 50 logical pixels
                            // Pencil Icon
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: S.of(context).username,
                              suffixIcon: _isUsernameAvailable
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : const Icon(Icons.error, color: Colors.red),
                            ),
                            controller: _userNameController,
                            label: S.of(context).firstName,
                            onChanged: (value) {
                              _checkUsernameAvailability();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).fieldRequired;
                              }
                              if (value.length < 2) {
                                return S.of(context).usernameTooShort;
                              }
                              if (!_isUsernameAvailable) {
                                return S.of(context).usernameAlreadyTaken;
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: _firstNameController,
                            label: S.of(context).firstName,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return S.of(context).fieldRequired;
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: _lastNameController,
                            label: S.of(context).lastName,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return S.of(context).fieldRequired;
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: _paymentMethodController,
                            label: S.of(context).paymentMethod,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return S.of(context).fieldRequired;
                              }
                              return null;
                            },
                          ),
                          CustomButton(
                            text: S.of(context).update,
                            onPressed: () {
                              // ボタンが押された時の処理
                              _submitForm();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // フォームのバリデーションを実行
      _updateProfile();
    }
  }
}
