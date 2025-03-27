import 'package:descobrindo_as_coisas/src/components/backgroud.dart';
import 'package:descobrindo_as_coisas/src/components/text_drag_widget.dart';
import 'package:descobrindo_as_coisas/src/components/text_dragtarget_widget.dart';
import 'package:flutter/material.dart';

class TextDraggable extends StatefulWidget {
  const TextDraggable({super.key});

  @override
  State<TextDraggable> createState() => _TextDraggableState();
}

class _TextDraggableState extends State<TextDraggable> {
  String textTest = 'Gustavo';

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    Widget target = TextDragtargetWidget(textTarget: textTest);
    return Scaffold(
        appBar: AppBar(
          title: Text('Text Draggable'),
        ),
        body: Backgroud(
            child: SizedBox.expand(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    child: Column(
                  children: [
                    Text(
                      'A linguagem Dart possui a classe _______ que tem  propriedades e métodos que implementam muitas ações envolvendo strings como as mencionadas acima e as veremos na prática a seguir.',
                      style: TextStyle(color: Colors.white,),
                    )
                  ],
                )),
              ),
              TextDragWidget(
                position: Offset(50, 200),
                textDrag: textTest,
              ),
              TextDragWidget(
                position: Offset(50, 300),
                textDrag: widthScreen.toString(),
              ),
            ],
          ),
        )));
  }
}
