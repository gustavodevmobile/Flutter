import 'package:flutter/material.dart';

class CheckoutContainer extends StatelessWidget {
  final Widget child;
  const CheckoutContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 600,
        height: 900,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, color: Colors.green, size: 28),
                const SizedBox(width: 8),
                Text(
                  "Pagamento 100% seguro",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Seus dados estão protegidos com criptografia SSL.",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: child,
              ),
            ),
            const SizedBox(height: 16),
            // Ícones de bandeiras de cartão (adicione aqui se quiser)
            const SizedBox(height: 16),
            Text(
              "Dúvidas? Fale com nosso suporte: suporte@seudominio.com",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}