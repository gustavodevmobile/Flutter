import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';

bool isLoadingDialogOpen = false;

showLoadingDialog(BuildContext parentContext, String msg) {
  isLoadingDialogOpen = true;
  showDialog(
    context: parentContext,
    barrierDismissible:
        false, // Impede que o usuário feche o diálogo manualmente
    builder: (BuildContext dialogContext) => Dialog.fullscreen(
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
            child: Text(msg,
                style:
                    AppTheme.customTextStyle(fontSize: 16, fontWeight: true)),
          ),
        ],
      ),
    ),
  );
  // .then((_){
  //   isLoadingDialogOpen = false;
  // });
}

closeLoadingOpen(BuildContext parentContext) {
  if (parentContext.mounted && isLoadingDialogOpen && Navigator.canPop(parentContext)) {
    Navigator.pop(parentContext);
  }
}
