// import 'dart:async';
// import 'dart:convert';
// import 'dart:js';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// Future<String?> obterPaymentMethodId(String cardNumber) async {
//   try {
//     final completer = Completer<String?>();
//     context.callMethod('obterPaymentMethodId', [
//       dotenv.env['PUBLIC_KEY_MP'],
//       cardNumber,
//       (id) {
//         completer.complete(id as String?);
//       }
//     ]);
//     return completer.future;
//   } catch (e) {
//     print('Erro ao obter Payment Method ID: $e');
//     return null;
//   }
// }
// //usuario de teste:
// //TESTUSER447085504

// //cartao de teste:
// //5031 4332 1540 6351

// Future<void> pagarComCartao({
//   required String nome,
//   required double preco,
//   required int quantidade,
//   required String email,
//   required String cardNumber,
//   required String cardExpMonth,
//   required String cardExpYear,
//   required String cardCVC,
//   required String paymentMethodId,
// }) async {
//   final completer = Completer<String>();

//   // Chama a função JS para gerar o token do cartão
//   context.callMethod('gerarTokenCartao', [
//     dotenv.env['PUBLIC_KEY_MP'],
//     {
//       'cardNumber': cardNumber,
//       'cardholderName': nome,
//       'securityCode': cardCVC,
//       'expirationMonth': cardExpMonth,
//       'expirationYear': cardExpYear,
//       'identificationType': 'CPF', // ou outro, se necessário
//       'identificationNumber': '00000000000', // peça ao usuário
//     },
//     (result) {
//       if (result['status'] == 200) {
//         completer.complete(result['id']);
//       } else {
//         completer.completeError(result['message'] ?? 'Erro ao gerar token');
//       }
//     }
//   ]);

//   final token = await completer.future;
//   print('Token do cartão: $token');
//   // Agora envie os dados para o backend
//   final response = await http.post(
//     Uri.parse('${dotenv.env['API_URL']}/pagamentos/pagar-direto'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({
//       'token': token,
//       'nome': nome,
//       'preco': preco,
//       'quantidade': quantidade,
//       'email': email,
//       'payment_method_id': paymentMethodId,
//     }),
//   );

//   if (response.statusCode == 200) {
//     // Pagamento realizado!
//     print('Pagamento aprovado!');
//   } else {
//     print('Erro ao processar pagamento: ${response.body}');
//   }
// }
