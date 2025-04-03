import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoxResum extends StatelessWidget {
  final Widget image;
  final String value;
  final String description;
  final Widget textButton;

  const BoxResum(this.value, this.description, this.image, this.textButton,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 4, bottom: 4, right: 8),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(190, 197, 202, 233),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 3.0,
                blurRadius: 2.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: image,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: SizedBox(
                        child: Row(
                          children: [
                            Text(value,
                                style: AppTheme.customTextStyle(
                                  fontSize: 30,
                                  color: Colors.black87,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    Text(
                                      'Respostas',
                                      style: AppTheme.customTextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        description,
                                        style: AppTheme.customTextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                          fontWeight: true
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              textButton
            ],
          ),
        ));
  }
}
