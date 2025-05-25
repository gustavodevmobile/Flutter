import 'dart:async';
import 'package:estudamais/controller/controller_loading_next_page.dart';
import 'package:estudamais/controller/controller_report_resum.dart';
import 'package:estudamais/controller/routes.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/screens/home/home.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/service/service.dart';
import 'package:estudamais/service/service_resum_questions.dart';
import 'package:estudamais/storage_sqllite/storage_sqflite.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:estudamais/widgets/loading.dart';
import 'package:provider/provider.dart';

class LoadingNextPage extends StatefulWidget {
  final String msgFeedback;
  const LoadingNextPage({
    required this.msgFeedback,
    super.key,
  });

  @override
  State<LoadingNextPage> createState() => _LoadingNextPageState();
}

class _LoadingNextPageState extends State<LoadingNextPage> {
  String mensagem = '';
  Timer? _timer;
  int _tempo = 0;
  ServiceResumQuestions questionsCorrectsAndIncorrects =
      ServiceResumQuestions();

  TextStyle textStyle = AppTheme.customTextStyle(
      fontWeight: true, color: Colors.indigo, fontSize: 13.0);

  @override
  void initState() {
    ControllerLoadingNextPage().loadingNextPage(context);
    mensagem = widget.msgFeedback;
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _tempo += 2;
        if (_tempo < 4) {
          mensagem = 'Pronto!!!';
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Loading(),
          Text(mensagem, style: textStyle),
        ],
      ),
    );
  }
}
