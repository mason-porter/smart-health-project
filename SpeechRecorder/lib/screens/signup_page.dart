import 'package:flutter/material.dart';
import 'tab_menu.dart';
import '../classes/user.dart';
import '../services/database/database.dart';
import 'dart:async';

typedef void VoidCallback();

class SignupPage extends StatelessWidget {
  static const routeName = '/signup';
  final DatabaseHelper db;
  final VoidCallback gotoLogin;

  SignupPage({required this.db, required this.gotoLogin, Key? key})
      : super(key: key);

  final nameControl = TextEditingController();
  final unameControl = TextEditingController();
  final passControl = TextEditingController();
  final passcControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter your information to sign up!'),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 25.0),
              child: TextField(
                controller: nameControl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Real Name*',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 10.0),
              child: TextField(
                controller: unameControl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username*',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: TextField(
                obscureText: true,
                controller: passControl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password*',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: TextField(
                obscureText: true,
                controller: passcControl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Confirm Password*',
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Sign Up'),
              onPressed: () async {
                List<User> users = await db.getUsersByUname(unameControl.text);
                if (nameControl.text == "") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Error'),
                        content: Text('The name cannot be empty.'),
                      );
                    },
                  );
                } else if (unameControl.text == "") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Error'),
                        content: Text('The username cannot be empty.'),
                      );
                    },
                  );
                } else if (passControl.text != passcControl.text) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Error'),
                        content: Text('Passwords do not match.'),
                      );
                    },
                  );
                } else if (passControl.text == "") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Error'),
                        content: Text('Password cannot be empty.'),
                      );
                    },
                  );
                } else if (users.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Error'),
                        content: Text('Username is taken!'),
                      );
                    },
                  );
                } else {
                  User newUser = User();
                  newUser.name = nameControl.text;
                  newUser.uname = unameControl.text;
                  newUser.password = passControl.text;
                  newUser.admin = false;
                  int id = await db.saveUser(newUser);
                  gotoLogin();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('All Set!'),
                        content: Text('You have been signed up!'),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
