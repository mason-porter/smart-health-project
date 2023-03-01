import 'package:flutter/material.dart';
import 'screens/tab_menu.dart';
import 'screens/login_page.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const EntryRoot());
}

class EntryRoot extends StatelessWidget {
  const EntryRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginPage.routeName, // set initial route to LoginPage
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        MainTabMenu.routeName: (context) => const MainTabMenu(),
      },
    );
  }
}
