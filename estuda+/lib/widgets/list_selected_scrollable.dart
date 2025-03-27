import 'package:flutter/material.dart';

class ListSelectedScrollable extends StatelessWidget {
  final List<String> list;
  final Color? textColor;
  final Axis direction;
  
  const ListSelectedScrollable(
      {required this.list,
      this.textColor = Colors.white,
      required this.direction,
      
      super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          scrollDirection: direction,
          itemCount: list.length,
          itemBuilder: (context, int index) {
            return Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    ' ${list[index]}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 16),
                  ),
                )
              ],
            );
          }),
    );
  }
}
