import 'package:descobrindo_as_coisas/src/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextDragtargetWidget extends StatefulWidget {
  final String textTarget;
  const TextDragtargetWidget({required this.textTarget, super.key});

  @override
  State<TextDragtargetWidget> createState() => _TextDragtargetWidgetState();
}

class _TextDragtargetWidgetState extends State<TextDragtargetWidget> {
  @override
  Widget build(BuildContext context) {
    double textLength = double.parse(widget.textTarget.length.toString());
    return Consumer<Controller>(builder: (context, value, child) {
      return DragTarget<TextSpan>(
        builder: (context, accept, reject) {
          return Text.rich(TextSpan());
          // Container(
          //   width: textLength * 10,
          //   height: 30,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       border: Border.all(width: 2, color: Colors.white)),
          //   child: Padding(
          //     padding: EdgeInsets.all(textLength),
          //     //child: Text(textLength.toString()),
          //   ),
          // );
        },
        onAcceptWithDetails: (details) {
          if (widget.textTarget == details.data) {
            value.changeAccepted(true);
            print('recebido');
          }
        },
      );
    });
  }
}
