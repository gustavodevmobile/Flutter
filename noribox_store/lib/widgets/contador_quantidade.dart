import 'package:flutter/material.dart';

class ContadorQuantidade extends StatelessWidget {
  const ContadorQuantidade({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
        
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
             print('Diminuir quantidade');
              // Aqui você pode implementar a lógica para diminuir a quantidade
            },
            child: Icon(Icons.remove)),
          const Text(
            '1', // Aqui você pode usar um estado para mostrar a quantidade atual
            style: TextStyle(fontSize: 20),
          ),
          GestureDetector(
            onTap: () {
              // Aqui você pode implementar a lógica para aumentar a quantidade
            },
            child: Icon(Icons.add)),
        ],
      ),
    );
  }
}
