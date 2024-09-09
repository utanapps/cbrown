import 'package:flutter/material.dart';
import 'package:baseapp/generated/l10n.dart';

class HasErrorWidget extends StatelessWidget {
  const HasErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Text(S.of(context).unknownError),
      ),
    );
  }
}
