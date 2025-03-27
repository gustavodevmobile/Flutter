import 'dart:async';

import 'package:estudamais/database/storage_shared_preferences.dart';
import 'package:estudamais/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControllerQuestions {
  //DaoUserResum database = DaoUserResum();
//cor do box alternative
  Color corAlternativa = Colors.white;
  // container onde mostra questão ja respondida
  double heightBoxIsAnswered = 0;
  //atualiza id das questões respondidas

  //atualiza id das questões respondidas corretas

  //atualiza id das questões respondidas incorretas

  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();

  Timer? timer;

  void recoverQuestionsIncorrects(
      bool isAnswered,
      String response,
      String alternative,
      int indexQuestion,
      BuildContext context,
      String idQuestion) {
    //findAnswereds();
    if (isAnswered) {
      // abre o alerta que a questão ja foi respondida
      heightBoxIsAnswered = 30;
    } else {
      if (response == alternative) {
        corAlternativa = Colors.green;

        sharedPreferences.removeIdsInList(
            StorageSharedPreferences.keyIdsAnsweredsIncorrects,
            idQuestion,
            StorageSharedPreferences.keyIdsAnsweredsCorrects);
      } else {
        // se errar, nada muda.
        corAlternativa = Colors.red;
        // FAZ A VERIFICAÇÃO PARA PODER SALVAR OS IDS DAS QUESTÕES INCORRETAS
      }
    }
  }

// método que faz a lógica das questões respondidas e as devidas atualizações.
//recebe como argumento o boleano, se ja foi respodida, a resposta, a alternativa clicada, o context e a id da questão correspondente
  void isCorrect(bool isAnswered, String response, String alternative,
      int indexQuestion, BuildContext context, String idQuestion) {
    print('id: $idQuestion');
    //String? idsAnswerCorrect;
    List<dynamic> idsAnswerIncorrect = [];
    // idsAnswer.add(idQuestion);
    // salva o id da questão em ids respondidos
    sharedPreferences.saveIds(
        idQuestion, StorageSharedPreferences.keyIdsAnswereds);

    if (isAnswered) {
      // abre o alerta que a questão ja foi respondida
      heightBoxIsAnswered = 30;
    } else {
      if (response == alternative) {
        // muda a cor do box alternativa para verde
        corAlternativa = Colors.green;
        //salva o id da questão em ids respondidos corretamente
        sharedPreferences.saveIds(
            idQuestion, StorageSharedPreferences.keyIdsAnsweredsCorrects);

        // sharedPreferences
        //     .recoverIds(StorageSharedPreferences.keyIdsAnsweredsCorrects)
        //     .then((ids) {
        //       int values = ids.length + 1;
        //   idsAnswerCorrect = values.toString() ;
        //   print('idsAnswerCorrect $idsAnswerCorrect');

        // });
        // Provider.of<ModelPoints>(listen: false, context)
        //       .answeredsCorrects(idsAnswerCorrect ?? '0');
      } else {
        corAlternativa = Colors.red;
        //salva o id da questão em ids respondidos incorretamente
        sharedPreferences.saveIds(
            idQuestion, StorageSharedPreferences.keyIdsAnsweredsIncorrects);

        timer = Timer(const Duration(seconds: 2), () {
          sharedPreferences
              .recoverIds(StorageSharedPreferences.keyIdsAnsweredsIncorrects)
              .then((ids) {
            idsAnswerIncorrect = ids;
          });
          Provider.of<ModelPoints>(listen: false, context)
              .answeredsIncorrects(idsAnswerIncorrect.length.toString());
        });
      }
    }
  }
}
