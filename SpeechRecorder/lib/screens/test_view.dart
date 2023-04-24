import 'package:flutter/material.dart';
import '../classes/test.dart';
import '../classes/user.dart';
import '../services/database/database.dart';
import 'package:intl/intl.dart';

typedef void VoidCallback();

class TestView extends StatelessWidget {
  static const routeName = '/testview';

  final DatabaseHelper db;
  Test? test;
  final VoidCallback refreshCallback;

  TestView({
    Key? key,
    required this.db,
    required this.test,
    required this.refreshCallback,
  }) : super(key: key);

  Future<User> getUser() async {
    User user = await db.searchUserById(test?.oId ?? -1);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    if (test != null) {
      return FutureBuilder(
          future: getUser(),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while the function is running
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    await db.deleteTestById(test?.id ?? -1);
                    refreshCallback();
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.delete),
                ),
                appBar: AppBar(
                  title: Text('Test ' + (test?.id.toString() ?? "null")),
                ),
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'User: ' +
                          (snapshot.data?.name ?? "") +
                          ' (' +
                          (snapshot.data?.uname ?? "") +
                          ')',
                      style: const TextStyle(fontSize: 34.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      DateFormat('MM/dd/yy hh:mm:ss aaa').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              (test?.date ?? 0) * 1000)),
                      style: const TextStyle(fontSize: 26.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Single-Leg Score: ' + (test?.scoreS.toString() ?? "0"),
                      style: const TextStyle(fontSize: 22.0),
                    ),
                    Text(
                      'Left-Leg Score: ' + (test?.scoreL.toString() ?? "0"),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      'Right-Leg Score: ' + (test?.scoreR.toString() ?? "0"),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Both-Leg Score: ' + (test?.scoreB.toString() ?? "0"),
                      style: const TextStyle(fontSize: 22.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Final Score: ' + (test?.scoreFinal.toString() ?? "0"),
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
              );
            }
          });
    }
    return const Scaffold();
  }
}
