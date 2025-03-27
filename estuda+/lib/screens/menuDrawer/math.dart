// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:estudamais/models/models.dart';
// import 'package:estudamais/widgets/gridList_schoolYear.dart';
// import 'package:provider/provider.dart';

// class Math extends StatefulWidget {
//   const Math({super.key});

//   @override
//   State<Math> createState() => _MathState();
// }

// class _MathState extends State<Math> {
//   //final Future _future = Service().getSeries();

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ModelPoints>(builder: (context, valueStorege, child) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Matemática'),
//         ),
//         body: Stack(
//           children: [
//             SizedBox.expand(
//               child: Lottie.asset('./assets/lotties/backgroud_blue.json',
//                   fit: BoxFit.cover),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: GridList(),
//             ),
            
//           ],
//         ),
//       );
//     });
//   }
// }
