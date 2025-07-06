import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

Future<String> xFileToBase64(XFile file) async {
  // Lê os bytes da imagem
  final bytes = kIsWeb
      ? await file.readAsBytes()
      : await File(file.path).readAsBytes();

  // Decodifica a imagem
  img.Image? image = img.decodeImage(bytes);
  if (image == null) throw Exception('Não foi possível decodificar a imagem');

  // Redimensiona (opcional, ajuste conforme necessário)
  img.Image resized = img.copyResize(image, width: 800);

  // Codifica para JPEG com qualidade reduzida (ajuste a qualidade se quiser)
  final jpg = img.encodeJpg(resized, quality: 70);

  // Converte para base64
  return base64Encode(jpg);
}