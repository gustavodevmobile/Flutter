import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Connection {
  // Future<void> hasConnection()async {
  //    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult.contains(ConnectivityResult.mobile )||
  //       connectivityResult.contains(ConnectivityResult.wifi)) {
  //     isConnected = true;
  //     print('ConnectivityResult.wifi ${Connectivity().checkConnectivity()}');
  //   } else {
  //     isConnected = false;
  //     print('Não Conectado!');
  //   }
  // }

  Future<void> hasConnectionInternet(
      Function(bool) onSuccess, Function(String) onError) async {
    try {
      bool connected = await InternetConnectionChecker.instance.hasConnection;
      print('connected $connected');
      onSuccess(connected);
    } catch (e) {
      onError('Erro ao verificar conexão com internet');
    }
  }
}
