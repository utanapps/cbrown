import 'package:flutter/material.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/pages/trading_account_registration.dart';
import 'package:baseapp/providers/locale_providers.dart';
import 'package:baseapp/pages/trading_account_edit_page.dart';
import 'package:intl/intl.dart';
import 'package:baseapp/components/custom_card.dart';
import 'package:baseapp/pages/payment_list_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:baseapp/pages/chat_page.dart';
import 'package:baseapp/pages/trading_accounts_list_page.dart';
import 'package:baseapp/utils/url_launcher.dart';
import 'package:baseapp/utils/status_helper.dart';

class DashboardTablet extends ConsumerStatefulWidget {
  const DashboardTablet({super.key});

  @override
  DashboardTabletState createState() => DashboardTabletState();
}

class DashboardTabletState extends ConsumerState<DashboardTablet> {
  final TextEditingController _messageController = TextEditingController();
  late final SupabaseService supabaseService;
  String userId = '';
  String email = '';
  int rank = 1;
  int point = 0;
  double todaySummary = 0.0;
  double weeklySummary = 0.0;
  double monthlySummary = 0.0;
  double summaryFontSize = 18.0;
  bool _isLoading = true;

  Future<List<Map<String, dynamic>>>? _tradeAccountsFuture;
  Future<List<Map<String, dynamic>>>? _paymentsFuture;
  DateTimeRange? dateRange;

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
    _fetchTradeAccounts();
    _fetchPayments();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
    _fetchAll(userId);
  }

  Future<void> _fetchAll(String uid) async {
    try {
      // setState(() {
      //   _isLoading = true;
      // });

      final uid = supabaseService.getCurrentUser()?.id;
      if (uid != null) {
        final today = await supabaseService.fetchTodaySummary(uid);
        final weekly = await supabaseService.fetchWeeklySummary(uid);
        final monthly = await supabaseService.fetchMonthlySummary(uid);
        final profiles = await supabaseService.fetchProfiles(uid);

        setState(() {
          todaySummary = today;
          weeklySummary = weekly;
          monthlySummary = monthly;
          rank = profiles['rank'];
          point = profiles['point'];
        });
      } else {
        print("User ID is null");
      }
    } catch (e) {
      print("Error in _fetchAll: $e");
    }
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }


  Future<void> _fetchTradeAccounts() async {
    try {
      final tradeAccounts = await supabaseService.fetchTradeAccounts(userId: userId);
      setState(() {
        _tradeAccountsFuture = Future.value(tradeAccounts);
      });
    } catch (e) {
      setState(() {
        _tradeAccountsFuture = Future.value([]);
      });
    }
  }

  Future<void> _fetchPayments() async {
    try {
      final payments = await supabaseService.fetchPayments(userId: userId, dateRange: dateRange);
      setState(() {
        _paymentsFuture = Future.value(payments);
      });

    } catch (e) {
      setState(() {
        _paymentsFuture = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = ref.watch(localeProvider).toString();
    final affLink = "https://clicks.affstrack.com/c?c=202738&l=$myLocale&p=1";
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double availableHeight =
        screenHeight - appBarHeight - statusBarHeight - bottomPadding;
    return SafeArea(
      child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
              height: availableHeight,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator()) // ローディングインジケーターを表示
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer // ライトモードの場合はsecondaryContainerの色
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                        // ダークモードの場合もsecondaryContainerの色
                                        borderRadius:
                                            BorderRadius.circular(15.0), // 角の丸み
                                      ),
                                      child: ClipRRect(
                                        // 画像の角をContainerに合わせて丸くする
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        // Containerの角の丸みを設定
                                        child: Image.asset(
                                          'assets/images/face5.png',
                                          fit: BoxFit.cover,
                                          // 画像をContainerいっぱいに表示
                                          width: double.infinity,
                                          // Containerの幅いっぱいに広げる
                                          height: double
                                              .infinity, // Containerの高さいっぱいに広げる
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    child: Container(
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
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    child: Container(
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
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomCard(
                                    lightColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    darkColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    child: Expanded(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          // これを追加して縦方向に中央寄せに
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                URLLauncher.launchURL(context,
                                                    Uri.parse(affLink));
                                              },
                                              child: Container(
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.all(0),
                                                margin: const EdgeInsets.all(0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          S
                                                              .of(context)
                                                              .registerTradingAccount,
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          S
                                                              .of(context)
                                                              .registerTradingAccountSub,
                                                          style:
                                                              const TextStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                    const Icon(
                                                        Icons.chevron_right),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TradingAccountRegistration(),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.all(0),
                                                margin: const EdgeInsets.all(0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            S
                                                                .of(context)
                                                                .verifyAccount,
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            S
                                                                .of(context)
                                                                .registerTradingAccountSub,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Icon(
                                                        Icons.chevron_right),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),










                                Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Column(
                                        children: [

                                          Expanded(
                                            child:Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      color: Colors.yellow,
                                                      child: Center(child: Text('そのいち')),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      color: Colors.green,
                                                      child: Center(child: Text('その２')),
                                                    ),
                                                  ),
                                                ]),
                                          ),

                                          Expanded(
                                            child:Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      color: Colors.red,
                                                      child: Center(child: Text('そのいち')),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      color: Colors.blue,
                                                      child: Center(child: Text('その２')),
                                                    ),
                                                  ),
                                                ]),
                                          ),





                                        ],
                                      ),
                                    )),











                                // Expanded(
                                //   child: CustomCard(
                                //     lightColor: Theme.of(context)
                                //         .colorScheme
                                //         .primaryContainer,
                                //     darkColor: Theme.of(context)
                                //         .colorScheme
                                //         .primaryContainer,
                                //     title: S.of(context).newChatList,
                                //     showAllText: 'Show All',
                                //     // showAllTextColor: Colors.white,// "Show All" テキスト
                                //     onShowAll: () {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) =>
                                //             const ChatPage()),
                                //       );
                                //     },
                                //     child: Expanded(
                                //       child: StreamBuilder<
                                //           List<Map<String, dynamic>>>(
                                //           stream: supabaseService
                                //               .streamMessages(userId),
                                //           builder: (context, snapshot) {
                                //             if (snapshot.connectionState ==
                                //                 ConnectionState.waiting) {
                                //               // データ取得中の場合の処理（例：ローディングインジケーターを表示）
                                //               return const Center(
                                //                 child: SizedBox(
                                //                   width: 60,
                                //                   child: SizedBox(
                                //                     height: 60,
                                //                     child:
                                //                     CircularProgressIndicator(),
                                //                   ),
                                //                 ),
                                //               );
                                //             }
                                //             if (snapshot.hasError) {
                                //               // エラーが発生した場合の処理
                                //               return Text(
                                //                   S.of(context).unknownError);
                                //             }
                                //             if (!snapshot.hasData ||
                                //                 snapshot.data!.isEmpty) {
                                //               // データがない場合の処理
                                //               return Text(
                                //                   S.of(context).noDataFound);
                                //             }
                                //
                                //             final messages = snapshot.data!;
                                //
                                //             return ListView.builder(
                                //               reverse: true,
                                //               itemCount: messages.length,
                                //               itemBuilder: (context, index) {
                                //                 final message = messages[index];
                                //                 final bool isMyMessage =
                                //                     message['sender_id'] ==
                                //                         userId;
                                //                 return Align(
                                //                   alignment: isMyMessage
                                //                       ? Alignment.centerRight
                                //                       : Alignment.centerLeft,
                                //                   child: Container(
                                //                     margin:
                                //                     const EdgeInsets.all(8),
                                //                     padding: const EdgeInsets
                                //                         .symmetric(
                                //                         horizontal: 14,
                                //                         vertical: 10),
                                //                     decoration: BoxDecoration(
                                //                       color: isMyMessage
                                //                           ? Theme.of(context)
                                //                           .colorScheme
                                //                           .primary
                                //                           : Theme.of(context)
                                //                           .colorScheme
                                //                           .secondary,
                                //                       borderRadius: isMyMessage
                                //                           ? const BorderRadius
                                //                           .only(
                                //                         topLeft: Radius
                                //                             .circular(15),
                                //                         topRight: Radius
                                //                             .circular(15),
                                //                         bottomLeft: Radius
                                //                             .circular(15),
                                //                         bottomRight:
                                //                         Radius.zero,
                                //                       )
                                //                           : const BorderRadius
                                //                           .only(
                                //                         topLeft: Radius
                                //                             .circular(15),
                                //                         topRight: Radius
                                //                             .circular(15),
                                //                         bottomLeft:
                                //                         Radius.zero,
                                //                         bottomRight:
                                //                         Radius
                                //                             .circular(
                                //                             15),
                                //                       ),
                                //                     ),
                                //                     child: Column(
                                //                       crossAxisAlignment:
                                //                       CrossAxisAlignment
                                //                           .start,
                                //                       children: [
                                //                         Text(
                                //                           isMyMessage
                                //                               ? message[
                                //                           'message_text']
                                //                               : message[
                                //                           'message_text'] +
                                //                               " 👩🏻‍🦰",
                                //                           style: TextStyle(
                                //                               fontSize: 20.0,
                                //                               color: isMyMessage
                                //                                   ? Theme.of(
                                //                                   context)
                                //                                   .colorScheme
                                //                                   .onPrimary
                                //                                   : Theme.of(
                                //                                   context)
                                //                                   .colorScheme
                                //                                   .onPrimary),
                                //                         ),
                                //                         Text(
                                //                           timeago.format(
                                //                               DateTime.parse(
                                //                                   message[
                                //                                   'created_at']),
                                //                               locale:
                                //                               'en_short'),
                                //                           style: TextStyle(
                                //                             color: isMyMessage
                                //                                 ? Theme.of(
                                //                                 context)
                                //                                 .colorScheme
                                //                                 .onPrimaryContainer
                                //                                 : Theme.of(
                                //                                 context)
                                //                                 .colorScheme
                                //                                 .onPrimaryContainer,
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 );
                                //               },
                                //             );
                                //           }),
                                //     ),
                                //   ),
                                // ),
                                // Expanded(
                                //   child: CustomCard(
                                //     lightColor: Theme.of(context)
                                //         .colorScheme
                                //         .primaryContainer,
                                //     darkColor: Theme.of(context)
                                //         .colorScheme
                                //         .primaryContainer,
                                //     title: S.of(context).newChatList,
                                //     showAllText: 'Show All',
                                //     // showAllTextColor: Colors.white,// "Show All" テキスト
                                //     onShowAll: () {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) =>
                                //                 const ChatPage()),
                                //       );
                                //     },
                                //     child: Expanded(
                                //       child: StreamBuilder<
                                //               List<Map<String, dynamic>>>(
                                //           stream: supabaseService
                                //               .streamMessages(userId),
                                //           builder: (context, snapshot) {
                                //             if (snapshot.connectionState ==
                                //                 ConnectionState.waiting) {
                                //               // データ取得中の場合の処理（例：ローディングインジケーターを表示）
                                //               return const Center(
                                //                 child: SizedBox(
                                //                   width: 60,
                                //                   child: SizedBox(
                                //                     height: 60,
                                //                     child:
                                //                         CircularProgressIndicator(),
                                //                   ),
                                //                 ),
                                //               );
                                //             }
                                //             if (snapshot.hasError) {
                                //               // エラーが発生した場合の処理
                                //               return Text(
                                //                   S.of(context).unknownError);
                                //             }
                                //             if (!snapshot.hasData ||
                                //                 snapshot.data!.isEmpty) {
                                //               // データがない場合の処理
                                //               return Text(
                                //                   S.of(context).noDataFound);
                                //             }
                                //
                                //             final messages = snapshot.data!;
                                //
                                //             return ListView.builder(
                                //               reverse: true,
                                //               itemCount: messages.length,
                                //               itemBuilder: (context, index) {
                                //                 final message = messages[index];
                                //                 final bool isMyMessage =
                                //                     message['sender_id'] ==
                                //                         userId;
                                //                 return Align(
                                //                   alignment: isMyMessage
                                //                       ? Alignment.centerRight
                                //                       : Alignment.centerLeft,
                                //                   child: Container(
                                //                     margin:
                                //                         const EdgeInsets.all(8),
                                //                     padding: const EdgeInsets
                                //                         .symmetric(
                                //                         horizontal: 14,
                                //                         vertical: 10),
                                //                     decoration: BoxDecoration(
                                //                       color: isMyMessage
                                //                           ? Theme.of(context)
                                //                               .colorScheme
                                //                               .primary
                                //                           : Theme.of(context)
                                //                               .colorScheme
                                //                               .secondary,
                                //                       borderRadius: isMyMessage
                                //                           ? const BorderRadius
                                //                               .only(
                                //                               topLeft: Radius
                                //                                   .circular(15),
                                //                               topRight: Radius
                                //                                   .circular(15),
                                //                               bottomLeft: Radius
                                //                                   .circular(15),
                                //                               bottomRight:
                                //                                   Radius.zero,
                                //                             )
                                //                           : const BorderRadius
                                //                               .only(
                                //                               topLeft: Radius
                                //                                   .circular(15),
                                //                               topRight: Radius
                                //                                   .circular(15),
                                //                               bottomLeft:
                                //                                   Radius.zero,
                                //                               bottomRight:
                                //                                   Radius
                                //                                       .circular(
                                //                                           15),
                                //                             ),
                                //                     ),
                                //                     child: Column(
                                //                       crossAxisAlignment:
                                //                           CrossAxisAlignment
                                //                               .start,
                                //                       children: [
                                //                         Text(
                                //                           isMyMessage
                                //                               ? message[
                                //                                   'message_text']
                                //                               : message[
                                //                                       'message_text'] +
                                //                                   " 👩🏻‍🦰",
                                //                           style: TextStyle(
                                //                               fontSize: 20.0,
                                //                               color: isMyMessage
                                //                                   ? Theme.of(
                                //                                           context)
                                //                                       .colorScheme
                                //                                       .onPrimary
                                //                                   : Theme.of(
                                //                                           context)
                                //                                       .colorScheme
                                //                                       .onPrimary),
                                //                         ),
                                //                         Text(
                                //                           timeago.format(
                                //                               DateTime.parse(
                                //                                   message[
                                //                                       'created_at']),
                                //                               locale:
                                //                                   'en_short'),
                                //                           style: TextStyle(
                                //                             color: isMyMessage
                                //                                 ? Theme.of(
                                //                                         context)
                                //                                     .colorScheme
                                //                                     .onPrimaryContainer
                                //                                 : Theme.of(
                                //                                         context)
                                //                                     .colorScheme
                                //                                     .onPrimaryContainer,
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 );
                                //               },
                                //             );
                                //           }),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomCard(
                                    showAllText: 'Show All',
                                    // "Show All" テキスト
                                    onShowAll: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PaymentListPage()),
                                      );
                                    },
                                    lightColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    darkColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    title: S.of(context).paymentsPageTitle,
                                    child: Expanded(
                                      child: FutureBuilder<
                                          List<Map<String, dynamic>>>(
                                        future: _paymentsFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: Center(
                                                    child: Text(S
                                                        .of(context)
                                                        .unknownError)));
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0.0),
                                                child: Center(
                                                    child: Text(S
                                                        .of(context)
                                                        .noDataFound)));
                                          } else {
                                            final payments = snapshot.data!;
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: payments.length,
                                              itemBuilder: (context, index) {
                                                final payment = payments[index];
                                                return Card(
                                                  elevation: 9,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  margin:
                                                      const EdgeInsets.all(5.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .surfaceTint,
                                                        child: Icon(
                                                          Icons.payments,
                                                          size: 30,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .surfaceContainerHighest,
                                                        ), // アイコンの色
                                                      ),
                                                      title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Row(children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(DateFormat(
                                                                        'yyyy/MM/dd')
                                                                    .format(DateTime.parse(
                                                                        payment[
                                                                            'payment_date']))),
                                                                Text(payment[
                                                                    'mt4_id']),
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            // 中央のスペース
                                                            Text(
                                                              '\$${payment['amount'].toStringAsFixed(2)}',
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ]),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: CustomCard(
                                    showAllText: 'Show All',
                                    // "Show All" テキスト
                                    onShowAll: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TradingAccountsListPage()),
                                      );
                                    },
                                    lightColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    darkColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    title: S.of(context).accountListPageTitle,
                                    child: Expanded(
                                      child: FutureBuilder<
                                          List<Map<String, dynamic>>>(
                                        future: _tradeAccountsFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: Center(
                                                    child: Text(S
                                                        .of(context)
                                                        .unknownError)));
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0.0),
                                                child: Center(
                                                    child: Text(S
                                                        .of(context)
                                                        .noDataFound)));
                                          } else {
                                            final tradeAccounts =
                                                snapshot.data!;
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: tradeAccounts.length,
                                              itemBuilder: (context, index) {
                                                final tradeAccount =
                                                    tradeAccounts[index];
                                                return Card(
                                                  elevation: 9,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  margin:
                                                      const EdgeInsets.all(5.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: ListTile(
                                                      onTap: () async {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditTradingAccountPage(
                                                                    accountData:
                                                                        tradeAccount),
                                                          ),
                                                        );
                                                      },
                                                      leading: CircleAvatar(
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .surfaceTint,
                                                        child: Icon(
                                                          getStatusIcon(
                                                              tradeAccount[
                                                                  'status']),
                                                          size: 30,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .surfaceContainerHighest,
                                                        ), // アイコンの色を白に設定
                                                      ),
                                                      title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Row(children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(DateFormat(
                                                                        'yyyy/MM/dd')
                                                                    .format(DateTime.parse(
                                                                        tradeAccount[
                                                                            'updated_at']))),
                                                                Text(getStatusText(
                                                                    context,
                                                                    tradeAccount[
                                                                        'status']))
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            // 中央のスペース
                                                            Text(
                                                              '${tradeAccount['account_number']}',
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ]),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))),
    );
  }
}
