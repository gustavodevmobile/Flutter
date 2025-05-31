import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppThemes {
  static const Color primaryColor = Color(0xFF4F8FCB);
  static const Color primaryLightColor = Color(0xFFB3D7F2);
  static const Color secondaryColor = Color(0xFF7AB0A3);
  static const Color backgroundColor = Color.fromARGB(255, 117, 177, 163);
  static const Color accentColor = Color(0xFF4F8FCB);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.amber;
  static const Color textColor = Colors.black87;
  static const Color textLightColor = Colors.white;

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

  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: secondaryColor,
          primary: primaryColor,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 10,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
          bodySmall: TextStyle(color: textColor),
        ),
      );

  static String formatarValor(double valor) {
    return 'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(valor)}';
  }

  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  static void showSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }
}
