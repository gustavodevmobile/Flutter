import 'package:flutter/material.dart';
import 'package:noribox_store/themes/themes.dart';

class CadastroProgressIndicator extends StatelessWidget {
  final int etapa;
  
  const CadastroProgressIndicator(
      {required this.etapa, super.key})
      ;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: etapa == i ? 28 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: etapa == i ? Themes.redPrimary : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
