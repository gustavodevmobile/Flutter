import 'package:estudamais/providers/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonProgress extends StatefulWidget {
  final Function onTap;

  const ButtonProgress({required this.onTap, super.key});

  @override
  State<ButtonProgress> createState() => _ButtonProgressState();
}

class _ButtonProgressState extends State<ButtonProgress>
    with TickerProviderStateMixin {
  late AnimationController controller;
  String textLinearProgress = 'Iniciar';
  double widht = 120;
  double height = 40;
  Color colorBtn = Colors.white;
  Color colorLinearProgress = Colors.blue;
  Color colorTextBtn = Colors.indigo;
  bool selected = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..addListener(() {
        setState(() {});
      });
    //controller.repeat(reverse: true);
    controller.stop();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    setState(() {
      selected = !selected;
      if (selected) {
        widht = 250;
        height - 40;
      }
    });
    buttonProgress();
  }

  

  void buttonProgress() {
    bool findError =
        (Provider.of<GlobalProviders>(context, listen: false).progressError);
    Future.delayed(const Duration(milliseconds: 2300)).then((value) {
      if (widht == 250) {
        colorTextBtn = Colors.white;
        textLinearProgress = 'Preparando...';
        setState(() {
          controller.forward(from: controller.value);

          Future.delayed(const Duration(milliseconds: 3500)).then((value) {
            if (controller.isCompleted) {
              setState(() {
                colorTextBtn = Colors.white;
                textLinearProgress = 'Pronto!';

                Future.delayed(const Duration(milliseconds: 300)).then((value) {
                  if (findError) {
                    //print('findError $findError');
                    setState(() {
                      colorLinearProgress = Colors.red;
                      textLinearProgress = 'Ops, algo de errado!';
                    });
                  } else {
                    widget.onTap();
                  }
                });
              });
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProviders>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: GestureDetector(
          onTap: () {
            startAnimation();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.fastEaseInToSlowEaseOut,
            width: selected ? widht = 250 : widht,
            height: selected ? height : height,
            decoration: BoxDecoration(
                //color: Colors.indigo,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),

            child: Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  color: colorLinearProgress,
                  value: controller.value,
                  minHeight: 40,
                  borderRadius: BorderRadius.circular(20),
                ),
                Text(
                  textLinearProgress,
                  style: TextStyle(
                    color: colorTextBtn,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
