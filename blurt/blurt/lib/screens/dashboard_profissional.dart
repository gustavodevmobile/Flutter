import 'dart:convert';

import 'package:blurt/features/autenticacao/presentation/controllers/login_profissional_controller.dart';
import 'package:blurt/provider/provider_controller.dart';
import 'package:blurt/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardProfissionalScreen extends StatefulWidget {
  const DashboardProfissionalScreen({super.key});

  @override
  State<DashboardProfissionalScreen> createState() =>
      _DashboardProfissionalScreenState();
}

class _DashboardProfissionalScreenState
    extends State<DashboardProfissionalScreen> {
  bool online = false;
  bool plantao = true;
  String? fotoPerfil;
  MemoryImage? _fotoCache;
  String? _fotoBase64Cache;
  @override
  Widget build(BuildContext context) {
    final fotoBase64 =
        context.watch<LoginProfissionalController>().profissional?.foto;
    // Atualiza o cache só se a imagem mudou
    if (fotoBase64 != null && fotoBase64 != _fotoBase64Cache) {
      _fotoCache = MemoryImage(base64Decode(fotoBase64));
      _fotoBase64Cache = fotoBase64;
    }
    // Dados mockados para exemplo
    final int numeroAtendimentos = 42;
    final double ganhosEstimados = 3200.50;
    final double avaliacao = 4.8;
    final int sessoesRealizadas = 38;
    final int recibosEmitidos = 25;
    final double extratoGanhos = 2950.00;

    return Consumer2<LoginProfissionalController, ProviderController>(
        builder: (context, controllerLogin, globalProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Olá, ${controllerLogin.profissional?.nome ?? ''}'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                // await LoginController()
                //     .logoutProfissional(value.profissional!.id!, (onSuccess) {
                //   AppThemes.showSnackBar(context, onSuccess,
                //       backgroundColor: Colors.green);
                //   Provider.of<ProviderController>(context, listen: false)
                //       .clearProfissional();
                //   Navigator.pop(context);
                // }, (onError) {
                //   AppThemes.showSnackBar(context, onError,
                //       backgroundColor: Colors.red);
                // });
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppThemes.secondaryColor,
                AppThemes.primaryColor,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //const SizedBox(width: 1),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: Theme.of(context).primaryColor,
                              backgroundImage: _fotoCache,
                              child: fotoBase64 == null
                                  ? const Icon(Icons.person, size: 48)
                                  : null,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/editar_perfil_profissional');
                                },
                                label: const Text(
                                  'Editar Perfil',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets
                                      .zero, // Remove o padding do botão
                                  minimumSize: Size(0,
                                      0), // Remove restrição de tamanho mínimo
                                  tapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap, // Área de toque justa
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                    globalProvider.online
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: globalProvider.online ? AppThemes.online :AppThemes.offline,
                                    size: 16),
                                const SizedBox(width: 6),
                                Text(
                                    globalProvider.online
                                        ? 'Online'
                                        : 'Não disponível',
                                    style: TextStyle(
                                        color: globalProvider.online
                                            ? Colors.white
                                            : Colors.black)),
                                Switch(
                                  value: globalProvider.online,
                                  onChanged: (v) => globalProvider.setOnline(v),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                    globalProvider.plantao
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: globalProvider.plantao
                                        ? AppThemes.online
                                        : AppThemes.offline,
                                    size: 16),
                                const SizedBox(width: 6),
                                Text(
                                    globalProvider.plantao
                                        ? 'Atender plantão'
                                        : 'Não atender plantão',
                                    style: TextStyle(
                                        color: globalProvider.plantao
                                            ? Colors.white
                                            : Colors.black)),
                                Switch(
                                  value: globalProvider.plantao,
                                  onChanged: (v) =>
                                      globalProvider.setPlantao(v),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/atendimento_profissional');
                        },
                        child: _InfoCard(
                            title: 'Atendimentos',
                            value: '$numeroAtendimentos',
                            icon: Icons.people_alt_outlined),
                      ),
                      _InfoCard(
                          title: 'Ganhos Estimados',
                          value: 'R\$ ${ganhosEstimados.toStringAsFixed(2)}',
                          icon: Icons.attach_money),
                      _InfoCard(
                          title: 'Avaliação',
                          value: '$avaliacao',
                          icon: Icons.star,
                          color: Colors.amber),
                      _InfoCard(
                          title: 'Sessões Realizadas',
                          value: '$sessoesRealizadas',
                          icon: Icons.event_available),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ElevatedButton.icon(
                  //   icon: const Icon(Icons.flash_on),
                  //   label: const Text('Atender Agora'),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.green,
                  //     foregroundColor: Colors.white,
                  //     minimumSize: const Size(double.infinity, 48),
                  //     textStyle: const TextStyle(fontSize: 18),
                  //   ),
                  //   onPressed: () {
                  //     // Implementar lógica de atendimento imediato
                  //   },
                  // ),
                  const SizedBox(height: 24),
                  Text('Finanças',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: const Text('Recibos Emitidos'),
                      trailing: Text('$recibosEmitidos'),
                      onTap: () {
                        // Navegar para tela de recibos
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.account_balance_wallet_outlined),
                      title: const Text('Extrato de Ganhos'),
                      trailing: Text('R\$ ${extratoGanhos.toStringAsFixed(2)}'),
                      onTap: () {
                        // Navegar para tela de extrato
                      },
                    ),
                  ),
                  //const SizedBox(height: 24),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.support_agent),
                      title: const Text('Suporte'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        // Navegar para tela de suporte
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  const _InfoCard(
      {required this.title,
      required this.value,
      required this.icon,
      this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: color ?? Theme.of(context).primaryColor, size: 32),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}


//   id           
//   name          
//   email         
//   passwordHash  
//   bio           
//   cpf           
//   cnpj          
//   CRP           
//   diplomaPsicanalista 
//   declSupClinica 
//   declAnPessoal 
//   tipoProfissional     
//   estaOnline     
//   atendePlantao  
//   valorConsulta  
//   genero         
//   aprovado  
//   // Dados bancários
//   chavePix       
//   contaBancaria  
//   agencia        
//   banco          
//   tipoConta      
//   createdAt      
//   sessions       
//   recibos        
//   reports        
//   abordagemPrincipal     
//   abordagensUtilizadas  
//   especialidadePrincipal 
//   temasClinicos  
//   foto perfil          
//   certificados

           
//   name          
//   email         
//   passwordHash  
//   bio           
//   cpf           
//   cnpj          
//   CRP           
//   diplomaPsicanalista 
//   declSupClinica 
//   declAnPessoal 
//   tipoProfissional     
//   estaOnline     
//   atendePlantao  
//   valorConsulta  
//   genero         
//   aprovado  
//   // Dados bancários
//   chavePix       
//   contaBancaria  
//   agencia        
//   banco          
//   tipoConta      
//   createdAt      
//   sessions       
//   recibos        
//   reports        
//   abordagemPrincipal     
//   abordagensUtilizadas  
//   especialidadePrincipal 
//   temasClinicos  
//   foto perfil          
//   certificados