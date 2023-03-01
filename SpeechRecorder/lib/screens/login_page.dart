import 'package:flutter/material.dart';
import 'tab_menu.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please log in'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // simulate successful login
                Navigator.pushReplacementNamed(context, MainTabMenu.routeName);
              },
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
