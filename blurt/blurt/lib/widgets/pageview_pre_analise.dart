import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RespostasPreAnalise {
  bool desejaResponder;
  bool dormeBem;
  bool algoTiraPaz;
  String motivoAnsiedade;
  bool querFalarAcontecimento;
  String acontecimento;
  bool pensamentosRuins;
  bool isRisk;
  RespostasPreAnalise({
    this.desejaResponder = false,
    this.dormeBem = false,
    this.algoTiraPaz = false,
    this.motivoAnsiedade = '',
    this.querFalarAcontecimento = false,
    this.acontecimento = '',
    this.pensamentosRuins = false,
    this.isRisk = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'desejaResponder': desejaResponder,
      'dormeBem': dormeBem,
      'algoTiraPaz': algoTiraPaz,
      'motivoAnsiedade': motivoAnsiedade,
      'querFalarAcontecimento': querFalarAcontecimento,
      'acontecimento': acontecimento,
      'pensamentosRuins': pensamentosRuins,
      'isRisk': isRisk,
    };
  }

  factory RespostasPreAnalise.fromMap(Map<String, dynamic> map) {
    return RespostasPreAnalise(
      desejaResponder: map['desejaResponder'] ?? false,
      dormeBem: map['dormeBem'] ?? false,
      algoTiraPaz: map['algoTiraPaz'] ?? false,
      motivoAnsiedade: map['motivoAnsiedade'] ?? '',
      querFalarAcontecimento: map['querFalarAcontecimento'] ?? false,
      acontecimento: map['acontecimento'] ?? '',
      pensamentosRuins: map['pensamentosRuins'] ?? false,
      isRisk: map['isRisk'] ?? false,
    );
  }
}

