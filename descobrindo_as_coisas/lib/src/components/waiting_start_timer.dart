import 'dart:async';

import 'package:flutter/material.dart';

class WaitinStartTimer extends StatefulWidget {
  const WaitinStartTimer({super.key});

  @override
  State<WaitinStartTimer> createState() => _WaitingStartTimerState();
}

class _WaitingStartTimerState extends State<WaitinStartTimer> {
  Timer? _timer;
  int stopwatch = 0;
  int time = 0;
  int startTime = 10;
  bool isTimerRunning = true;

  void countDownTime() {
    setState(() {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (startTime <= 0 && _timer!.isActive) {
          setState(() {
            timer.cancel();
            isTimerRunning = false;
            print('timer waiting start parou');
          });
        } else {
          setState(() {
            startTime--;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  void initState() {
    countDownTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedOpacity(
        opacity: isTimerRunning ? 1.0 : 0.0,
        duration: Duration(seconds: 1),
        child: Text(
          startTime.toString(),
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
