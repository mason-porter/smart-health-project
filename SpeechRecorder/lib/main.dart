import 'package:flutter/material.dart';
import 'screens/tab_menu.dart';
import 'screens/login_page.dart';
import 'services/database/database.dart';

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
                debugPrint("MID: " + val.toString()),
              },
            ),
        MainTabMenu.routeName: (context) => const MainTabMenu(),
      },
    );
  }
}


/**
void main() {
  runApp(EntryRoot());
}

class EntryRoot extends StatelessWidget {
  EntryRoot({Key? key}) : super(key: key);
  late final dbHelper = DatabaseHelper();
  final name = String;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginPage.routeName, // set initial route to LoginPage
      routes: {
        LoginPage.routeName: (context) => LoginPage(db: dbHelper),
        MainTabMenu.routeName: (context) => const MainTabMenu(),
      },
    );
  }
}
**/
