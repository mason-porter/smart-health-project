import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'package:record_with_play/providers/play_audio_provider.dart';
import 'package:record_with_play/providers/record_audio_provider.dart';
import 'package:record_with_play/screens/record_and_play_audio3.dart';

class RecordWidget extends StatelessWidget {
  const RecordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordAudioProvider()),
        ChangeNotifierProvider(create: (_) => PlayAudioProvider()),
      ],
      child: ElevatedButton(
        onPressed: () {
          // simulate successful login

          Navigator.pushReplacementNamed(context, LoginPage.routeName);
        },
        child: const Text('Log in'),
      ),
      /*
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Record and Play',
        home: RecordAndPlayScreen(),
      ),
      */
    );
  }
}
