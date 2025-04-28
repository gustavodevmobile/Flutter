import 'dart:io';

import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String filePath;

  const PdfViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    if (!File(filePath).existsSync()) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(child: Text('Arquivo PDF não encontrado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Visualizar PDF',
          style: AppTheme.customTextStyle2(fontSize: 17),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}
