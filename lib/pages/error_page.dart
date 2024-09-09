import 'package:flutter/material.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/pages/login.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  const ErrorPage({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ERROR',
              style: TextStyle(color: Colors.red, fontSize: 40),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/sad.png', width: 200, height: 200),
            const SizedBox(height: 20),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text(S.of(context).close), // 多言語対応の閉じるボタン
            ),
          ],
        ),
      ),
    );
  }
}
