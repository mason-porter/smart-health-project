import 'package:flutter/material.dart';
import 'record_widget.dart';

class MainTabMenu extends StatelessWidget {
  static const routeName = '/main';

  const MainTabMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Insert App Name Here'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'History', icon: Icon(Icons.history)),
                Tab(text: 'Overview', icon: Icon(Icons.person)),
                Tab(text: 'New Test', icon: Icon(Icons.post_add_rounded)),
              ],
            ),
            // backgroundColor: const Color(0xff2059ff),
          ),
          body: const TabBarView(
            children: [
              RecordWidget(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
