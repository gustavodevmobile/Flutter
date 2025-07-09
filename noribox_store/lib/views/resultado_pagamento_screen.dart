import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultadoPagamentoScreen extends StatelessWidget {
  final dynamic resultado;
  const ResultadoPagamentoScreen({super.key, required this.resultado});

  @override
  Widget build(BuildContext context) {
    final status = resultado['status'] ?? '---';
    final detalhes = resultado['detalhes'] ?? {};

    final metodo = detalhes['payment_method_id'] ?? '';
    final pointOfInteraction = detalhes['point_of_interaction'] ?? {};
    final transactionData = pointOfInteraction['transaction_data'] ?? {};
    final boletoUrl = detalhes['transaction_details']?['external_resource_url'] ?? '';
    final pixCopiaCola = transactionData['qr_code'] ?? '';
    final pixQrCodeBase64 = transactionData['qr_code_base64'] ?? '';
    final pixTicketUrl = transactionData['ticket_url'] ?? '';
    final linhaDigitavel = detalhes['barcode'] ?? '';

    Widget conteudo;

    if (metodo == 'pix') {
      conteudo = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pagamento via Pix', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (pixQrCodeBase64.isNotEmpty)
            Center(
              child: Image.memory(
                base64Decode(pixQrCodeBase64),
                width: 220,
                height: 220,
              ),
            ),
          const SizedBox(height: 16),
          if (pixCopiaCola.isNotEmpty) ...[
            const Text('Chave Pix Copia e Cola:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(pixCopiaCola, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copiar chave Pix'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: pixCopiaCola));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chave Pix copiada!')),
                );
              },
            ),
          ],
          const SizedBox(height: 16),
          if (pixTicketUrl.isNotEmpty)
            ElevatedButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: const Text('Abrir comprovante Pix'),
              onPressed: () => launchUrl(Uri.parse(pixTicketUrl)),
            ),
          const SizedBox(height: 16),
          Text('Status: $status', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
    } else if (boletoUrl.isNotEmpty) {
      conteudo = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pagamento via Boleto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Abrir boleto'),
            onPressed: () => launchUrl(Uri.parse(boletoUrl)),
          ),
          const SizedBox(height: 12),
          if (linhaDigitavel.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Linha digitável:', style: TextStyle(fontWeight: FontWeight.bold)),
                SelectableText(linhaDigitavel, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copiar linha digitável'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: linhaDigitavel));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Linha digitável copiada!')),
                    );
                  },
                ),
              ],
            ),
          const SizedBox(height: 16),
          Text('Status: $status', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
    } else {
      // Cartão ou outros métodos
      conteudo = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pagamento com Cartão', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(
            status == 'approved'
                ? 'Pagamento aprovado com sucesso!'
                : status == 'pending'
                    ? 'Pagamento pendente de aprovação.'
                    : 'Status do pagamento: $status',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado do Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: conteudo,
      ),
    );
  }
}