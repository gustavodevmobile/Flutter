import 'package:intl/intl.dart';

class Formatters {
  static String formatarData(String data) {
    try {
      final date = DateTime.parse(data);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return data; // Retorna original se não conseguir converter
    }
  }
}
 