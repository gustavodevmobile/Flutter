import 'dart:io';

import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;

  const PdfViewerScreen({super.key, required this.filePath});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    if (!File(widget.filePath).existsSync()) {
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
      body: Stack(
        children: [
          PDFView(
            filePath: widget.filePath,
            onRender: (pages){
              setState(() {
                isLoading = false;
              });
            },
            onError: (error) {
              setState(() {
                isLoading = false;
              });
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Erro'),
                  content: Text('Erro ao carregar o PDF: $error'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.black,
              color: Colors.indigo,
              strokeAlign: 8,
            ),
            ),
        ],
      ),
    );
  }
}
