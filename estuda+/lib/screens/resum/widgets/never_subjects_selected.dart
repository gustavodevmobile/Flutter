import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NeverSubjectsSelected extends StatelessWidget {
  const NeverSubjectsSelected({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.block_outlined,
            color: Colors.red,
            size: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Nenhum assunto selecionado.',
              style: AppTheme.customTextStyle2(color: Colors.yellow),
            ),
          )
        ],
      ),
    );
  }
}
