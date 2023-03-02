import 'package:flutter/material.dart';
import 'tab_menu.dart';
import '../classes/user.dart';
import '../services/database/database.dart';
import 'dart:async';

typedef void IntCallback(int val);

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  final DatabaseHelper db;
  final IntCallback idCallback;

  LoginPage({required this.db, required this.idCallback, Key? key})
      : super(key: key);

  final unameControl = TextEditingController();

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
            TextField(
              controller: unameControl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // simulate successful login
                int id = await db.searchIdByUser(unameControl.text);
                if (id != -1) {
                  idCallback(id);
                  Navigator.pushReplacementNamed(
                      context, MainTabMenu.routeName);
                }
              },
              child: const Text('Log in'),
            ),
            ElevatedButton(
              child: const Text('Create User'),
              onPressed: () async {
                User newUser = User();
                newUser.name = unameControl.text;
                int id = await db.saveUser(newUser);
                Future<List<User>> fUsers = db.getUsers();
                List<User> users = await fUsers;
                for (User user in users) {
                  debugPrint(user.toString());
                }
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text('Your username is: ' + unameControl.text),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
