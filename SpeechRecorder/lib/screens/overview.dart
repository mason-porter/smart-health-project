import 'package:flutter/material.dart';

class OverviewWidget extends StatelessWidget {
  final String username;
  final VoidCallback logout;

  const OverviewWidget({
    Key? key,
    required this.username,
    required this.logout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is $username\'s overview page.'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: logout,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
