import 'dart:async';

import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showLoadingDialog(BuildContext context, String msg) {
  showDialog(
    context: context,
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
            child: Text(msg, style: AppTheme.customTextStyle(fontSize: 16)),
          ),
        ],
      ),
    ),
  );
}
