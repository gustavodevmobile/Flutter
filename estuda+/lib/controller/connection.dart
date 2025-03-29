import 'package:internet_connection_checker/internet_connection_checker.dart';

// Classe responável por verificar a conexão com a internet através do package internet_connection_checker
class Connection {
  Future<void> hasConnectionInternet(
      Function(bool) onSuccess, Function(String) onError) async {
    try {
      bool connected = await InternetConnectionChecker.instance.hasConnection;
      onSuccess(connected);
    } catch (e) {
      onError('Erro ao verificar conexão com internet');
    }
  }
}
