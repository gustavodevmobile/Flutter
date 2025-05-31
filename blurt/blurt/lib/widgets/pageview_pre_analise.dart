import 'package:flutter/material.dart';

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
}

Future<RespostasPreAnalise?> showQuestionarioPreAnalise(
    BuildContext context) async {
  final pageController = PageController();
  int currentPage = 0;
  final respostas = RespostasPreAnalise();
  final textStylePergunta =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final textStyleOpcao = const TextStyle(fontSize: 16);
  final corPrimaria = Theme.of(context).colorScheme.primary;
  final corSecundaria = Theme.of(context).colorScheme.secondary;
  final radius = BorderRadius.circular(16);
  final inputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: radius),
    filled: true,
    fillColor: Colors.grey[100],
    counterText: '',
  );

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
                  height: 280,
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) =>
                        setState(() => currentPage = index),
                    children: [
                      // Página 1
                      Column(
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
                      ),
                      // Página 2
                      Column(
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
                        ],
                      ),
                      // Página 3
                      Column(
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
                                    respostas.motivoAnsiedade = '';
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
                              padding: const EdgeInsets.only(top: 12.0),
                              child: TextField(
                                maxLength: 200,
                                maxLines: 3,
                                decoration: inputDecoration.copyWith(
                                    labelText: 'Conte um pouco (opcional)'),
                                onChanged: (v) => respostas.motivoAnsiedade = v,
                              ),
                            ),
                          if (respostas.algoTiraPaz)
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 350),
                                        curve: Curves.easeInOut);
                                  });
                                },
                                child: const Text('Próxima'),
                              ),
                            ),
                        ],
                      ),
                      // Página 4
                      Column(
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
                                    respostas.acontecimento = '';
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
                                onChanged: (v) => respostas.acontecimento = v,
                              ),
                            ),
                          if (respostas.querFalarAcontecimento)
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 350),
                                        curve: Curves.easeInOut);
                                  });
                                },
                                child: const Text('Próxima'),
                              ),
                            ),
                        ],
                      ),
                      // Página 5
                      Column(
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
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check_circle_outline),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: corPrimaria,
                              shape:
                                  RoundedRectangleBorder(borderRadius: radius),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(respostas);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Questionário finalizado! Risco: ${respostas.isRisk ? 'Sim' : 'Não'}',
                                  ),
                                ),
                              );
                            },
                            label: const Text('Finalizar'),
                          ),
                        ],
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
