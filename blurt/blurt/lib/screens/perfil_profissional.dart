import 'package:blurt/core/utils/background.dart';
import 'package:blurt/core/utils/formatters.dart';
import 'package:blurt/core/websocket/websocket_provider.dart';
import 'package:blurt/core/widgets/animated_cache_image.dart';
import 'package:blurt/features/autenticacao/presentation/controllers/login_controller.dart';
import 'package:blurt/provider/provider_controller.dart';
import 'package:blurt/theme/themes.dart';
import 'package:blurt/widgets/pageview_pre_analise.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:provider/provider.dart';

class PerfilProfissionalScreen extends StatefulWidget {
  const PerfilProfissionalScreen({super.key});

  @override
  State<PerfilProfissionalScreen> createState() =>
      _PerfilProfissionalScreenState();
}

class _PerfilProfissionalScreenState extends State<PerfilProfissionalScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProviderController, WebSocketProvider,
            LoginUsuarioController>(
        builder: (context, globalProvider, websockerProvider, usuarioController,
            child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profissional'),
          centerTitle: true,
        ),
        body: Background(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                      radius: 48,
                      child: AnimatedCachedImage(
                        imageUrl: globalProvider.profissional?.foto ?? '',
                      )),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    Formatters.capitalize(
                        globalProvider.profissional?.nome ?? ''),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    globalProvider.profissional?.tipoProfissional ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                globalProvider.profissional?.tipoProfissional == 'Psicólogo'
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                              'CRP: ${globalProvider.profissional!.crp}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 16),
                Text(
                  'Biografia:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (globalProvider.profissional!.bio != null &&
                    globalProvider.profissional!.bio!.isNotEmpty)
                  Text(
                    globalProvider.profissional!.bio!,
                    style: const TextStyle(fontSize: 16),
                  )
                else
                  const Text(
                    'Nenhuma biografia informada',
                    style: TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 16),
                globalProvider.profissional!.tipoProfissional == 'Psicóloga' ||
                        globalProvider.profissional!.tipoProfissional ==
                            'Psicólogo'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (globalProvider.profissional!.abordagemPrincipal !=
                              null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Abordagem Principal:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(
                                    Formatters.capitalize(globalProvider
                                        .profissional!.abordagemPrincipal!),
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 12),
                              ],
                            ),
                          //const SizedBox(height: 12),
                          if (globalProvider
                                      .profissional!.abordagensUtilizadas !=
                                  null &&
                              globalProvider.profissional!.abordagensUtilizadas!
                                  .isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Abordagens Utilizadas:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  children: globalProvider
                                      .profissional!.abordagensUtilizadas!
                                      .map((abord) => Chip(
                                          label: Text(
                                              Formatters.capitalize(abord))))
                                      .toList(),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Especialização Principal:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              globalProvider.profissional
                                              ?.especialidadePrincipal !=
                                          null &&
                                      globalProvider.profissional!
                                          .especialidadePrincipal!.isNotEmpty
                                  ? Text(
                                      globalProvider.profissional!
                                          .especialidadePrincipal!,
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : Text(
                                      'Nenhuma especialização informada',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                              const SizedBox(height: 12),
                            ],
                          ),
                          if (globalProvider
                              .profissional!.temasClinicos!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Temas Clínicos:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  children: globalProvider
                                      .profissional!.temasClinicos!
                                      .map((tema) => Chip(
                                          label: Text(
                                              Formatters.capitalize(tema))))
                                      .toList(),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                        ],
                      )
                    : Column(
                        children: [
                          Text('Abodagem pricipal:',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Psicanalista',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 16),
                          Center(
                            child: Card(
                              color: Colors.amber[100],
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Profissional formado em Psicanálise',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Atenção: Psicanalistas não são Psicólogos. '
                                      'Seus métodos clínicos são baseados na Psicanálise, '
                                      'que possui abordagem, formação e regulamentação diferentes da Psicologia.',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                      'Valor da Consulta: R\$ ${Formatters.formatarValor(globalProvider.profissional!.valorConsulta)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                              final respostas =
                                  await showQuestionarioPreAnalise(context);
                              print(respostas?.desejaResponder);

                              if (respostas == null) {
                                // Não quis responder o questionário, envia solicitação simples
                                websockerProvider.solicitarAtendimentoAvulso(
                                  usuarioController.usuario!.id!,
                                  globalProvider.profissional!.id!,
                                  {
                                    'nome': usuarioController.usuario!.nome,
                                    'genero': usuarioController.usuario!.genero,
                                    //'foto': usuarioController.usuario!.foto ?? '',
                                    'dataNascimento': usuarioController
                                        .usuario!.dataNascimento,
                                    'estado': usuarioController.usuario!.estado,
                                    'cidade': usuarioController.usuario!.cidade,
                                    'preAnalise': 'Não respondeu o questionário',
                                  },
                                );
                              } else {
                                // Respondeu o questionário, envia solicitação com as respostas
                                websockerProvider.solicitarAtendimentoAvulso(
                                  usuarioController.usuario!.id!,
                                  globalProvider.profissional!.id!,
                                  {
                                    'nome': usuarioController.usuario!.nome,
                                    'genero': usuarioController.usuario!.genero,
                                    //'foto': usuarioController.usuario!.foto ?? '',
                                    'dataNascimento': usuarioController
                                        .usuario!.dataNascimento,
                                    'estado': usuarioController.usuario!.estado,
                                    'cidade': usuarioController.usuario!.cidade,
                                    'preAnalise': respostas.toMap(),
                                  },
                                );
                              }
                            },

                      // loading
                      //     ? null
                      //     : () async {
                      //         setState(() {
                      //           //loading = true;
                      //         });
                      //         try {
                      //           // solicitação websocket context app principal (foreground)
                      //           websockerProvider.solicitarAtendimentoAvulso(
                      //               usuarioController.usuario!.id!,
                      //               globalProvider.profissional!.id!, {
                      //             'nome': usuarioController.usuario!.nome,
                      //             'genero': usuarioController.usuario!.genero,
                      //             //'foto': usuarioController.usuario!.foto ?? '',
                      //             'dataNascimento':
                      //                 usuarioController.usuario!.dataNascimento,
                      //             'estado': usuarioController.usuario!.estado,
                      //             'cidade': usuarioController.usuario!.cidade,

                      //             'profissionalId':
                      //                 globalProvider.profissional!.id!,
                      //             'usuarioId': usuarioController.usuario!.id!,
                      //             'preAnalise': {
                      //               'motivoConsulta': 'Motivo da consulta',
                      //               'objetivo': 'Objetivo da consulta',
                      //               'sintomas': 'Sintomas relatados',
                      //               'historicoClinico': 'Histórico clínico',
                      //             },
                      //           });
                      //         } catch (e) {
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //             SnackBar(
                      //               content: Text(
                      //                   'Erro ao solicitar atendimento: $e'),
                      //             ),
                      //           );
                      //           print('Erro ao solicitar atendimento: $e');
                      //         } finally {
                      //           setState(() {
                      //             //loading = false;
                      //           });
                      //         }
                      //       },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 48),
                          textStyle: const TextStyle(fontSize: 18),
                          backgroundColor: AppThemes.secondaryColor),
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Solicitar Atendimento')),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
