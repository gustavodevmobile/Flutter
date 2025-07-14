import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagemPickerWidget extends StatelessWidget {
  final XFile? imagem;
  final String label;
  final void Function(XFile?) onImagemSelecionada;
  final double height;

  const ImagemPickerWidget({
    super.key,
    required this.imagem,
    required this.onImagemSelecionada,
    this.label = 'Imagem',
  this.height = 180,
  });

  Future<void> _selecionarImagem(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onImagemSelecionada(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selecionarImagem(context), 
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.blueAccent, width: 1.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: imagem != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.network(
                        imagem!.path,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(imagem!.path),
                        fit: BoxFit.cover,
                      ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo,
                      size: 32, color: Colors.blueAccent),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.blueAccent),
                  ),
                ],
              ),
      ),
    );
  }
}
