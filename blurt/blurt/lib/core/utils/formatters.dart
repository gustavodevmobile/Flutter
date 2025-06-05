// Core formatters (example)
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Formatters {
  static final cpfFormater = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  static final cnpjFormater = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  static final crpFormater = MaskTextInputFormatter(
    mask: '##/######',
    filter: {"#": RegExp(r'[0-9]')},
  );

  static final dataNascimentoFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  static final telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  static String formatarValor(double valor) {
    return 'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(valor)}';
  }

  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  static bool isMaiorDeIdade(String dataNascimento) {
    try {
      // Extrai dia, mês e ano do formato dd/MM/yyyy
      final partes = dataNascimento.split('/');
      if (partes.length != 3) return false;
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);

      final nascimento = DateTime(ano, mes, dia);
      final hoje = DateTime.now();

      final idade = hoje.year -
          nascimento.year -
          ((hoje.month < nascimento.month ||
                  (hoje.month == nascimento.month && hoje.day < nascimento.day))
              ? 1
              : 0);

      return idade >= 18;
    } catch (e) {
      return false;
    }
  }

  // Função auxiliar para converter dd/MM/yyyy em DateTime
  static DateTime? parseData(String data) {
    try {
      final partes = data.split('/');
      if (partes.length != 3) return null;
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);
      return DateTime(ano, mes, dia);
    } catch (e) {
      return null;
    }
  }
}
