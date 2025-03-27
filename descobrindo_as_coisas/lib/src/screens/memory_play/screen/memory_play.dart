import 'package:descobrindo_as_coisas/src/components/backgroud.dart';
import 'package:descobrindo_as_coisas/src/components/timer_widget.dart';
import 'package:descobrindo_as_coisas/src/components/waiting_start_timer.dart';
import 'package:descobrindo_as_coisas/src/controller/controller.dart';
import 'package:descobrindo_as_coisas/src/controller/states.dart';
import 'package:descobrindo_as_coisas/src/screens/memory_play/components/card_letters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemoryPlay extends StatefulWidget {
  const MemoryPlay({super.key});

  @override
  State<MemoryPlay> createState() => _MemoryPlayState();
}

class _MemoryPlayState extends State<MemoryPlay> {
  States states = States();
  @override
  @override
  Widget build(BuildContext context) {
    //return Consumer<Controller>(builder: (context, value, child) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Jogo da Memória'),
        actions: [WaitinStartTimer()],
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   onPressed: () {
        //     Counter.count = 0;
        //     states.isMatch = false;
        //     states.isFlipped = true;

        //     Navigator.pop(context);
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Backgroud(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CardLetters(),
                  ),
                  TimerWidget(
                    stopped: Provider.of<Controller>(listen: false, context)
                        .isActivity,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // });
  }
}
