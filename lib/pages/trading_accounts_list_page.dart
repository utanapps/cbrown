import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/components/no_data_found.dart';
import 'package:baseapp/components/has_error.dart';
import 'package:baseapp/pages/trading_account_edit_page.dart';

import '../utils/status_helper.dart';

class TradingAccountsListPage extends ConsumerStatefulWidget {
  const TradingAccountsListPage({super.key});

  @override
  ConsumerState<TradingAccountsListPage> createState() =>
      _TradingAccountsListPageState();
}

class _TradingAccountsListPageState
    extends ConsumerState<TradingAccountsListPage> {
  Future<List<Map<String, dynamic>>>? _tradeAccountsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tradeAccountsFuture = _fetchTradeAccounts();
  }

  Future<List<Map<String, dynamic>>> _fetchTradeAccounts() async {
    setState(() => _isLoading = true); // ローディング開始
    try {
      // 取引口座の登録処理
      final supabaseService = ref.read(supabaseServiceProvider);
      final userId = supabaseService.supabase.auth.currentUser!.id;

      return await supabaseService.fetchTradeAccounts(userId: userId);
    } catch (e) {
      return [];
    } finally {
      setState(() => _isLoading = false); // ローディング終了
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).accountListPageTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _tradeAccountsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                  // return const Center(child: Text('neko'));
                } else if (snapshot.hasError) {
                  return const HasErrorWidget();
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const NoDataFoundWidget();
                } else {
                  final tradeAccounts = snapshot.data!;
                  return Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // 子ウィジェットを左寄せにする
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: tradeAccounts.length,
                          itemBuilder: (context, index) {
                            final tradeAccount = tradeAccounts[index];
                            return Card(
                              elevation: 9,
                              shadowColor: Colors.transparent,
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ListTile(
                                  onTap: () async {
                                    // if (tradeAccount['status'] != 'approved') {
                                    //   await Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) =>
                                    //     EditTradingAccountPage(accountData: tradeAccount),
                                    //     ),
                                    //   );}
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditTradingAccountPage(
                                                accountData: tradeAccount),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint,
                                    child: Icon(
                                      getStatusIcon(tradeAccount['status']),
                                      size: 30,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest,
                                    ), // アイコンの色を白に設定
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  DateFormat('yyyy/MM/dd')
                                                      .format(DateTime.parse(
                                                          tradeAccount[
                                                              'updated_at'])),
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                                Text(getStatusText(context,
                                                    tradeAccount['status']))
                                              ],
                                            )
                                          ],
                                        ),
                                        const Spacer(), // 中央のスペース
                                        Text(
                                          '${tradeAccount['account_number']}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }
}
