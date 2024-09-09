import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

// アプリの現在のバージョンを直接定義する
final currentVersionProvider = Provider<String>((ref) => '1.0.0');

final versionProvider = FutureProvider<String>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return await service.fetchLatestVersion();
});

class VersionCheckComponent extends ConsumerWidget {
  const VersionCheckComponent({super.key});

  void _launchURL(BuildContext context, String urlString) async {
    final myMessenger = ScaffoldMessenger.of(context);
    final Uri url = Uri.parse(urlString);
    if (!await canLaunchUrl(url)) {
      myMessenger
          .showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
    } else {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVersion = ref.watch(currentVersionProvider);
    final versionAsyncValue = ref.watch(versionProvider);

    return versionAsyncValue.when(
      data: (latestVersion) {
        if (currentVersion != latestVersion) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(S.of(context).versionCheckTitle),
                content: Text(S.of(context).versionCheckContent),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(S.of(context).laterButton),
                  ),
                  TextButton(
                    onPressed: () {
                      // アップデートページへリダイレクトする処理
                      const iosUrl =
                          'https://apps.apple.com/app/idYOUR_IOS_APP_ID';
                      const androidUrl =
                          'https://play.google.com/store/apps/details?id=YOUR_ANDROID_PACKAGE_NAME';
                      final url =
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? iosUrl
                              : androidUrl;
                      _launchURL(context, url);
                      Navigator.of(context).pop();
                    },
                    child: Text(S.of(context).updateButton),
                  ),
                ],
              ),
            );
          });
        }
        return Container(); // バージョンが同じ、またはダイアログ表示後は何も表示しない
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text(S.of(context).errorMessage),
    );
  }
}
