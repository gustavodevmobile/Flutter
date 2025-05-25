import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/storage_sqllite/storage_sqflite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Classe responsável por fazer a lógica das questões respondidas
class ControllerQuestions {
//Cor do box alternative
  Color corAlternativa = Colors.white;

  //Instância StorageSharedPreferences onde armazena os dados (ids) localmente.
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();
  StorageSqflite storageSqflite = StorageSqflite();

  // Método que verifica se a questão ja foi respondida.
  Future<void> answered(
      String id, Function(bool) isAnswered, Function(String) onError) async {
    try {
      List<String> listIds = await sharedPreferences
          .recoverIds(StorageSharedPreferences.idsRecoveryIncorrects, (error) {
        onError(error);
      });
      if (listIds.contains(id)) {
        isAnswered(true);
      } else {
        isAnswered(false);
      }
    } catch (e) {
      onError('Erro ao verificar se questão já foi respondida: $e');
    }
  }

// Método responsável por recuperar as questões respodidas incorretamente, fazendo a lógica de remover o id dos ids incorretos e salvar o id correspondente nos ids corretos.
  Future<void> recoverQuestionsIncorrects(
      // Recebe a resposta da alternativa
      String response,
      // Recebe a alternativa selecionada
      String alternative,
      // Recebe o contexto
      BuildContext context,
      // Id da questão
      String idQuestion,
      ModelQuestions question,
      String timeResponse) async {
    List<String> values = [];
    values.add(idQuestion);

    // salva o id da questão respondida incorretamente
    await sharedPreferences.saveIdsList(
        StorageSharedPreferences.idsRecoveryIncorrects, values, (onError) {
      print(onError);
    });
    if (response == alternative) {
      // muda a cor do box alternativa para verde
      corAlternativa = Colors.green;

      // Salva a questão na tabela das corretas
      await storageSqflite.insertQuestion(
          question, StorageSqflite.tableQuestionsCorrects, timeResponse);

      // Remove a questão da tabela das incorretas
      await storageSqflite.deleteQuestion(
          idQuestion, StorageSqflite.tableQuestionsIncorrects);

      if (context.mounted) {
        // pega a quantidade de ids incorretos;
        int amountIncorrects = int.parse(
            Provider.of<GlobalProviders>(listen: false, context)
                .incorrectsCurrents);
        // decrementa 1
        amountIncorrects--;
        // atualiza na pointsAndErrors a quantidade de erros;
        Provider.of<GlobalProviders>(listen: false, context)
            .answeredsIncorrects(amountIncorrects.toString());

        // pega a quantidade de ids corretos;
        int amountCorrects = int.parse(
            Provider.of<GlobalProviders>(listen: false, context)
                .correctsCurrents);
        // acrescenta + 1 na quantidade de acertos;
        amountCorrects++;
        // atualiza na pointsAndErrors a quantidade de acertos;
        Provider.of<GlobalProviders>(listen: false, context)
            .answeredsCorrects(amountCorrects.toString());

        // Habilita a área de explicação.
        Provider.of<GlobalProviders>(listen: false, context).explainable(true);
      }
    } else {
      // Se errar, nada muda.
      corAlternativa = Colors.red;
    }
  }

// Método responsável por fazer a lógica das questões respondidas e as devidas atualizações.
//recebe como argumento o boleano(está respondida = false), se já foi respodida, a resposta, a alternativa clicada, o context e o id da questão correspondente.
  void isCorrect(
    // Recebe a resposta correta;
    String response,
    // Recebe a alternativa clicada;
    String alternative,
    // Recebe o contexto;
    BuildContext context,
    ModelQuestions question,
    String timeAnswered,
  ) async {
    if (response == alternative) {
      // Se a questão já foi respondida, não faz nada.
      storageSqflite.insertQuestion(
          question, 'questions_corrects', timeAnswered);
      // muda a cor do box alternativa para verde
      corAlternativa = Colors.green;

      // pega a quantidade de ids corretos;
      int amountCorrects = int.parse(
          Provider.of<GlobalProviders>(listen: false, context)
              .correctsCurrents);
      //acrescenta + 1 na quantidade de acertos;
      amountCorrects++;

      // atualiza o estado para exibir o box de explicação;
      Provider.of<GlobalProviders>(listen: false, context).explainable(true);

      // atualiza na pointsAndErrors a quantidade de acertos;
      Provider.of<GlobalProviders>(listen: false, context)
          .answeredsCorrects(amountCorrects.toString());
      // Se não...
    } else {
      storageSqflite.insertQuestion(
          question, 'questions_incorrects', timeAnswered);
      // muda a cor da alternativa para vermelho;
      corAlternativa = Colors.red;

      // pega a quantidade de ids incorretos;
      int amountIncorrects = int.parse(
          Provider.of<GlobalProviders>(listen: false, context)
              .incorrectsCurrents);
      //acrescenta + 1 na quantidade de erros
      amountIncorrects++;
      // // atualiza na pointAndAErrors a quantidade de erros;
      Provider.of<GlobalProviders>(listen: false, context)
          .answeredsIncorrects(amountIncorrects.toString());
    }
  }

  void nextQuestion(PageController controller, BuildContext context) {
    controller.nextPage(
      duration: const Duration(milliseconds: 700),
      curve: Curves.ease,
    );
    // Fecha o a área da explicação da questão.
    Provider.of<GlobalProviders>(listen: false, context).explainable(false);
  }
}