Future<RespostasPreAnalise?> showQuestionarioPreAnalise(
    BuildContext context) async {
  final pageController = PageController();
  int currentPage = 0;
  final respostas = RespostasPreAnalise();
  final textStylePergunta =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final corPrimaria = Theme.of(context).colorScheme.primary;
  final corSecundaria = Theme.of(context).colorScheme.secondary;
  final radius = BorderRadius.circular(16);
  final inputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: radius),
    filled: true,
    fillColor: Colors.grey[100],
    counterText: '',
  );

  // Função para voltar para a página anterior
  void voltar() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  return await showDialog<RespostasPreAnalise>(
    context: context,
    barrierDismissible: true, // permite fechar ao clicar fora
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
              AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: radius),
                title: Row(
                  children: [
                    Icon(Icons.quiz, color: corPrimaria),
                    const SizedBox(width: 8),
                    const Text('Pré-análise rápida'),
                  ],
                ),
                content: SizedBox(
                  width: 350,
                  height: 320,
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) =>
                        setState(() => currentPage = index),
                    children: [
                      // Página 1
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Para uma sessão mais aprimorada, deseja responder um breve questionário?',
                                style: textStylePergunta,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _modernRadio(
                                  context,
                                  label: 'Sim',
                                  selected: respostas.desejaResponder,
                                  onTap: () {
                                    setState(() {
                                      respostas.desejaResponder = true;
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 200), () {
                                      pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 350),
                                          curve: Curves.easeInOut);
                                    });
                                  },
                                  cor: corPrimaria,
                                ),
                                const SizedBox(width: 24),
                                _modernRadio(
                                  context,
                                  label: 'Não',
                                  selected: !respostas.desejaResponder,
                                  onTap: () {
                                    Navigator.of(context).pop(null);
                                  },
                                  cor: corSecundaria,
                                ),
                              ],
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                      ),
                      // Página 2
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Você tem conseguido dormir bem nos últimos dias?',
                                style: textStylePergunta,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _modernRadio(
                                  context,
                                  label: 'Sim',
                                  selected: respostas.dormeBem,
                                  onTap: () {
                                    setState(() {
                                      respostas.dormeBem = true;
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 200), () {
                                      pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 350),
                                          curve: Curves.easeInOut);
                                    });
                                  },
                                  cor: corPrimaria,
                                ),
                                const SizedBox(width: 24),
                                _modernRadio(
                                  context,
                                  label: 'Não',
                                  selected: !respostas.dormeBem,
                                  onTap: () {
                                    setState(() {
                                      respostas.dormeBem = false;
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 200), () {
                                      pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 350),
                                          curve: Curves.easeInOut);
                                    });
                                  },
                                  cor: corSecundaria,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (currentPage > 0)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Voltar'),
                                  onPressed: () {
                                    voltar();
                                  },
                                ),
                              ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                      ),
                      // Página 3
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Algo tem tirado a sua paz ou causado ansiedade ultimamente?',
                                style: textStylePergunta,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _modernRadio(
                                  context,
                                  label: 'Sim',
                                  selected: respostas.algoTiraPaz,
                                  onTap: () {
                                    setState(() {
                                      respostas.algoTiraPaz = true;
                                    });
                                  },
                                  cor: corPrimaria,
                                ),
                                const SizedBox(width: 24),
                                _modernRadio(
                                  context,
                                  label: 'Não',
                                  selected: !respostas.algoTiraPaz,
                                  onTap: () {
                                    setState(() {
                                      respostas.algoTiraPaz = false;
                                      respostas.motivoAnsiedade =
                                          'Não respondido';
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 200), () {
                                      pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 350),
                                          curve: Curves.easeInOut);
                                    });
                                  },
                                  cor: corSecundaria,
                                ),
                              ],
                            ),
                            if (respostas.algoTiraPaz)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextField(
                                  maxLength: 20,
                                  maxLines: 2,
                                  decoration: inputDecoration.copyWith(
                                      labelText: 'Conte um pouco (opcional)'),
                                  onChanged: (v) => respostas.motivoAnsiedade =
                                      v.isEmpty ? 'Não respondido' : v,
                                ),
                              ),
                            if (respostas.algoTiraPaz)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Voltar'),
                                    onPressed: () {
                                      voltar();
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (respostas.motivoAnsiedade.isEmpty) {
                                        respostas.motivoAnsiedade =
                                            'Não respondido';
                                      }
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 350),
                                            curve: Curves.easeInOut);
                                      });
                                    },
                                    child: const Text('Próxima'),
                                  ),
                                ],
                              ),
                            if (!respostas.algoTiraPaz && currentPage > 0)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Voltar'),
                                  onPressed: () {
                                    voltar();
                                  },
                                ),
                              ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                      ),
                      // Página 4
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Gostaria de falar sobre algum acontecimento recente que te afetou?',
                                style: textStylePergunta,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _modernRadio(
                                  context,
                                  label: 'Sim',
                                  selected: respostas.querFalarAcontecimento,
                                  onTap: () {
                                    setState(() {
                                      respostas.querFalarAcontecimento = true;
                                    });
                                  },
                                  cor: corPrimaria,
                                ),
                                const SizedBox(width: 24),
                                _modernRadio(
                                  context,
                                  label: 'Não',
                                  selected: !respostas.querFalarAcontecimento,
                                  onTap: () {
                                    setState(() {
                                      respostas.querFalarAcontecimento = false;
                                      respostas.acontecimento =
                                          'Não respondido';
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 200), () {
                                      pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 350),
                                          curve: Curves.easeInOut);
                                    });
                                  },
                                  cor: corSecundaria,
                                ),
                              ],
                            ),
                            if (respostas.querFalarAcontecimento)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: TextField(
                                  maxLength: 200,
                                  maxLines: 3,
                                  decoration: inputDecoration.copyWith(
                                      labelText: 'Conte um pouco (opcional)'),
                                  onChanged: (v) => respostas.acontecimento =
                                      v.isEmpty ? 'Não respondido' : v,
                                ),
                              ),
                            if (respostas.querFalarAcontecimento)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Voltar'),
                                    onPressed: () {
                                      voltar();
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (respostas.acontecimento.isEmpty) {
                                        respostas.acontecimento =
                                            'Não respondido';
                                      }
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 350),
                                            curve: Curves.easeInOut);
                                      });
                                    },
                                    child: const Text('Próxima'),
                                  ),
                                ],
                              ),
                            if (!respostas.querFalarAcontecimento &&
                                currentPage > 0)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Voltar'),
                                  onPressed: () {
                                    voltar();
                                  },
                                ),
                              ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                      ),
                      // Página 5
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Tem sentido vontade de sumir, fugir ou pensamentos de que nada vale a pena?',
                                style: textStylePergunta,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _modernRadio(
                                  context,
                                  label: 'Sim',
                                  selected: respostas.pensamentosRuins,
                                  onTap: () {
                                    setState(() {
                                      respostas.pensamentosRuins = true;
                                      respostas.isRisk = true;
                                    });
                                  },
                                  cor: Colors.redAccent,
                                ),
                                const SizedBox(width: 24),
                                _modernRadio(
                                  context,
                                  label: 'Não',
                                  selected: !respostas.pensamentosRuins,
                                  onTap: () {
                                    setState(() {
                                      respostas.pensamentosRuins = false;
                                      respostas.isRisk = false;
                                    });
                                  },
                                  cor: corSecundaria,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Voltar'),
                                  onPressed: () {
                                    voltar();
                                  },
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.check_circle_outline),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: corPrimaria,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: radius),
                                  ),
                                  onPressed: () {
                                    // Garante que campos de texto não fiquem vazios
                                    if (respostas.algoTiraPaz &&
                                        respostas.motivoAnsiedade.isEmpty) {
                                      respostas.motivoAnsiedade =
                                          'Não respondido';
                                    }
                                    if (respostas.querFalarAcontecimento &&
                                        respostas.acontecimento.isEmpty) {
                                      respostas.acontecimento =
                                          'Não respondido';
                                    }
                                    Navigator.of(context).pop(respostas);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Questionário finalizado! Risco: [1m${respostas.isRisk ? 'Sim' : 'Não'}',
                                        ),
                                      ),
                                    );
                                    final resp = jsonEncode(respostas.toMap());
                                    print(
                                        '@@@@@@@@@@@@@ @@@@  Respostas: $resp');
                                  },
                                  label: const Text('Finalizar'),
                                ),
                              ],
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _modernRadio(BuildContext context,
    {required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color cor}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? cor.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: selected ? cor : Colors.grey.shade300, width: 2),
      ),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? cor : Colors.grey,
            size: 22,
          ),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 16, color: selected ? cor : Colors.black87)),
        ],
      ),
    ),
  );
}
