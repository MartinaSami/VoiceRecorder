import 'dart:async';
import 'package:flutter/material.dart';

class TimeController extends ValueNotifier<bool> {
  TimeController({bool isPlaying = false}) : super(isPlaying);
  void startTimer() => value = true;
  void stopTimer() => value = false;
}

class TimerWidget extends StatefulWidget {
  final TimeController controller;
  const TimerWidget({Key? key, required this.controller}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  bool isRec= false;
  Duration duration = const Duration();
  Timer? timer;
  var seconds;
  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.value) {
        startTimer();
      } else {
        stopTimer();
      }
    });
    super.initState();
  }

  void reset() => setState(() {
        duration = const Duration();
      });
  void addTime() {
    const addSeconds = 1;
    setState(() {
       seconds = duration.inSeconds + addSeconds;
       isRec = true;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}) {
    if (!mounted) return;
    if (resets) {
      reset();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      addTime();
    });
  }

  void stopTimer({bool resets = true}) {
    if (!mounted) return;
    if (resets) {
      reset();
    }
    setState(() {
      timer?.cancel();
      isRec = false;
    });
  }

  @override
  Widget build(BuildContext context ) {
    return Center( 
      
    );
  }
}
