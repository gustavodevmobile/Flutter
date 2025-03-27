import 'package:descobrindo_as_coisas/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Draggables extends StatefulWidget {
  Offset position;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final Color? textColor;
  Draggables(
      {required this.position,
      required this.backgroundColor,
      this.width = 100,
      this.height = 40,
      this.textColor = Colors.black,
      super.key});

  @override
  State<Draggables> createState() => _DraggablesState();
}

class _DraggablesState extends State<Draggables> {
  bool isDragging = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (context, value, child) {
      return Positioned(
        left: widget.position.dx,
        top: widget.position.dy,
        child: Visibility(
          visible: isDragging,
          child: Draggable<Color>(
            //rootOverlay: true,

            data: widget.backgroundColor,
            feedback: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: widget.backgroundColor,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(10.0),
                    //shape: BoxShape.circle,
                    ),
              ),
            ),

            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                //shape: BoxShape.circle,
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onDragUpdate: (details) {
              setState(
                () {
                  //widget.position += details.delta;
                  
                },
              );
            },
            // onDraggableCanceled: (velocity, offset) {
            //   print(offset.dx);
            //   print(offset.dy);
            // },
            onDragCompleted: () {
              setState(() {
                if (value.isAccepted) {
                  isDragging = false;
                } else {
                  isDragging = true;
                }
              });
            },
          ),
        ),
      );
    });
  }
}
