import 'package:flutter/material.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:baseapp/pages/trading_accounts_list_page.dart';
import 'package:baseapp/pages/payment_list_page.dart';
import 'package:baseapp/pages/chat_page.dart';
import 'package:baseapp/pages/trading_account_registration.dart';
import 'package:baseapp/pages/trades.dart';
import 'package:baseapp/pages/dashboard_mobile.dart';
import 'package:baseapp/pages/dashboard_tablet.dart';
import 'package:baseapp/pages/settings_page.dart';
import 'package:baseapp/components/language_selection_dialog.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  late final SupabaseService supabaseService;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider);
    final user = supabaseService.getCurrentUser();
    supabaseService.setUserToProvider(user!.id, ref);
  }

  void _updateWidgetOptions() {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final bool isWideScreen = screenWidth >= 1024;

    // 画面幅に応じてダッシュボードを動的に切り替え
    _widgetOptions = <Widget>[
      isWideScreen ? const DashboardTablet() : const Dashboard(),
      const TradingAccountsListPage(),
      const PaymentListPage(),
      const TradesList(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateWidgetOptions();
  }


  @override
  void dispose() {
    super.dispose();
  }



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth >= 1024;

    // 画面幅に応じてダッシュボードを動的に切り替え


    return Scaffold(
      appBar: AppBar(
        title: Text(screenWidth.toString()),
        leadingWidth: 100,
        leading: SizedBox(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            child: Image.asset('assets/images/sega2.png', fit: BoxFit.contain),
          ),
        ),
        actions: [
          IconButton(
            tooltip: S.of(context).openSupportChat,
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChatPage(),
                ),
              );
            },
            icon: Icon(
              PhosphorIcons.headset(),
              size: 24,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              showLanguageSelectionDialog(context, ref);
            },
            tooltip: 'language',
            highlightColor: Colors.blue[200],
            splashColor: Colors.blue[300],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recent_actors),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Transactions',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedLabelStyle: const TextStyle(
            color: Color(0xffffffff), fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(
            color: Color(0xffffffff), fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        // onPressed: () {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => const TradingAccountRegistration(),
        //     ),
        //   );
        // },
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TradingAccountRegistration(),
            ),
          );

          // 結果を受け取って必要な更新を行う
          if (result != null && result == true) {
            setState(() {
              _updateWidgetOptions();
              _selectedIndex = 1; // TradingAccountsListPageのインデックス
            });
          }
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
