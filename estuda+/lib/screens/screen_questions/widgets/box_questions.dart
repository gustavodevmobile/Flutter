import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BoxQuestions extends StatelessWidget {
  final String question;
  const BoxQuestions(this.question, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          question,
          style: AppTheme.customTextStyle2(
            fontSize: 18,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}
