import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';

class Formatters {
  static final cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {
      '#': RegExp(r'[0-9]'),
    },
  );
  static final telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) ####-####',
    filter: {
      '#': RegExp(r'[0-9]'),
    },
  );
  
  static final celularFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {
      '#': RegExp(r'[0-9]'),
    },
  );
  static final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {
      '#': RegExp(r'[0-9]'),
    },
  );

  static String formatercurrency(String value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
      decimalDigits: 2,
    );
    return formatter.format(double.tryParse(value) ?? 0);
  }

  static String dataEntregaFormatada(int prazoEmDias) {
    final dataEntrega = DateTime.now().add(Duration(days: prazoEmDias));
    return DateFormat('dd/MM').format(dataEntrega);
  }
}
