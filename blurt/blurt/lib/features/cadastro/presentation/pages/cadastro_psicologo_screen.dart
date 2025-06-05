import 'package:blurt/core/utils/background.dart';
import 'package:blurt/features/cadastro/presentation/widgets/cadastro_psicologo_form.dart';
import 'package:flutter/material.dart';

class CadastroPsicologoScreen extends StatelessWidget {
  const CadastroPsicologoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Profissional'),
        centerTitle: true,
        elevation: 3,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Background(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: const CadastroPsicologoForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
