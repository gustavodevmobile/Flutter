import 'dart:typed_data';

import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ImageQuestion extends StatelessWidget {
  final Uint8List image;
  const ImageQuestion({required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.memory(
          image,
          //width: MediaQuery.of(context).size.width,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox.shrink();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog.fullscreen(
                      backgroundColor: Colors.white12,
                      child: Stack(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InteractiveViewer(
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.memory(
                                  image,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Text(
                'Abrir imagem',
                style: AppTheme.customTextStyle2(
                  color: Colors.black87,
                  underline: true,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
