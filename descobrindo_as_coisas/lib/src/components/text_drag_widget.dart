import 'package:descobrindo_as_coisas/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextDragWidget extends StatefulWidget {
  final String textDrag;
  Offset position;
  TextDragWidget({required this.textDrag, required this.position, super.key});

  @override
  State<TextDragWidget> createState() => _TextDragWidgetState();
}

class _TextDragWidgetState extends State<TextDragWidget> {
  //Offset position = Offset(50, 50);
  bool isLimited = false;

  @override
  Widget build(BuildContext context) {
    Offset initPosition = Offset(70, 70);
    Offset limitedScreen = Offset(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Consumer<Controller>(builder: (context, value, child) {
      return Positioned(
        left: widget.position.dx,
        top: widget.position.dy,
        child: Draggable<String>(
          data: widget.textDrag,
          feedback: Material(
            color: Colors.transparent,
            // child: Text(
            //   widget.textDrag,
            //   style: TextStyle(fontSize: 20, color: Colors.white),
            // ),
          ),
          child: Text(
            widget.textDrag,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          onDragUpdate: (details) {
            // setState(() {
            //   widget.position += details.delta;
            // });
            if (widget.position.dx < MediaQuery.of(context).size.width - 30) {
              setState(() {
                widget.position += details.delta;
                print(widget.position);
              });
            } else {
              setState(() {
                widget.position = initPosition;
              });
            }
          },
          onDragCompleted: () {
            if (widget.position.dx > 300) {
              setState(() {
                widget.position = initPosition;
              });
            }
          },
        ),
      );
    });
  }
}
