
import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context, String msg) {
  showDialog(
    context: context,
    barrierDismissible: false, // Impede que o usuário feche o diálogo manualmente
    builder: (BuildContext context) => Dialog.fullscreen(
      backgroundColor: const Color.fromARGB(6, 255, 255, 255),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.indigo,
              strokeAlign: 8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(msg, style: AppTheme.customTextStyle(fontSize: 16, fontWeight: true)),
          ),
        ],
      ),
    ),
  );
}
