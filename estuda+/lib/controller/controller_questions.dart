import 'package:estudamais/models/model_questions.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/storage_sqllite/storage_sqflite.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Classe responsável por fazer a lógica das questões respondidas
class ControllerQuestions {
//Cor do box alternative
  Color corAlternativa = Colors.white;
  // Altura do container onde mostra questão ja respondida.
  double heightBoxIsAnswered = 0;
  //Instância StorageSharedPreferences onde armazena os dados (ids) localmente.
  StorageSharedPreferences sharedPreferences = StorageSharedPreferences();
  StorageSqflite storageSqflite = StorageSqflite();

//Método que salva somente as questões que foram respondidas incorretamente para verificação na tentativa de duplas respostas.
  Future<void> saveIdAnsweredsIncorrects(
      String id, Function(String) onError) async {
    try {
      sharedPreferences
          .saveIds(id, StorageSharedPreferences.isAnsweredIncorrects, (error) {
        onError(error);
      });
    } catch (e) {
      onError('Erro ao salvar o id da questão respondida incorretamente: $e');
    }
  }

  // Método que verifica se a questão ja foi respondida.
  Future<void> answered(String id, String key, Function(bool) isAnswered,
      Function(String) onError) async {
    try {
      List<String> listIds = await sharedPreferences.recoverIds(key, (error) {
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
      String idQuestion) async {
    if (response == alternative) {
      // muda a cor do box alternativa para verde
      corAlternativa = Colors.green;

      // Este método salva o id da questão em ids respondidos corretamente ao chamar o método que faz:
      //1º Recebe a chave do ids incorretos, id da questão e chave do ids corretos.
      //2º Remove o id da questão correspondente da lista recebida dos ids incorretos.
      //3º Salva o id da questão correspondente nos ids corretos.
      //4º Salva a lista dos ids incorretos, sem o id da questão correspondente.
      // await sharedPreferences.removeIdsInList(
      //   // Chave dos ids incorretos
      //   StorageSharedPreferences.keyIdsAndDateAnsweredsIncorrectsResum,
      //   // Id da questão.
      //   idQuestion,
      //   // Chave dos ids corretos
      //   StorageSharedPreferences.keyIdsAndDateAnsweredsCorrectsResum,
      //   context,
      //   (error) => showSnackBarFeedback(context, error, Colors.red),
      // );

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
      storageSqflite.insertQuestion(
          question, 'questions_corrects', timeAnswered);
      // muda a cor do box alternativa para verde
      corAlternativa = Colors.green;

      // pega a quantidade de ids corretos;
      int amountCorrects = int.parse(
          Provider.of<GlobalProviders>(listen: false, context)
              .correctsCurrents);
      // acrescenta + 1 na quantidade de acertos;
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
      // atualiza na pointAndAErrors a quantidade de erros;
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
