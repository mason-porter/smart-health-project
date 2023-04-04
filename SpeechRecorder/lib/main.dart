import 'package:flutter/material.dart';
import 'screens/tab_menu.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'services/database/database.dart';
import 'screens/gyroscope_test.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const EntryRoot());
}

class EntryRoot extends StatefulWidget {
  const EntryRoot({Key? key}) : super(key: key);

  @override
  EntryRootState0 createState() => EntryRootState0();
}

class EntryRootState0 extends State<EntryRoot> {
  late final dbHelper = DatabaseHelper();
  final name = String;

  @override
  void initState() {
    super.initState();
    // perform any initialization here
  }

  int _loggedUserId = -1;
  String _loggedName = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginPage.routeName, // set initial route to LoginPage
      routes: {
        LoginPage.routeName: (context) => LoginPage(
            db: dbHelper,
            idCallback: (val) => {
                  setState(() => {_loggedUserId = val}),
                },
            nameCallback: (val) => {
                  setState(() => {_loggedName = val})
                },
            gotoSignup: () =>
                {Navigator.pushNamed(context, SignupPage.routeName)}),
        SignupPage.routeName: (context) => SignupPage(
            db: dbHelper, gotoLogin: () => ({Navigator.pop(context)})),
        MainTabMenu.routeName: (context) => MainTabMenu(
              db: dbHelper,
              uid: _loggedUserId,
              uname: _loggedName,
              logout: () => ({
                setState(() => {_loggedUserId = -1}),
                setState(() => {_loggedName = ""}),
                Navigator.pushReplacementNamed(context, LoginPage.routeName)
              }),
            ),
      },
    );
  }
}
