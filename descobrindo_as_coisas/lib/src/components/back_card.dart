import 'package:descobrindo_as_coisas/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackCard extends StatefulWidget {
  final String letter;
  final Color borderColor;
  double widthBorder;
  bool isBorder;

  BackCard({
    required this.letter,
    this.borderColor = Colors.white,
    this.widthBorder = 0,
    this.isBorder = false,
    super.key,
  });

  @override
  State<BackCard> createState() => _BackCardState();
}

class _BackCardState extends State<BackCard> {
  double widthBorder2 = 0;

  @override
  void initState() {
     widget.widthBorder = 0;
   //widget.isBorder = false;
    if (widget.isBorder) {
      Future.delayed(Duration(seconds: 1)).then((v) {
        widget.widthBorder = 3;
      });
    } else {
      widget.widthBorder = 0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (context, value, child) {
      return Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(width: widget.isBorder ? widget.widthBorder : 0, color: widget.borderColor),
        ),
        child: Center(
          child: Text(
            widget.letter,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
