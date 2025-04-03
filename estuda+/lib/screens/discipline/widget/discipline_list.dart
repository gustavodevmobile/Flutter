import 'package:estudamais/widgets/animated_button_retangulare.dart';
import 'package:flutter/material.dart';

class DisciplineList extends StatelessWidget {
  final List<String> disciplines;
  final Function(String) onDisciplineTap;

  const DisciplineList(
      {required this.disciplines, required this.onDisciplineTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: disciplines.length,
      itemBuilder: (context, index) {
        return AnimatedButtonRectangular(
          title: disciplines[index],
          fontSizeTitle: 22,
          textDirection: MainAxisAlignment.center,
          onTap: () => onDisciplineTap(disciplines[index]),
        );
      },
    );
  }
}
