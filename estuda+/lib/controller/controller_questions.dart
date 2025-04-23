import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/providers/global_providers.dart';
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

  static bool isAnswered = false;

// Método responsável por recuperar as questões respodidas incorretamente, fazendo a lógica de remover o id dos ids incorretos e salvar o id correspondente nos ids corretos.
  void recoverQuestionsIncorrects(
      // Recebe a resposta da alternativa
      String response,
      // Recebe a alternativa selecionada
      String alternative,
      // Recebe o contexto
      BuildContext context,
      // Id da questão
      String idQuestion) {
    if (response == alternative) {
      // muda a cor do box alternativa para verde
      corAlternativa = Colors.green;

      // Este método salva o id da questão em ids respondidos corretamente ao chamar o método que faz:
      //1º Recebe a chave do ids incorretos, id da questão e chave do ids corretos.
      //2º Remove o id da questão correspondente da lista recebida dos ids incorretos.
      //3º Salva o id da questão correspondente nos ids corretos.
      //4º Salva a lista dos ids incorretos, sem o id da questão correspondente.
      sharedPreferences.removeIdsInList(
        // Chave dos ids incorretos
        StorageSharedPreferences.keyIdsAndDateAnsweredsIncorrectsResum,
        // Id da questão.
        idQuestion,
        // Chave dos ids corretos
        StorageSharedPreferences.keyIdsAndDateAnsweredsCorrectsResum,
        context,
        (error) => showSnackBarError(context, error, Colors.red),
      );
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
      isAnswered = true;
    } else {
      // Se errar, nada muda.
      corAlternativa = Colors.red;

      isAnswered = true;
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
    // Id da questão
    String idQuestion,
  ) async {
    // Salva os ids de todas as questões respodidas.
    sharedPreferences
        .saveIds(idQuestion, StorageSharedPreferences.keyIdsAnswereds, (error) {
      showSnackBarError(context, error, Colors.red);
    });
    // Verifica alternativa escolhida x resposta correta
    if (response == alternative) {
      // muda a cor do box alternativa para verde
      corAlternativa = Colors.green;

      // pega a quantidade de ids corretos;
      int amountCorrects = int.parse(
          Provider.of<GlobalProviders>(listen: false, context)
              .correctsCurrents);
      // acrescenta + 1 na quantidade de acertos;
      amountCorrects++;
      // atualiza na pointsAndErrors a quantidade de acertos;
      Provider.of<GlobalProviders>(listen: false, context)
          .answeredsCorrects(amountCorrects.toString());
      // Se não...
      isAnswered = true;

      // salva o id e data da questão em ids respondidos corretamente;
      sharedPreferences.saveIdsAndDateResum(idQuestion,
          StorageSharedPreferences.keyIdsAndDateAnsweredsCorrectsResum,
          (onError) {
        showSnackBarError(context, onError, Colors.red);
      });
    } else {
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
      isAnswered = true;

      // salva o id e data da questão em ids respondidos incorretamente;
      sharedPreferences.saveIdsAndDateResum(idQuestion,
          StorageSharedPreferences.keyIdsAndDateAnsweredsIncorrectsResum,
          (onError) {
        showSnackBarError(context, onError, Colors.red);
      });
    }
  }

  void nextQuestion(PageController controller, BuildContext context) {
    controller.nextPage(
      duration: const Duration(milliseconds: 700),
      curve: Curves.ease,
    );
    Provider.of<GlobalProviders>(listen: false, context)
        .openBoxAlreadyAnswereds(false);
  }
}
