import 'package:flutter/material.dart';
import 'tab_menu.dart';
import '../classes/user.dart';
import '../services/database/database.dart';
import 'dart:async';

typedef void IntCallback(int val);
typedef void StringCallback(String val);
typedef void VoidCallback();

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  final DatabaseHelper db;
  final IntCallback idCallback;
  final StringCallback nameCallback;
  final VoidCallback gotoSignup;

  LoginPage(
      {required this.db,
      required this.idCallback,
      required this.nameCallback,
      required this.gotoSignup,
      Key? key})
      : super(key: key);

  final unameControl = TextEditingController();
  final passControl = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 8.0),
              child: TextField(
                controller: unameControl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passControl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // simulate successful login
                      List<User> users =
                          await db.getUsersByUname(unameControl.text);
                      if (users.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text("User '" +
                                  unameControl.text +
                                  "' is not found!"),
                            );
                          },
                        );
                      } else {
                        User toLogin = users[0];
                        if (toLogin.password != passControl.text) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text('Error'),
                                content: Text("Password is incorrect"),
                              );
                            },
                          );
                        } else {
                          idCallback(toLogin.id ?? -1);
                          nameCallback(toLogin.name ?? '<null>');
                          Navigator.pushReplacementNamed(
                              context, MainTabMenu.routeName);
                        }
                      }
                    },
                    child: const Text('Log in'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Create Account'),
                    onPressed: () async {
                      gotoSignup();
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
                child: const Text('DEBUG Show Users'),
                onPressed: () async {
                  Future<List<User>> fUsers = db.getUsers();
                  List<User> users = await fUsers;
                  for (User user in users) {
                    debugPrint(user.toString());
                  }
                }),
            ElevatedButton(
              child: const Text('DEBUG Show Tables'),
              onPressed: () async {
                db.debugPrintTables();
              },
            ),
          ],
        ),
      ),
    );
  }
}
