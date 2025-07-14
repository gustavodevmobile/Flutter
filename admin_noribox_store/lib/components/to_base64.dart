import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<String> xFileToBase64(XFile file) async {
  // Lê os bytes da imagem
  final bytes =
      kIsWeb ? await file.readAsBytes() : await File(file.path).readAsBytes();

  return base64Encode(bytes);
}
