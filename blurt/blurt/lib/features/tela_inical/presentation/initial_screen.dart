import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  int _expanded = 0; // 0: nenhum, 1: usuario, 2: profissional

  void _toggle(int value) {
    setState(() {
      _expanded = _expanded == value ? 0 : value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo!'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppThemes.secondaryColor, AppThemes.primaryColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo animado
                      Image.asset(
                        'assets/image/logotipoBlurt2.png',
                        width: 220,
                        height: 220,
                        fit: BoxFit.contain,
                      ).animate().fadeIn(duration: 800.ms).scale(
                          duration: 800.ms,
                          begin: const Offset(0.8, 0.8),
                          end: Offset(1, 1)),

                      Text(
                        'Bem-vindo ao seu espaço de acolhimento e terapia!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 600.ms,
                              delay: 200.ms),
                      const SizedBox(height: 40),
                      Card(
                        elevation: 8,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 32),
                          child: Column(
                            children: [
                              // Botão Usuário animado
                              ElevatedButton(
                                onPressed: () => _toggle(1),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  textStyle: const TextStyle(fontSize: 18),
                                  backgroundColor: AppThemes.secondaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Sou Usuário'),
                              )
                                  .animate()
                                  .fadeIn(duration: 500.ms, delay: 100.ms)
                                  .slideX(
                                      begin: -0.2,
                                      end: 0,
                                      duration: 500.ms,
                                      delay: 100.ms),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                height: _expanded == 1 ? 50 : 0,
                                child: _expanded == 1
                                    ? Row(
                                        key: const ValueKey('usuario'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/login_usuario');
                                            },
                                            child: const Text('Entrar'),
                                          )
                                              .animate()
                                              .fadeIn(duration: 400.ms)
                                              .slideX(begin: -0.1, end: 0),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/cadastro_usuario');
                                            },
                                            child: const Text('Cadastrar'),
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 400.ms,
                                                  delay: 100.ms)
                                              .slideX(
                                                  begin: 0.1,
                                                  end: 0,
                                                  delay: 100.ms),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              const SizedBox(height: 16),
                              // Botão Psicólogo animado
                              ElevatedButton(
                                onPressed: () => _toggle(2),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  textStyle: const TextStyle(fontSize: 18),
                                  backgroundColor: AppThemes.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Sou Psicólogo(a)'),
                              )
                                  .animate()
                                  .fadeIn(duration: 500.ms, delay: 200.ms)
                                  .slideX(
                                      begin: 0.2,
                                      end: 0,
                                      duration: 500.ms,
                                      delay: 200.ms),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                height: _expanded == 2 ? 50 : 0,
                                child: _expanded == 2
                                    ? Row(
                                        key: const ValueKey('profissional'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context,
                                                  '/login_profissional');
                                            },
                                            child: const Text('Entrar'),
                                          )
                                              .animate()
                                              .fadeIn(duration: 400.ms)
                                              .slideX(begin: -0.1, end: 0),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context,
                                                  '/cadastro_psicologo');
                                            },
                                            child: const Text('Cadastrar'),
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 400.ms,
                                                  delay: 100.ms)
                                              .slideX(
                                                  begin: 0.1,
                                                  end: 0,
                                                  delay: 100.ms),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              const SizedBox(height: 16),
                              // Botão Psicanalista animado
                              ElevatedButton(
                                onPressed: () => _toggle(3),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  textStyle: const TextStyle(fontSize: 18),
                                  backgroundColor:
                                      const Color.fromARGB(255, 98, 143, 185),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Sou Psicanalista'),
                              )
                                  .animate()
                                  .fadeIn(duration: 500.ms, delay: 300.ms)
                                  .slideX(
                                      begin: -0.2,
                                      end: 0,
                                      duration: 500.ms,
                                      delay: 300.ms),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                height: _expanded == 3 ? 50 : 0,
                                child: _expanded == 3
                                    ? Row(
                                        key: const ValueKey('profissional'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pushNamed(context,
                                                  '/login_profissional');
                                            },
                                            child: const Text('Entrar'),
                                          )
                                              .animate()
                                              .fadeIn(duration: 400.ms)
                                              .slideX(begin: -0.1, end: 0),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context,
                                                  '/cadastro_psicanalista');
                                            },
                                            child: const Text('Cadastrar'),
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 400.ms,
                                                  delay: 100.ms)
                                              .slideX(
                                                  begin: 0.1,
                                                  end: 0,
                                                  delay: 100.ms),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 700.ms, delay: 200.ms)
                            .slideY(
                                begin: 0.1,
                                end: 0,
                                duration: 700.ms,
                                delay: 200.ms),
                      )
                    ])),
          ),
        ),
      ),
    );
  }
}
