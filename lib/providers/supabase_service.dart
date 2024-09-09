import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:baseapp/models/app_user.dart';
import 'package:baseapp/enum/date_filter.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:baseapp/models/trade.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final appUserProvider = StateProvider<AppUser?>((ref) => null);

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() => _instance;

  SupabaseService._internal();

  final SupabaseClient supabase = Supabase.instance.client;

  //ログインユーザーを取得
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  //ユーザーを削除
  Future<void> deleteUser(String userId) async {
    try {
      final updates = {'deleted': true};

      await supabase.from('profiles').update(updates).eq('id', userId);
      await supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response =
          await supabase.from('profiles').select().eq('id', userId).single();
      return response;
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  Future<int> getTradingAccountsCount(String userId) async {
    try {
      final response = await supabase
          .rpc('count_trading_accounts', params: {'target_user_id': userId});
      return response;
    } catch (e) {
      throw Exception('Failed to trading accounts count e: ${e.toString()}');
    }
  }

  Future<void> setUserToProvider(String userId, WidgetRef ref) async {
    try {
      final userProfile = await getUserProfile(userId);
      final appUser = AppUser.fromJson(userProfile);
      ref.read(appUserProvider.notifier).state = appUser;
    } catch (e) {
      throw Exception('Failed to set user profile to provider');
    }
  }

  Future<UserResponse> updateUserPassword({newPassword}) async {
    try {
      return await supabase.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<UserResponse> updateUserEmail({newEmail, String? languageCode}) async {
    try {
      final emailTranslations = await loadEmailTranslations();

      final languageData =
          emailTranslations[languageCode ?? 'en']; // デフォルト言語は英語

      final data = {
        'locale': languageCode,
        'ChangeEmailAddress': languageData['ChangeEmailAddress']
        // メールテンプレートデータを追加
      };

      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
            email: newEmail, // 引数から取得した新しいメールアドレスを使用
            data: data),
        emailRedirectTo: "https://rebatify.vercel.app",
      );

      return res; // UserResponse型のresを返す
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> signInWithPassword(String email, String password) async {
    try {
      return await supabase.auth
          .signInWithPassword(email: email, password: password);
    } catch (e) {
      //Email未認証
      if (e is AuthException && e.message == 'Email not confirmed') {
        throw Exception('100');
        //パスワードまたはメールアドレスが違う
      } else if (e is AuthException &&
          e.message == 'Invalid login credentials') {
        throw Exception('200');
        //それ以外　サービス停止など
      } else {
        throw Exception(e);
      }
    }
  }

  Future<ResendResponse> resendVerificationEmail(String email) async {
    try {
      // Attempt to sign up again with the same email.
      // Supabase automatically resends the verification email if the user hasn't verified their email address yet.

      final ResendResponse response = await supabase.auth.resend(
          type: OtpType.signup,
          email: email,
          emailRedirectTo: "io.supabase.baseapp://signup");
      return response;
    } catch (e) {
      throw Exception('Failed to resend verification email: $e');
    }
  }

  Future<AuthResponse> signUp(
      {String? email,
      String? password,
      String? username,
      String? redirectTo,
      String? languageCode,
      String? msg}) async {
    final emailTranslations = await loadEmailTranslations();

    final languageData = emailTranslations[languageCode ?? 'en']; // デフォルト言語は英語

    if (email == null || email.isEmpty) {
      throw Exception('Email cannot be null or empty.');
    }
    if (password == null || password.isEmpty) {
      throw Exception('Password cannot be null or empty.');
    }

    final data = {
      'locale': languageCode,
      'username': username,
      'msg': msg,
      'ConfirmSignup': languageData['ConfirmSignup'],
      'languageData': languageData
    };

    try {
      return await supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: redirectTo,
        data: data,
      );
    } catch (e) {
      throw Exception('Failed to send verification email: $e');
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<bool> verifyCurrentPassword(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> resetPasswordForEmail(String email, {String? redirectTo}) async {
    try {
      // await supabase.auth.resetPasswordForEmail(email,
      //     redirectTo: "io.supabase.baseapp://reset-password");
      // await supabase.auth.resetPasswordForEmail(email,
      //     redirectTo: "https://utanapps.vercel.app/reset-password");
      await supabase.auth.resetPasswordForEmail(email,
          redirectTo: "https://questutan-utanapps-projects.vercel.app");
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> streamMessages(String roomId) {
    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at')
        .map((maps) => List<Map<String, dynamic>>.from(maps));
  }

  Future<void> sendMessage(
      String roomId, String messageText, String senderId) async {
    await supabase.from('messages').insert({
      'message_text': messageText,
      'room_id': roomId,
      'sender_id': senderId,
    });
  }

  Future<String> fetchLatestVersion() async {
    try {
      final response = await supabase
          .from('app_settings')
          .select('value')
          .eq('key', 'latest_version')
          .single();
      return response['value'];
    } catch (e) {
      throw Exception('Failed to fetch latest version');
    }
  }

  Future<bool> verifyUser(String email, String password) async {
    try {
      await supabase.rpc('verify_user',
          params: {'input_email': email, 'input_password': password});
      // 成功時にユーザーIDをそのまま返す
      return true;
    } catch (e) {
      return false; // 例外が発生した場合のエラーメッセージ
    }
  }

  Future<Map<String, dynamic>> loadEmailTranslations() async {
    final jsonString =
        await rootBundle.loadString('assets/json/auth_email_translations.json');
    return jsonDecode(jsonString);
  }

  Future<double> fetchTodaySummary(String uid) async {
    try {
      final response = await supabase
          .from('today_summary')
          .select('today_total')
          .eq('user_id', uid)
          .single();

      if (response['today_total'] != null) {
        double todayTotal = response['today_total'] as double;
        return double.parse(todayTotal.toStringAsFixed(2));
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> fetchWeeklySummary(String uid) async {
    try {
      final response = await supabase
          .from('weekly_summary')
          .select('weekly_total')
          .eq('user_id', uid)
          .single();

      if (response['weekly_total'] != null) {
        double weeklyTotal = response['weekly_total'] as double;
        return double.parse(weeklyTotal.toStringAsFixed(2));
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> fetchMonthlySummary(String uid) async {
    try {
      final response = await supabase
          .from('monthly_summary')
          .select('monthly_total')
          .eq('user_id', uid)
          .single();

      if (response['monthly_total'] != null) {
        double monthlyTotal = response['monthly_total'] as double;
        return double.parse(monthlyTotal.toStringAsFixed(2));
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  Future<Map<String, dynamic>> fetchProfiles(String uid) async {
    try {
      final response =
          await supabase.from('profiles').select().eq('id', uid).single();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch profiles');
    }
  }

  Future<bool> checkUsernameAvailability(
      {required String username, String? userId}) async {
    if (username.isEmpty || username.length < 2) {
      return false;
    }

    try {
      final params = {'target_username': username};
      if (userId != null) {
        params['exclude_user_id'] = userId;
      }

      final isAvailable = await supabase.rpc(
        'check_username_availability',
        params: params,
      );
      return isAvailable;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateProfile({
    required Map<String, String> updates,
    required String userId,
  }) async {
    try {
      await supabase.from('profiles').update(updates).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPayments({
    required String userId,
    DateTimeRange? dateRange,
  }) async {
    try {
      var query =
          supabase.from('cashback_payments').select().eq('user_id', userId);

      if (dateRange != null) {
        query = query
            .gte('payment_date',
                DateFormat('yyyy-MM-dd').format(dateRange.start))
            .lte(
                'payment_date', DateFormat('yyyy-MM-dd').format(dateRange.end));
      }

      final response =
          await query.order('cashback_payment_id', ascending: false).limit(10);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch payments: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchTradeAccounts({
    required String userId,
  }) async {
    try {
      var query =
          supabase.from('trading_accounts').select().eq('user_id', userId);

      final response =
          await query.order('created_at', ascending: false).limit(10);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print(e);

      throw Exception('Failed to fetch payments: $e');
    }
  }

  Future<void> addTradingAccount({
    required String userId,
    required String accountNumber,
    required String email,
    required String additionalInfo,
    required String accountHolderName,
  }) async {
    try {
      await supabase.from('trading_accounts').insert({
        'user_id': userId,
        'account_number': accountNumber,
        'email': email,
        'additional_info': additionalInfo,
        'account_holder_name': accountHolderName,
      });
    } catch (e) {
      throw Exception('Failed to add trading account: $e');
    }
  }

  Future<List<Trade>> fetchTrades({
    required String userId,
    required DateFilter selectedFilter,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final now = DateTime.now();
      var tradesQuery = supabase
          .from('transactions')
          .select(
              'user_id, mt4_id, closetime, lots, payment_amount, instrument')
          .eq('user_id', userId);

      switch (selectedFilter) {
        case DateFilter.today:
          String todayStr = DateFormat('yyyy-MM-dd').format(now);
          tradesQuery = tradesQuery.gte('closetime', '$todayStr 00:00:00');
          break;
        case DateFilter.thisWeek:
          DateTime startOfThisWeek =
              now.subtract(Duration(days: now.weekday - 1));
          String startOfThisWeekStr =
              DateFormat('yyyy-MM-dd').format(startOfThisWeek);
          tradesQuery = tradesQuery.gte('closetime', startOfThisWeekStr);
          break;
        case DateFilter.lastWeek:
          DateTime startOfLastWeek =
              now.subtract(Duration(days: now.weekday - 1 + 7));
          DateTime endOfLastWeek = startOfLastWeek.add(const Duration(days: 6));
          String startOfLastWeekStr =
              DateFormat('yyyy-MM-dd').format(startOfLastWeek);
          String endOfLastWeekStr =
              DateFormat('yyyy-MM-dd').format(endOfLastWeek);
          tradesQuery = tradesQuery
              .gte('closetime', startOfLastWeekStr)
              .lte('closetime', endOfLastWeekStr);
          break;
        case DateFilter.custom:
          if (startDate != null && endDate != null) {
            String formattedStartDate =
                DateFormat('yyyy-MM-dd').format(startDate);
            String formattedEndDate =
                DateFormat('yyyy-MM-dd 23:59:59').format(endDate);
            tradesQuery = tradesQuery
                .gte('closetime', formattedStartDate)
                .lte('closetime', formattedEndDate);
          }
          break;
      }

      final tradesResponse =
          await tradesQuery.order('closetime', ascending: false);
      return List<Trade>.from(tradesResponse.map((x) => Trade.fromMap(x)));
    } catch (e) {
      rethrow;
    }
  }
}
