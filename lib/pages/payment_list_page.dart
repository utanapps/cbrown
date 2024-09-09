import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:intl/intl.dart';
import 'package:baseapp/components/no_data_found.dart';
import 'package:baseapp/components/has_error.dart';

class PaymentListPage extends ConsumerStatefulWidget {
  const PaymentListPage({super.key});

  @override
  ConsumerState<PaymentListPage> createState() => PaymentListPageState();
}

class PaymentListPageState extends ConsumerState<PaymentListPage> {
  Future<List<Map<String, dynamic>>>? _paymentsFuture;
  DateTimeRange? dateRange;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _paymentsFuture = _fetchPayments();
  }

  Future<List<Map<String, dynamic>>> _fetchPayments() async {
    setState(() => _isLoading = true); // ローディング開始
    try {
      // 取引口座の登録処理
      final supabaseService = ref.read(supabaseServiceProvider);
      final userId = supabaseService.supabase.auth.currentUser!.id;

      return await supabaseService.fetchPayments(
          userId: userId, dateRange: dateRange);
    } catch (e) {
      return [];
    } finally {
      setState(() => _isLoading = false); // ローディング終了
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != dateRange) {
      setState(() {
        dateRange = picked;
        _paymentsFuture = _fetchPayments(); // Refresh the payment list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).paymentsPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range, size: 30.0),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _paymentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const HasErrorWidget();
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const NoDataFoundWidget();
                } else {
                  final payments = snapshot.data!;
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 720.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // 子ウィジェットを左寄せにする
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: payments.length,
                              itemBuilder: (context, index) {
                                final payment = payments[index];
                                return Card(
                                  elevation: 9,
                                  shadowColor: Colors.transparent,
                                  margin: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceTint,
                                        child: Icon(
                                          Icons.payments,
                                          size: 30,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHighest,
                                        ), // アイコンの色
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
                                                Text(DateFormat('yyyy/MM/dd')
                                                    .format(DateTime.parse(
                                                        payment[
                                                            'payment_date']))),
                                                Row(
                                                  children: [
                                                    Text(payment['mt4_id']),
                                                    const SizedBox(width: 5.0),
                                                    const Text('Auto'),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const Spacer(), // 中央のスペース
                                            Text(
                                              '\$${payment['amount'].toStringAsFixed(2)}',
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
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
