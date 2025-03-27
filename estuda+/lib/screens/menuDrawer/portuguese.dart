import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Portuguese extends StatelessWidget {
  const Portuguese({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Português'),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Lottie.asset('./assets/lotties/backgroud_blue.json',
                fit: BoxFit.cover),
          ),
          // ListView(
          //   children: [DropdownFilter('anos', Service.listSeries), DropdownFilter('assuntos', Service.listSubjectBySerie)],
          //)
        ],
      ),
    );
  }
}
