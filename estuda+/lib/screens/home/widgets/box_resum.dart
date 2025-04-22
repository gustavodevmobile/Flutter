import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BoxResum extends StatelessWidget {
  final Widget image;
  final String value;
  final String description;
  final Widget textButton;

  const BoxResum(this.value, this.description, this.image, this.textButton,
      {super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 4, bottom: 4, right: 8),
      child: Container(
        width: MediaQuery.of(context).size.width,
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
              width: 60,
              height: 60,
              child: image,
            ),
            SizedBox(
              width: screenWidth * 0.55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    value,
                    style: AppTheme.customTextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: true,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(
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
                                fontSize: screenWidth * 0.04,
                                color: Colors.black87,
                                fontWeight: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            textButton
          ],
        ),
      ),
    );
  }
}
