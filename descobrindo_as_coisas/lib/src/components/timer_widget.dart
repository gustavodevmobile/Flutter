import 'dart:async';
import 'package:descobrindo_as_coisas/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget(
      {this.stop, this.start, this.end, this.stopped = false, super.key});
  final int? stop;
  final int? start;
  final int? end;
  final bool stopped;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  int time = 0;
  bool init = false;
  String formattedTime = '';
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  Controller controller = Controller();
  //TimerPlays timer = TimerPlays();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer(
      Duration(seconds: 10),
      () {
        init = true;
        _timer = Timer.periodic(
          Duration(seconds: 1),
          (timer) {
            if (Provider.of<Controller>(listen: false, context).isActivity) {
              stopTimer();
            } else {
              setState(() {
                time++;
              });
            }
          },
        );
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
    print('Timer cancelado');
    Provider.of<Controller>(listen: false, context).timerFinal(
      hours.toString().padLeft(2, '0'),
      minutes.toString().padLeft(2, '0'),
      seconds.toString().padLeft(2, '0'),
    );
    print(formattedTime);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String getFormattedTime() {
    setState(() {
      hours = time ~/ 3600;
      minutes = (time % 3600) ~/ 60;
      seconds = time % 60;
    });
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    formattedTime = getFormattedTime();
    return Column(
      children: [
        AnimatedOpacity(
          duration: Duration(seconds: 1),
          curve: Curves.easeIn,
          opacity: init ? 1.0 : 0.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 2, color: Colors.white)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  formattedTime,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ElevatedButton(
            onPressed: () {
              stopTimer();
              controller.resetController();
              Navigator.pop(context);
            },
            child: Text('Sair'),
          ),
        ),
      ],
    );
  }
}
