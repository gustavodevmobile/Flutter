import 'dart:convert';
import 'dart:io';

import 'package:blurt/features/cadastro/presentation/widgets/cadastro_psicanalista_form.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastroPsicanalistaFormScreen extends StatefulWidget {
  const CadastroPsicanalistaFormScreen({super.key});

  @override
  State<CadastroPsicanalistaFormScreen> createState() => _CadastroPsicanalistaFormScreenState();
}

class _CadastroPsicanalistaFormScreenState extends State<CadastroPsicanalistaFormScreen> {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Psicanalista'),
        centerTitle: true,
        elevation: 3,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [AppThemes.secondaryColor, AppThemes.primaryColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                color: const Color.fromARGB(170, 255, 255, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: CadastroPsicanalistaForm()
                )
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
