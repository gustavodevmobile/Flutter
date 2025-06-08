import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:blurt/features/cadastro/domain/usecases/cadastrar_profissional_usecase.dart';
import 'package:blurt/models/profissional/profissional.dart';

class CadastroProfissionalController extends ChangeNotifier {
  final CadastrarProfissionalUseCase cadastrarUseCase;
  CadastroProfissionalController(this.cadastrarUseCase);

  Future<String> fileToBase64(File? file) async {
    if (file == null) return '';
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<String> cadastrarProfissional(Map<String, dynamic> data) async {
    // Converte campos File para base64
    final Map<String, dynamic> dataConvertido = Map.from(data);
    for (final entry in data.entries) {
      if (entry.value is File) {
        dataConvertido[entry.key] = await fileToBase64(entry.value);
      }
    }
    print('Dados convertidos: $dataConvertido');
    final profissional = Profissional(
      nome: dataConvertido['nome'],
      email: dataConvertido['email'],
      senha: dataConvertido['senha'],
      bio: dataConvertido['bio'] ?? '',
      cpf: dataConvertido['cpf'],
      cnpj: dataConvertido['cnpj'] ?? '',
      crp: dataConvertido['crp'] ?? '',
      diplomaPsicanalista: dataConvertido['diplomaPsicanalista'],
      declSupClinica: dataConvertido['declSupClinica'],
      declAnPessoal: dataConvertido['declAnPessoal'],
      tipoProfissional: dataConvertido['tipoProfissional'],
      estaOnline: dataConvertido['estaOnline'] ?? false,
      atendePlantao: dataConvertido['atendePlantao'] ?? false,
      emAtendimento: dataConvertido['emAtendimento'] ?? false,
      valorConsulta: dataConvertido['valorConsulta'] ?? 0.0,
      genero: dataConvertido['genero'],
      foto: dataConvertido['foto'] ?? '',
      imagemDocumento: dataConvertido['imagemDocumento'],
      imagemSelfieComDoc: dataConvertido['imagemSelfieComDoc'],
      createdAt: dataConvertido['createdAt'],
      chavePix: dataConvertido['chavePix'] ?? '',
      contaBancaria: dataConvertido['contaBancaria'] ?? '',
      agencia: dataConvertido['agencia'] ?? '',
      banco: dataConvertido['banco'] ?? '',
      tipoConta: dataConvertido['tipoConta'] ?? '',
      abordagemPrincipal: dataConvertido['abordagemPrincipal'] ?? '',
      abordagensUtilizadas: dataConvertido['abordagensUtilizadas'] is List<String>
          ? List<String>.from(dataConvertido['abordagensUtilizadas'])
          : null,
      especialidadePrincipal: dataConvertido['especialidadePrincipal'] ?? '',
      temasClinicos: dataConvertido['temasClinicos'] is List<String>
          ? List<String>.from(dataConvertido['temasClinicos'])
          : null,
      certificadoEspecializacao: dataConvertido['certificadoEspecializacao'] ?? '',
    );
    
    try {
      final result = await cadastrarUseCase(profissional);
      notifyListeners();
      return result;
    } catch (error) {
      print('Erro ao cadastrar profissional: $error');
      notifyListeners();
      rethrow;
    }
  }
}
