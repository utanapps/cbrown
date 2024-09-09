import 'package:flutter/material.dart';
import 'package:baseapp/generated/l10n.dart'; // Sクラスが生成される場所

IconData getStatusIcon(String status) {
  switch (status) {
    case 'pending':
      return Icons.more_horiz;
    case 'approved':
      return Icons.done;
    case 'rejected':
      return Icons.close;
    case 'on_hold':
      return Icons.stop;
    default:
      return Icons.help_outline;
  }
}

String getStatusText(BuildContext context, String status) {
  switch (status) {
    case 'pending':
      return S.of(context).pending;
    case 'approved':
      return S.of(context).approved;
    case 'rejected':
      return S.of(context).rejected;
    case 'on_hold':
      return S.of(context).onHold;
    default:
      return S.of(context).pending;
  }
}
