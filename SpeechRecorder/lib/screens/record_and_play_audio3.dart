import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:record_with_play/providers/play_audio_provider.dart';
import 'package:record_with_play/providers/record_audio_provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class RecordAndPlayScreen extends StatefulWidget {
  const RecordAndPlayScreen({Key? key}) : super(key: key);

  @override
  State<RecordAndPlayScreen> createState() => _RecordAndPlayScreenState();
}

class _RecordAndPlayScreenState extends State<RecordAndPlayScreen> {
  customizeStatusAndNavigationBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
  }

  @override
  void initState() {
    customizeStatusAndNavigationBar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);
    final _playProvider = Provider.of<PlayAudioProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2012/7/25/4/FNM_090112-Peanut-Butter-and-Jelly-Sandwich-Cake-Recipe_s4x3.jpg.rend.hgtvcom.616.462.suffix/1382541616148.jpeg"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            _recordProvider.recordedFilePath.isEmpty
                ? _recordHeading()
                : _playAudioHeading(),
            const SizedBox(height: 20),
            _recordProvider.recordedFilePath.isEmpty
                ? _recordingSection()
                : _audioPlayingSection(),
            if (_recordProvider.recordedFilePath.isNotEmpty &&
                !_playProvider.isRecordingPlaying)
              const SizedBox(height: 10),
            if (_recordProvider.recordedFilePath.isNotEmpty &&
                !_playProvider.isRecordingPlaying)
              _resetButton(),
            const SizedBox(height: 420),
            _recordProvider.recordedFilePath.isEmpty
                ? _recordInstructions()
                : _resetInstructions(),
          ],
        ),
      ),
    );
  }

  _recordHeading() {
    return const Center(
      child: Text(
        'Record Audio',
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }

  _playAudioHeading() {
    return const Center(
      child: Text(
        'Play Audio',
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }

  _recordingSection() {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);
    final _recordProviderWithoutListener =
        Provider.of<RecordAudioProvider>(context, listen: false);

    if (_recordProvider.isRecording) {
      return InkWell(
        onTap: () async => await _recordProviderWithoutListener.stopRecording(),
        child: RippleAnimation(
          repeat: true,
          color: const Color(0xff4BB543),
          minRadius: 50,
          ripplesCount: 6,
          child: _commonIconSection(),
        ),
      );
    }

    return InkWell(
      onTap: () async => await _recordProviderWithoutListener.recordVoice(),
      child: _commonIconSection(),
    );
  }

  _commonIconSection() {
    return Container(
      width: 90,
      height: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff4BB543),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Icon(Icons.keyboard_voice_rounded,
          color: Colors.white, size: 55),
    );
  }

  _audioPlayingSection() {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width - 110,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _audioControllingSection(_recordProvider.recordedFilePath),
          _audioProgressSection(),
        ],
      ),
    );
  }

  _audioControllingSection(String RecordingPath) {
    final _playProvider = Provider.of<PlayAudioProvider>(context);
    final _playProviderWithoutListen =
        Provider.of<PlayAudioProvider>(context, listen: false);

    return IconButton(
      onPressed: () async {
        if (RecordingPath.isEmpty) return;

        await _playProviderWithoutListen.playAudio(File(RecordingPath));
      },
      icon: Icon(
          _playProvider.isRecordingPlaying ? Icons.pause : Icons.play_arrow_rounded),
      color: const Color(0xff4BB543),
      iconSize: 30,
    );
  }

  _audioProgressSection() {
    final _playProvider = Provider.of<PlayAudioProvider>(context);

    return Expanded(
        child: Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: LinearPercentIndicator(
          percent: _playProvider.currLoadingStatus,
          backgroundColor: Colors.black,
          progressColor: const Color(0xff4BB543),
      ),
    ));
  }

  _resetButton() {
    final _recordProvider = Provider.of<RecordAudioProvider>(context, listen: false);

    return InkWell(
      onTap: () => _recordProvider.clearOldData(),
      child: Center(
        child: Container(
          width: 90,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Reset',
            style: TextStyle(fontSize:22, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    );
  }

  _recordInstructions() {
    return const Center(
      child: Text(
        'Decsribe the process of making a Peanut Butter Jelly Sandwich',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }

  _resetInstructions() {
    return const Center(
      child: Text(
        '',
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }

}
