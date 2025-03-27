import 'package:descobrindo_as_coisas/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dragtargets extends StatefulWidget {
  Offset position;
  String textContent;
  Color backgroundColor;
  Color textColor;

  Dragtargets({
    required this.textColor,
    required this.position,
    required this.textContent,
    required this.backgroundColor,
    super.key,
  });

  @override
  State<Dragtargets> createState() => _DragtargetsState();
}

class _DragtargetsState extends State<Dragtargets> {
  Color backgroundColor = Colors.transparent;

  bool isAccepted = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, value, child) {
        return Positioned(
          left: widget.position.dx,
          top: widget.position.dy,
          child: GestureDetector(
            onTap: () {
              print('x: ${widget.position.dx}');
              print('y: ${widget.position.dy}');
            },
            onPanUpdate: (details) {
              setState(
                () {
                  //widget.position += details.delta;
                },
              );
            },
            child: DragTarget<Color>(
              builder: (context, accepted, rejected) {
                return Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black, width: 2),
                    //shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Text(
                      widget.textContent,
                      style: TextStyle(
                          color: widget.textColor,
                          fontWeight: FontWeight.bold,
                          decorationStyle: TextDecorationStyle.wavy),
                    ),
                  ),
                );
              },
              onAcceptWithDetails: (details) {
                print('details. ${details.offset.dx}');
                // print(widget.xPosition);
                // print(widget.yPosition);
                setState(
                  () {
                    if (details.data == widget.backgroundColor) {
                      backgroundColor = details.data;
                      widget.textColor = widget.backgroundColor == Colors.white
                          ? Colors.black
                          : Colors.white;
                      value.changeAccepted(true);
                    } else {
                      print('cor errada');
                      print('value.isAccepted ${value.isAccepted}');
                      value.changeAccepted(false);
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
