import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/models/trade.dart';
import 'package:intl/intl.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/components/no_data_found.dart';
import 'package:baseapp/components/has_error.dart';
import 'package:baseapp/enum/date_filter.dart';
import 'package:baseapp/providers/supabase_service.dart';

import '../components/custom_show_dialog.dart';

class TradesList extends ConsumerStatefulWidget {
  const TradesList({super.key});

  @override
  TradesListState createState() => TradesListState();
}

class TradesListState extends ConsumerState<TradesList> {
  late Future<List<Trade>> futureTrades;
  DateFilter selectedFilter = DateFilter.today;
  DateTime? startDate;
  DateTime? endDate;
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数
  String userId = "";

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider);
    userId = supabaseService.supabase.auth.currentUser!.id;
    futureTrades = _fetchTrades();
  }

  Future<List<Trade>> _fetchTrades() async {
    try {
      return await supabaseService.fetchTrades(
        userId: userId,
        selectedFilter: selectedFilter,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      if (mounted) {
        showCustomDialog(
          context: context,
          title: S.of(context).errorLabel,
          message: S.of(context).error,
        );
      }
      return []; // Return an empty list as a fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SegmentedButton<int>(
                    onSelectionChanged: (Set<int> indexSet) {
                      final index = indexSet.first; // 選択されたセグメントのインデックスを取得
                      setState(() {
                        selectedFilter = DateFilter.values[index];
                        if (selectedFilter == DateFilter.custom) {
                          showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            initialDateRange:
                                startDate != null && endDate != null
                                    ? DateTimeRange(
                                        start: startDate!, end: endDate!)
                                    : null,
                          ).then((DateTimeRange? pickedRange) {
                            if (pickedRange != null) {
                              setState(() {
                                startDate = pickedRange.start;
                                endDate = pickedRange.end;
                                futureTrades = _fetchTrades(); // データの再フェッチ
                              });
                            }
                          });
                        } else {
                          futureTrades =
                              _fetchTrades(); // 他のフィルターオプションが選択された場合、データの再フェッチ
                        }
                      });
                    },
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(value: 0, label: Text(S.of(context).today)),
                      ButtonSegment(
                          value: 1, label: Text(S.of(context).thisWeek)),
                      ButtonSegment(
                          value: 2, label: Text(S.of(context).lastWeek)),
                    ],
                    selected: {selectedFilter.index}, // 現在選択されているフィルタのindex
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffffffff),
                      shape: BoxShape.circle, // Set the shape to a circle
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.date_range, size: 30.0),
                      onPressed: () {
                        showCustomDateSelection(); // Display the custom date selection dialog
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // この行を追加

          children: [
            Expanded(
              child: FutureBuilder<List<Trade>>(
                future: futureTrades,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    if (kDebugMode) {
                      print(snapshot.error.toString());
                    }
                    return const HasErrorWidget();
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const NoDataFoundWidget();
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Trade trade = snapshot.data![index];
                        return Card(
                          elevation: 9,
                          shadowColor: Colors.transparent,
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surfaceTint,
                                child: Icon(Icons.money,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    size: 30), // アイコンの色を白に設定
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${DateFormat('yyyy/MM/dd').format(trade.closetime!)} - ${trade.mt4Id} ',
                                          style:
                                              const TextStyle(fontSize: 14.0),
                                        ),
                                        Text('${trade.instrument}'),
                                      ],
                                    ),
                                    const Spacer(), // 中央のスペース
                                    Text(
                                      '\$${trade.totalComm?.toStringAsFixed(2) ?? 'N/A'}',
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
                    );
                  } else {
                    return const Center(child: Text("No data available"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomDateSelection() async {
    final DateTime firstSelectableDate = DateTime(2000);
    final DateTime lastSelectableDate = DateTime.now();

    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: firstSelectableDate,
      lastDate: lastSelectableDate,
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (pickedRange != null) {
      setState(() {
        startDate = pickedRange.start; // 選択された開始日
        endDate = pickedRange.end; // 選択された終了日
        selectedFilter = DateFilter.custom; // 選択フィルターをカスタムに設定
        futureTrades = _fetchTrades(); // データの再フェッチ
      });
    }
  }
}
