import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:baseapp/generated/l10n.dart';

class URLLauncher {
  static Future<void> launchURL(BuildContext context, Uri url) async {
    String errorMessage = S.of(context).couldNotLaunch;
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw '$errorMessage $url';
    }
  }
}
