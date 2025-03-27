import 'package:flutter/material.dart';
import 'package:estudamais/models/models.dart';
import 'package:provider/provider.dart';

class PointsAndErrors extends StatefulWidget {
  const PointsAndErrors({super.key});

  @override
  State<PointsAndErrors> createState() => _PointsAndErrorsState();
}

class _PointsAndErrorsState extends State<PointsAndErrors> {
  //final CounterErrors counterErrors = CounterErrors();

  @override
  void initState() {
    print(
        'pontos ${Provider.of<ModelPoints>(listen: false, context).correctsCurrents}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelPoints>(
      builder: (context, value, child) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 2),
                          blurRadius: 1,
                          spreadRadius: 1)
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      value.correctsCurrents,
                      //DaoUserResum.idQuestCorrect.length.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  )),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red[300],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1, 2),
                      blurRadius: 1,
                      spreadRadius: 1)
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  value.incorrectsCurrents,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
