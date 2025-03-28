import 'dart:async';
import 'package:estudamais/database/storage_shared_preferences.dart';
import 'package:estudamais/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControllerQuestions {
//cor do box alternative
  Color corAlternativa = Colors.white;
  // container onde mostra questão ja respondida
  double heightBoxIsAnswered = 0;

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
          StorageSharedPreferences.keyIdsAnsweredsCorrects,
        );
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
        // pega a quantidade de acertos
        int amountCorrects = int.parse(
            Provider.of<ModelPoints>(listen: false, context).correctsCurrents);
        // acrescenta + 1 na quantidade de acertos
        amountCorrects++;
        // atualiza na pointsAndErrors a quantidade de acertos
        Provider.of<ModelPoints>(listen: false, context)
            .answeredsCorrects(amountCorrects.toString());
      } else {
        // muda a cor da alternativa para vermelho
        corAlternativa = Colors.red;
        //salva o id da questão em ids respondidos incorretamente
        sharedPreferences.saveIds(
            idQuestion, StorageSharedPreferences.keyIdsAnsweredsIncorrects);
        // pega a quantidade de erros
        int amountIncorrects = int.parse(
            Provider.of<ModelPoints>(listen: false, context)
                .incorrectsCurrents);
        //acrescenta + 1 na quantidade de erros
        amountIncorrects++;
        // atualiza na pointAndAErrors a quantidade de erros
        Provider.of<ModelPoints>(listen: false, context)
            .answeredsIncorrects(amountIncorrects.toString());
      }
    }
  }
}
