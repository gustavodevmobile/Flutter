import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';

class Formatters {
  static final cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
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

  // static TextSpan formaterCurrencySpan(
  //   String value, {
  //   TextStyle? styleInteiro,
  //   TextStyle? styleDecimal,
  // }) {
  //   final formatted = formatercurrency(value).trim();
  //   final parts = formatted.split(',');
  //   return TextSpan(
  //     children: [
  //       TextSpan(
  //         text: parts[0], // parte inteira
  //         style: styleInteiro ??
  //             const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  //       ),
  //       TextSpan(
  //         text: ',${parts.length > 1 ? parts[1] : '00'}', // parte decimal
  //         style: styleDecimal ??
  //             const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
  //       ),
  //     ],
  //   );
  // }

  // static String customFormatterCurrency(
  //     {required String value, required double valor1, required double valor2}) {
  //   final text = Text.rich(
  //     Formatters.formaterCurrencySpan(
  //       value.toString(),
  //       styleInteiro: TextStyle(
  //           fontSize: valor1, fontWeight: FontWeight.bold, color: Colors.black),
  //       styleDecimal: TextStyle(fontSize: valor2, color: Colors.grey),
  //     ),
  //   );
  //   return text.toString();
  // }
}
