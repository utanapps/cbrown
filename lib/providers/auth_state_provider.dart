import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:baseapp/providers/supabase_service.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  unconfirmed,
  passwordRecovery,
  error,
}

final statusProvider = StateNotifierProvider<StatusNotifier, AuthStatus>((ref) {
  return StatusNotifier(ref.watch(supabaseServiceProvider), ref);
});

class StatusNotifier extends StateNotifier<AuthStatus> {
  SupabaseService supabaseService;
  Ref ref;
  StreamSubscription? _sub;
  String? errorMessage;

  StatusNotifier(this.supabaseService, this.ref)
      : super(AuthStatus.unauthenticated) {

    Supabase.instance.client.auth.onAuthStateChange.listen((AuthState state) {
      final supabase = ref.watch(supabaseServiceProvider);
      var user = supabase.getCurrentUser();
      switch (state.event) {
        case AuthChangeEvent.signedIn:
          updateStatus(AuthStatus.authenticated);
          break;
        case AuthChangeEvent.signedOut:
          updateStatus(AuthStatus.unauthenticated);
          break;
        case AuthChangeEvent.userDeleted:
          updateStatus(AuthStatus.unauthenticated);
          break;
        case AuthChangeEvent.passwordRecovery:
          updateStatus(AuthStatus.passwordRecovery);
          break;
        case AuthChangeEvent.initialSession:
          _updateAuthStatus(user);
          break;
        default:
          break;
      }
    });

    _initDeepLinkListener();
  }

  void updateStatus(AuthStatus newStatus) {
    state = newStatus;
  }

  void _updateAuthStatus(User? user) {
    if (user != null && user.emailConfirmedAt != null) {
      updateStatus(AuthStatus.authenticated);
    } else {
      updateStatus(AuthStatus.unauthenticated);
    }
  }

  Future<void> handleDeeplink(Uri uri) async {
    try {
      await Supabase.instance.client.auth.getSessionFromUrl(uri);
    } catch (error) {
      errorMessage = 'Email link is invalid or has expired'; // エラーメッセージを保存
      updateStatus(AuthStatus.error);
    }
  }

  Future<void> _initDeepLinkListener() async {
    // 初期リンクを処理する
    final initialUri = await getInitialUri();
    if (initialUri != null) {
      await handleDeeplink(initialUri);
    }

    // ストリームでリンクの変化をリスンする
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeeplink(uri);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
