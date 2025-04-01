import 'package:estudamais/database/storage_shared_preferences.dart';
import 'package:estudamais/models/models.dart';
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
  bool isAnswered = false;
  bool isAnsweredIncorrects = false;

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
    // variável que recebe false se não estiver sido respodida e true se ja tiver sido respondida
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
        StorageSharedPreferences.keyIdsAnsweredsIncorrects,
        // Id da questão.
        idQuestion,
        // Chave dos ids corretos
        StorageSharedPreferences.keyIdsAnsweredsCorrects,
        context,
        (error) => showSnackBarError(context, error, Colors.red),
      );
      // pega a quantidade de ids incorretos;
      int amountIncorrects = int.parse(
          Provider.of<ModelPoints>(listen: false, context).incorrectsCurrents);
      // decrementa 1
      amountIncorrects--;
      // atualiza na pointsAndErrors a quantidade de erros;
      Provider.of<ModelPoints>(listen: false, context)
          .answeredsIncorrects(amountIncorrects.toString());

      // pega a quantidade de ids corretos;
      int amountCorrects = int.parse(
          Provider.of<ModelPoints>(listen: false, context).correctsCurrents);
      // acrescenta + 1 na quantidade de acertos;
      amountCorrects++;
      // atualiza na pointsAndErrors a quantidade de acertos;
      Provider.of<ModelPoints>(listen: false, context)
          .answeredsCorrects(amountCorrects.toString());
    } else {
      // Se errar, nada muda.
      corAlternativa = Colors.red;
      isAnsweredIncorrects = true;
    }
  }

  Future<bool> ifAnswered(String id, BuildContext context, key) async {
    // verifica se a questão já foi respondida
    List<String> listIds = await sharedPreferences.recoverIds(
      key,
      (onError) {
        // caso ocorra um erro, exibe a mensagem de erro
        showSnackBarError(context, onError, Colors.red);
      },
    );
    isAnswered = listIds.contains(id);
    print('isAnswered $isAnswered');
    return isAnswered;
  }

// Método responsável por fazer a lógica das questões respondidas e as devidas atualizações.
//recebe como argumento o boleano(está respondida = false), se já foi respodida, a resposta, a alternativa clicada, o context e o id da questão correspondente.
  void isCorrect(
    // Recebe a resposta correta;
    String response,
    // Recebe a alternativa clicada;
    String alternative,
    //int indexQuestion,
    // Recebe o contexto;
    BuildContext context,
    // Id da questão
    String idQuestion,
  ) async {
    // salva o id da questão em ids respondidos
    sharedPreferences
        .saveIds(idQuestion, StorageSharedPreferences.keyIdsAnswereds, (error) {
      showSnackBarError(context, error, Colors.red);
    });
    // Verifica alternativa escolhida x resposta correta
    if (response == alternative) {
      // muda a cor do box alternativa para verde
      corAlternativa = Colors.green;
      //salva o id da questão em ids respondidos corretamente
      sharedPreferences
          .saveIds(idQuestion, StorageSharedPreferences.keyIdsAnsweredsCorrects,
              (error) {
        showSnackBarError(context, error, Colors.red);
      });
      // pega a quantidade de ids corretos;
      int amountCorrects = int.parse(
          Provider.of<ModelPoints>(listen: false, context).correctsCurrents);
      // acrescenta + 1 na quantidade de acertos;
      amountCorrects++;
      // atualiza na pointsAndErrors a quantidade de acertos;
      Provider.of<ModelPoints>(listen: false, context)
          .answeredsCorrects(amountCorrects.toString());
      // Se não...
    } else {
      // muda a cor da alternativa para vermelho;
      corAlternativa = Colors.red;
      //salva o id da questão em ids respondidos incorretamente;
      sharedPreferences.saveIds(
          idQuestion, StorageSharedPreferences.keyIdsAnsweredsIncorrects,
          (error) {
        showSnackBarError(context, error, Colors.red);
      });
      // pega a quantidade de ids incorretos;
      int amountIncorrects = int.parse(
          Provider.of<ModelPoints>(listen: false, context).incorrectsCurrents);
      //acrescenta + 1 na quantidade de erros
      amountIncorrects++;
      // atualiza na pointAndAErrors a quantidade de erros;
      Provider.of<ModelPoints>(listen: false, context)
          .answeredsIncorrects(amountIncorrects.toString());
    }
  }
}
