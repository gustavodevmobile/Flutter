import 'package:blurt/core/utils/formatters.dart';
import 'package:blurt/core/utils/show_solicitacao_dialog.dart';
import 'package:blurt/core/websocket/websocket_provider.dart';
import 'package:blurt/core/widgets/animated_cache_image.dart';
import 'package:blurt/features/autenticacao/presentation/controllers/login_controller.dart';
import 'package:blurt/main.dart';
import 'package:blurt/provider/provider_controller.dart';
import 'package:blurt/models/profissional/profissional.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardUsuarioScreen extends StatefulWidget {
  const DashboardUsuarioScreen({super.key});

  @override
  State<DashboardUsuarioScreen> createState() => _DashboardUsuarioScreenState();
}

class _DashboardUsuarioScreenState extends State<DashboardUsuarioScreen> {
  final sessoes = [
    {'data': '20/05/2025', 'profissional': 'Dra. Ana', 'tipo': 'Psicólogo'},
    {'data': '10/05/2025', 'profissional': 'Dr. João', 'tipo': 'Psicanalista'},
  ];
  Map<String, dynamic>? ultimaSessao;

  @override
  void initState() {
    super.initState();
    ultimaSessao = sessoes.isNotEmpty ? sessoes.first : null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSentimentoDialog();
    });
    globalWebSocketProvider.streamSolicitacao.listen((event) {
      if (event['eventType'] == 'buscando_profissionais') {
        if (event['estado'] == 'aguardando_profissionais_disponiveis') {
          if (mounted) {
            showFeedbackDialog(context, 'aguardando_atendimento_imediato',
                mensagem: event['mensagem']);
          }
        }
      } else if (event['eventType'] ==
          'feedback_solicitacao_profissional_indisponivel') {
        if (mounted) {
          showFeedbackDialog(context, 'recusada',
              mensagem: event['mensagem']);
        }
      } 
    });
  }

  @override
  void dispose() {
    Future.microtask(() {});
    super.dispose();
  }

  void _showSentimentoDialog() async {
    final List<Map<String, String>> emojis = [
      {'emoji': '😀', 'label': 'Feliz'},
      {'emoji': '😐', 'label': 'Neutro'},
      {'emoji': '😢', 'label': 'Triste'},
      {'emoji': '😡', 'label': 'Irritado'},
      {'emoji': '😱', 'label': 'Ansioso'},
      {'emoji': '😴', 'label': 'Esgotado'},
      {'emoji': '😭', 'label': 'Chateado'},
    ];
    List<int> selecionados = [];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Como você está se sentindo hoje?'),
              content: SizedBox(
                width: 120,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < emojis.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selecionados.contains(i)) {
                                selecionados.remove(i);
                              } else if (selecionados.length < 3) {
                                selecionados.add(i);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: selecionados.contains(i)
                                  ? AppThemes.primaryLightColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selecionados.contains(i)
                                    ? AppThemes.primaryLightColor
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  emojis[i]['emoji']!,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  emojis[i]['label']!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                if (selecionados.contains(i))
                                  const Icon(Icons.check,
                                      color: Colors.blue, size: 20),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Não agora'),
                    ),
                    TextButton(
                      onPressed: selecionados.isEmpty
                          ? null
                          : () {
                              final escolhidos = selecionados
                                  .map((i) => '${emojis[i]['label']}')
                                  .join(', ');
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Você escolheu: $escolhidos')),
                              );
                            },
                      child: const Text('Confirmar'),
                    )
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProviderController, WebSocketProvider,
            LoginUsuarioController>(
        builder: (context, globalProvider, websocketProvider, usuarioController,
            child) {
      final profissionaisOnline =
          websocketProvider.profissionaisOnline.isNotEmpty
              ? websocketProvider.profissionaisOnline
              : globalProvider.profissionaisOnline;

      return Scaffold(
        appBar: AppBar(
            title: const Text('Dashboard Usuário'),
            centerTitle: true,
            automaticallyImplyLeading: false, // Remove o ícone padrão do Drawer
            leading: IconButton(
                onPressed: () {
                  websocketProvider.disconnect();
                  globalProvider.clearOnline();

                  Navigator.pop(context); // Volta para a tela anterior
                },
                icon: Icon(Icons.arrow_back_ios)) // Ícone customizado

            ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(123, 255, 255, 255),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Profissionais Online',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardProdissional(
                        profOnline: profissionaisOnline,
                        scrollDirection: Axis.vertical,
                        itemHeight: MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [AppThemes.backgroundColor, AppThemes.primaryColor],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Bem-vindo, ${usuarioController.usuario?.nome}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: const Text('Última sessão'),
                      subtitle: Text(ultimaSessao != null
                          ? '${ultimaSessao!['data']} com ${ultimaSessao!['profissional']} (${ultimaSessao!['tipo']})'
                          : 'Nenhuma sessão realizada'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      title: const Text('Quantidade de sessões realizadas'),
                      trailing: Text('${sessoes.length}'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Sessões realizadas:',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  sessoes.isEmpty
                      ? const Text('Nenhuma sessão realizada.')
                      : SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: sessoes.length,
                            itemBuilder: (context, index) {
                              final sessao = sessoes[index];
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.event_available),
                                  title: Text(
                                      'Profissional: ${sessao['profissional']}'),
                                  subtitle: Text(
                                      'Data: ${sessao['data']} - Tipo: ${sessao['tipo']}'),
                                ),
                              );
                            },
                          ),
                        ),
                  //const SizedBox(height: 16),
                  ElevatedButton.icon(
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Atendimento Agora'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        final usuario = usuarioController.usuario!;
                        await showGeneroDialog(
                          context: context,
                          usuarioId: usuario.id!,
                          // dadosUsuario: {
                          //   'nome': usuario.nome,
                          //   'genero': usuario.genero,
                          //   'dataNascimento': usuario.dataNascimento,
                          //   'estado': usuario.estado,
                          //   'cidade': usuario.cidade,
                          // },
                          onSolicitar: (generoEscolhido) {
                            websocketProvider.solicitacaoAtendimentoImediato(
                              usuario.id!,
                              generoEscolhido,
                              {
                                'nome': usuario.nome,
                                'genero': usuario.genero,
                                'dataNascimento': usuario.dataNascimento,
                                'estado': usuario.estado,
                                'cidade': usuario.cidade,
                              },
                            );
                          },
                        );
                      }),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Profissionais Online:',
                          style: Theme.of(context).textTheme.titleMedium),
                      Builder(
                        builder: (context) => TextButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: const Text(
                            'Ver Todos',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (profissionaisOnline.isEmpty)
                    Card(
                        child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child:
                          const Text('Nenhum profissional online no momento.'),
                    ))
                  else
                    CardProdissional(
                      profOnline: profissionaisOnline,
                      scrollDirection: Axis.horizontal,
                    )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> showGeneroDialog({
    required BuildContext context,
    required String usuarioId,
    //required Map<String, dynamic> dadosUsuario,
    required void Function(String genero) onSolicitar,
  }) async {
    String? generoSelecionado;
    final generos = ['Masculino', 'Feminino', 'Indiferente'];
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isMobile = MediaQuery.of(context).size.width < 600;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              titlePadding: const EdgeInsets.only(top: 16, left: 24, right: 8),
              title: Text(
                'Escolha o gênero do profissional',
                style: Theme.of(context).textTheme.titleMedium,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
              content: SizedBox(
                width: isMobile ? double.infinity : 350,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: generoSelecionado,
                      decoration: InputDecoration(
                        labelText: 'Gênero',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      items: generos
                          .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(g),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          generoSelecionado = value;
                        });
                      },
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 200.ms)
                        .slideY(begin: 0.2, end: 0, delay: 200.ms),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Solicitar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: generoSelecionado == null
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              onSolicitar(generoSelecionado!);
                            },
                    )
                        .animate(target: generoSelecionado != null ? 1 : 0)
                        .fadeIn(duration: 400.ms)
                        .scale(
                            begin: const Offset(0.95, 0.95), end: Offset(1, 1)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// ...dentro do build, substitua o onPressed do botão "Atendimento Agora":
}

class CardProdissional extends StatelessWidget {
  final List<Profissional> profOnline;
  final Axis scrollDirection;
  final double? itemHeight;

  const CardProdissional(
      {required this.profOnline,
      required this.scrollDirection,
      this.itemHeight = 90,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        scrollDirection: scrollDirection,
        itemCount: profOnline.length,
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Provider.of<ProviderController>(context, listen: false)
                  .setProfissional(profOnline[index]);
              Navigator.pushNamed(
                context,
                '/perfil_profissional',
              );
            },
            child: Card(
              elevation: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        CircleAvatar(
                            radius: 35,
                            child: AnimatedCachedImage(
                              imageUrl: profOnline[index].foto,
                            )),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profOnline[index].nome.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(profOnline[index].tipoProfissional.toString()),
                            Text(
                                Formatters.formatarValor(
                                    profOnline[index].valorConsulta),
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(
                      Icons.circle,
                      color: profOnline[index].emAtendimento == false
                          ? Colors.green
                          : Colors.amber,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Função para mostrar o diálogo de seleção de gênero
