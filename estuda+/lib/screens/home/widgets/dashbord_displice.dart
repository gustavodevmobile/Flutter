import 'package:flutter/material.dart';

class DashbordDisplice extends StatefulWidget {
  final String displice;
  final Color progressColors;
  final double valueProgress;
  final String countAnswer;
  const DashbordDisplice(
      this.displice, this.progressColors, this.valueProgress, this.countAnswer,
      {super.key});

  @override
  State<DashbordDisplice> createState() => _DashbordDispliceState();
}

class _DashbordDispliceState extends State<DashbordDisplice> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color.fromARGB(190, 197, 202, 233),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2.0,
              blurRadius: 1.0,
              offset: Offset(0, 2.0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 4, bottom: 4.0),
              child: Text(
                widget.displice,
                style: const TextStyle(color: Colors.black),
                //style: GoogleFonts.aboreto(fontSize: 10),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 140,
                  child: LinearProgressIndicator(
                    color: widget.progressColors,
                    value: widget.valueProgress,
                    minHeight: 12,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 60,
                  child: Text(
                    widget.countAnswer,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
