import 'dart:async';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recordertest/sound_player.dart';
import 'package:recordertest/sound_recorder.dart';
import 'package:recordertest/timer_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final timeController = TimeController();
  final recorder = SoundREcorder();
  final player = SoundPlayer();

  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    player.dispose();
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: const Text('Audio Recording and Playing'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              buildTimer(),
              const SizedBox(
                height: 20,
              ),
              _buildStart(),
              SizedBox(
                height: 30,
              ),
              
              buildPlayer(),
            ],
          ),
        ));
  }

  Widget _buildStart() {
    final isRecordeing = recorder.isRecording;
    final icon = isRecordeing ? Icons.stop : Icons.mic;
    final text = isRecordeing ? 'STOP' : 'START';
    final primary = isRecordeing ? Colors.red : Colors.white;
    final onPrimary = isRecordeing ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(175, 50),
          primary: primary,
          onPrimary: onPrimary),
      onPressed: () async {
        final isRecording = await recorder.toggleRecording();
        setState(() {
          if (isRecordeing) {
            timeController.startTimer();
          } else {
            timeController.stopTimer();
          }
        });
      },
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildPlayer() {
    final isPlaying = player.isPlaying;
    final icon = isPlaying ? Icons.stop : Icons.play_arrow;
    final text = isPlaying ? 'Stop Recording' : 'Play Recording';

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(175, 50),
          primary: Colors.white,
          onPrimary: Colors.black),
      onPressed: () async {
        await player.togglePlaying(whenFinished: () => setState(() {} ));
        setState(() {
          
        });
      },
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildTimer() {
    final text = recorder.isRecording ? 'Now Recording' : 'Press';
    final animate = recorder.isRecording;

    return AvatarGlow(
      animate: animate,
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 92,
          backgroundColor: Colors.indigo,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.mic,
              size: 32,
            ),
            TimerWidget(controller: timeController),
            const SizedBox(
              height: 20,
            ),
            Text(text)
          ]),
        ),
      ),
      endRadius: 140,
    );
  }
}
