import 'package:flutter/material.dart';
import 'package:noribox_store/themes/themes.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Themes.blackLight,
        borderRadius:BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black26,
        //     blurRadius: 12,
        //     offset: Offset(0, -2),
        //   ),
        // ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo ou nome da loja
          Text(
            "Asatoma Store",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // Redes sociais
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.facebook, color: Colors.white),
                onPressed: () {},
                tooltip: "Facebook",
              ),
              IconButton(
                icon: Icon(Icons.ice_skating, color: Colors.white),
                onPressed: () {},
                tooltip: "Instagram",
              ),
              IconButton(
                icon: Icon(Icons.whatshot, color: Colors.white),
                onPressed: () {},
                tooltip: "WhatsApp",
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Informações de contato
          Text(
            "Contato: suporte@noribox.com.br | (11) 99999-9999",
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Selo de segurança
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: Colors.greenAccent, size: 20),
              const SizedBox(width: 6),
              Text(
                "Ambiente 100% seguro",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Direitos autorais
          Text(
            "© ${DateTime.now().year} Noribox Store. Todos os direitos reservados.",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
