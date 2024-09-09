import 'package:flutter/material.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/pages/trading_account_registration.dart';
import 'package:baseapp/providers/locale_providers.dart';
import 'package:baseapp/utils/constants.dart';
import 'package:baseapp/utils/url_launcher.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends ConsumerState<Dashboard> {
  final TextEditingController _messageController = TextEditingController();
  late final SupabaseService supabaseService;
  String userId = '';
  String email = '';
  int accountCount = 0;
  int rank = 1;
  int point = 0;
  double todaySummary = 0.0;
  double weeklySummary = 0.0;
  double monthlySummary = 0.0;
  double summaryFontSize = 18.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider);
    userId = supabaseService.supabase.auth.currentUser!.id;
    email = supabaseService.supabase.auth.currentUser?.email ?? "";

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true; // ローディング状態の開始
      });
      await _fetchAll(userId);
      setState(() {
        _isLoading = false; // すべてのフェッチが完了したらローディング状態の終了
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
    _fetchAll(userId);
  }

  Future<void> _fetchAll(uid) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final uid = supabaseService.getCurrentUser()?.id;
      if (uid != null) {
        final today = await supabaseService.fetchTodaySummary(uid);
        final weekly = await supabaseService.fetchWeeklySummary(uid);
        final monthly = await supabaseService.fetchMonthlySummary(uid);
        final profiles = await supabaseService.fetchProfiles(uid);
        final count = await supabaseService.getTradingAccountsCount(uid);

        setState(() {
          todaySummary = today;
          weeklySummary = weekly;
          monthlySummary = monthly;
          rank = profiles['rank'];
          point = profiles['point'];
          accountCount = count;
        });
      }
    } catch (e) {
      todaySummary = 0.0;
      weeklySummary = 0.0;
      monthlySummary = 0.0;
      rank = 0;
      point = 0;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(appUserProvider);
    final myLocale = ref.watch(localeProvider).toString();
    final affLink = "https://clicks.affstrack.com/c?c=202738&l=$myLocale&p=1";
    return SafeArea(
      child: Align(
          alignment: Alignment.topCenter,
          child: Container(
              constraints: const BoxConstraints(
                maxWidth: boxWidth, // 最大幅を200に設定
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator()) // ローディングインジケーターを表示
                  : SingleChildScrollView(
                      child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // if (appUser != null) Text('firstname: ${appUser.userId}'),
                          Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                  width: 2.0, // ボーダーの太さ
                                ), // ThemeDataのbrightnessをチェックしてライトモードかダークモードかを判断
                                // ダークモードの場合はデフォルトの背景色
                                borderRadius:
                                    BorderRadius.circular(15.0), // 角の丸み
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(children: [
                                        Text(
                                          appUser?.username ??
                                              appUser?.email ??
                                              'No user data',
                                          // appUserまたはusername、emailがnullの場合のデフォルト値
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Rank : ${rank.toString()}",
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Point : ${point.toString()}",
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ])),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      // 角丸の半径を指定
                                      child: Image.asset(
                                        'assets/images/sord_icon.png',
                                        width: 140.0, // 幅を指定
                                        height: 140.0, // 高さを指定
                                        fit: BoxFit
                                            .cover, // 画像のアスペクト比を維持して四角形内に収まるように調整
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Card(
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      // ThemeDataのbrightnessをチェックしてライトモードかダークモードかを判断
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer // ライトモードの場合は白色
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                      // ダークモードの場合はデフォルトの背景色
                                      borderRadius:
                                          BorderRadius.circular(15.0), // 角の丸み
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(todaySummary.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0)),
                                          Text(S.of(context).today),
                                        ]),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                flex: 1,
                                child: Card(
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      // ThemeDataのbrightnessをチェックしてライトモードかダークモードかを判断
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer // ライトモードの場合は白色
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                      // ダークモードの場合はデフォルトの背景色
                                      borderRadius:
                                          BorderRadius.circular(15.0), // 角の丸み
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(weeklySummary.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0)),
                                          Text(S.of(context).weekly),
                                        ]),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                flex: 1,
                                child: Card(
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      // ThemeDataのbrightnessをチェックしてライトモードかダークモードかを判断
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer // ライトモードの場合は白色
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                      // ダークモードの場合はデフォルトの背景色
                                      borderRadius:
                                          BorderRadius.circular(15.0), // 角の丸み
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(monthlySummary.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0)),
                                          Text(S.of(context).monthly),
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (accountCount == 1) const SizedBox(height: 20),
                          if (accountCount == 1)
                            Container(
                              decoration: BoxDecoration(
                                // ThemeDataのbrightnessをチェックしてライトモードかダークモードかを判断
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer // ライトモードの場合は白色
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer, // ダークモードの場合はデフォルトの背景色
                                borderRadius:
                                    BorderRadius.circular(15.0), // 角の丸み
                              ),
                              child: ListTile(
                                leading: Icon(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, // アイコンの色を青に指定
                                  Icons.info,
                                ),
                                title: Text(S.of(context).stepOne,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),

                          const SizedBox(height: 20),
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 700.0, // 最大幅を200に設定
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                              // ThemeDataのbrightnessをチェックしてライトモードかダークモードかを判断
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer // ライトモードの場合は白色
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer, // ダークモードの場合はデフォルトの背景色
                              borderRadius: BorderRadius.circular(15.0), // 角の丸み
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    URLLauncher.launchURL(
                                        context, Uri.parse(affLink));
                                  },
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                  ),
                                  subtitle: Text(
                                    S.of(context).registerTradingAccountSub,
                                    style: const TextStyle(),
                                  ),
                                  title: Text(
                                      S.of(context).registerTradingAccount,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TradingAccountRegistration(), // ChatPageはチャット画面のクラス
                                      ),
                                    );
                                  },
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                  ),
                                  subtitle: Text(
                                    S.of(context).registerTradingAccountSub,
                                    style: const TextStyle(),
                                  ),
                                  title: Text(S.of(context).verifyAccount,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )))),
    );
  }
}
