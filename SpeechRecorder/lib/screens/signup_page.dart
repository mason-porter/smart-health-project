import 'package:flutter/material.dart';
import 'tab_menu.dart';
import '../classes/user.dart';
import '../services/database/database.dart';
import 'dart:async';

typedef void VoidCallback();

class SignupPage extends StatefulWidget {
  static const routeName = '/signup';
  final DatabaseHelper db;
  final VoidCallback gotoLogin;

  SignupPage({required this.db, required this.gotoLogin, Key? key})
      : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameControl = TextEditingController();
  final unameControl = TextEditingController();
  final passControl = TextEditingController();
  final passcControl = TextEditingController();

  bool _adminCheck = false;

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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Admin?'),
              Checkbox(
                value: _adminCheck,
                onChanged: (bool? value) {
                  setState(() {
                    _adminCheck = value ?? false;
                  });
                },
              ),
            ]),
            ElevatedButton(
              child: const Text('Sign Up'),
              onPressed: () async {
                List<User> users =
                    await widget.db.getUsersByUname(unameControl.text);
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
                  newUser.admin = _adminCheck;
                  int id = await widget.db.saveUser(newUser);
                  widget.gotoLogin();
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
