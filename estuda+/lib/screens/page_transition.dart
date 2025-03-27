// import 'dart:async';

// import 'package:estudamais/controller/routes.dart';
// import 'package:estudamais/controller/update_datas.dart';
// import 'package:estudamais/screens/home/home.dart';
// import 'package:estudamais/widgets/loading.dart';
// import 'package:flutter/material.dart';

// class TransitionPage extends StatefulWidget {
//   const TransitionPage({super.key});

//   @override
//   State<TransitionPage> createState() => _TransitionPageState();
// }

// class _TransitionPageState extends State<TransitionPage> {
//   Timer? timer;
//   String text = 'Atualizando...';
//   @override
//   void initState() {
//     pageTransition();

//     super.initState();
//   }

//   void pageTransition() {
//     UpdateDatas().updateDatas();
//     timer = Timer(const Duration(seconds: 2), () {
//       setState(() {
//         text = 'Atualizado!';
//       });
//     });
//     timer = Timer(const Duration(seconds: 4), () {
//       Routes().pushRouteFade(context, const HomeScreen());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Loading(
//         //pathAnimation: './assets/lotties/animation_transition.json',
//         textFeedback: text,
//       ),
//     );
//   }
// }
