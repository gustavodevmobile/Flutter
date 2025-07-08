import 'dart:ui_web' as ui;
import 'dart:html';
import 'package:flutter/material.dart';

class CheckoutBricksPage extends StatefulWidget {
  final String preferenceId;
  final double amount;
  final String publicKey;
  const CheckoutBricksPage({
    super.key,
    required this.preferenceId,
    required this.amount,
    required this.publicKey,
  });

  @override
  State<CheckoutBricksPage> createState() => _CheckoutBricksPageState();
}

class _CheckoutBricksPageState extends State<CheckoutBricksPage> {
  final String _viewType = 'payment-brick-html';

  @override
  void initState() {
    super.initState();

    // Registra o elemento HTML apenas uma vez
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final div = DivElement()
        ..id = 'paymentBrick_container'
        ..style.width = '100%'
        ..style.height = '100%' // Altura flexível
        ..style.minHeight = '800px' // Altura mínima suficiente
        ..style.overflow = 'auto'; // Permite scroll interno

      // ..style.borderRadius = '8px'; // Para melhor aparência (opcional)
      // Cor de fundo suave
      return div;
    });

    // Chama o JS para renderizar o Brick
    Future.delayed(Duration.zero, () {
      _renderBrick();
    });
  }

  @override
  void dispose() {
    // Chama um script para desmontar o Brick ao sair da tela
    final script = '''
    if(window.paymentBrickController && typeof window.paymentBrickController.unmount === 'function') {
      window.paymentBrickController.unmount();
    }
    window.paymentBrickController = null;
    
    // Limpar as variáveis globais para evitar conflitos
    window.mp = null;
    window.bricksBuilder = null;
    ''';
    final scriptElement = ScriptElement()
      ..innerHtml = script
      ..setAttribute("data-source", "brick-cleanup");

    document.body!.append(scriptElement);

    super.dispose();
  }

  //5031 4332 1540 6351

  void _renderBrick() {
    print('Preference ID: ${widget.preferenceId}');
    print('Amount: ${widget.amount}');
    print('Public Key: ${widget.publicKey}');

    // Remove scripts anteriores
    document
        .querySelectorAll('script[data-source="brick"]')
        .forEach((s) => s.remove());

    final script = '''
    if(window.paymentBrickController && typeof window.paymentBrickController.unmount === 'function') {
      window.paymentBrickController.unmount();
    }
    window.paymentBrickController = null;

    // Usar variáveis globais para evitar redeclaração
    if(!window.mp) {
      window.mp = new MercadoPago('${widget.publicKey}', {locale: 'pt-BR'});
    }
    if(!window.bricksBuilder) {
      window.bricksBuilder = window.mp.bricks();
    }

    // Executar diretamente sem função anônima
    (async () => {
      const settings = {
        initialization: {
          amount: ${widget.amount},
          preferenceId: "${widget.preferenceId}",
          payer: {
            firstName: "",
            lastName: "",
            email: "",
          },
        },
        customization: {
          visual: { style: { theme: "dark" } },
          paymentMethods: { 
            creditCard: "all", 
            debitCard: "all",
            ticket: "all",
            bankTransfer: "all",
            maxInstallments: 1 
          }
        },
        callbacks: {
          onReady: () => {
            console.log('Brick está pronto');
          },
          onSubmit: ({ selectedPaymentMethod, formData }) => {
            console.log('=== DADOS DETALHADOS ===');
            console.log('selectedPaymentMethod:', selectedPaymentMethod);
            console.log('formData completo:', JSON.stringify(formData, null, 2));
            console.log('========================');
            return new Promise((resolve, reject) => {
              fetch("http://localhost:3000/pagamentos/efetivar-pagamento", {
                method: "POST",
                headers: { "Content-Type": "application/json", "Accept": "application/json" },
                body: JSON.stringify(formData),
              })
              .then((response) => response.json())
              .then((response) => { 
                console.log('✅ Pagamento aprovado!', response);
                resolve(); 
              })
              .catch((error) => { 
                console.error('❌ Erro no pagamento:', error);
                reject(error); 
              });
            });
          },
          onError: (error) => { 
            console.error('Erro no Brick:', error); 
          }
        }
      };
      window.paymentBrickController = await window.bricksBuilder.create("payment", "paymentBrick_container", settings);
    })();
  ''';

    final scriptElement = ScriptElement()
      ..innerHtml = script
      ..setAttribute("data-source", "brick");
    document.body!.append(scriptElement);
  }

  // void _renderBrick() {
  //   print('Preference ID: ${widget.preferenceId}');
  //   print('Amount: ${widget.amount}');
  //   print('Public Key: ${widget.publicKey}');

  //   // Remove scripts anteriores
  //   document
  //       .querySelectorAll('script[data-source="brick"]')
  //       .forEach((s) => s.remove());

  //   final script = '''
  //   if(window.paymentBrickController && typeof window.paymentBrickController.unmount === 'function') {
  //     window.paymentBrickController.unmount();
  //   }
  //   window.paymentBrickController = null;

  //   // Instanciar MercadoPago
  //   const mp = new MercadoPago('${widget.publicKey}', {locale: 'pt-BR'});
  //   const bricksBuilder = mp.bricks();

  //   const renderPaymentBrick = async (bricksBuilder) => {
  //     const settings = {
  //       initialization: {
  //         amount: ${widget.amount},
  //         preferenceId: "${widget.preferenceId}",
  //         payer: {
  //           firstName: "",
  //           lastName: "",
  //           email: "",
  //         },
  //       },
  //       customization: {
  //         visual: { style: { theme: "dark" } },
  //         paymentMethods: {
  //           creditCard: "all",
  //           debitCard: "all",
  //           ticket: "all",
  //           bankTransfer: "all",
  //           maxInstallments: 1
  //         }
  //       },
  //       callbacks: {
  //         onReady: () => {
  //           console.log('Brick está pronto');
  //         },
  //         onSubmit: ({ selectedPaymentMethod, formData }) => {
  //           console.log('=== DADOS DETALHADOS ===');
  //           console.log('selectedPaymentMethod:', selectedPaymentMethod);
  //           console.log('formData completo:', JSON.stringify(formData, null, 2));
  //           console.log('========================');
  //           console.log('Dados enviados:', formData);
  //           return new Promise((resolve, reject) => {
  //             fetch("http://localhost:3000/pagamentos/efetivar-pagamento", {
  //               method: "POST",
  //               headers: { "Content-Type": "application/json",
  //                "Accept": "application/json" },
  //               body: JSON.stringify(formData),
  //             })
  //             .then((response) => response.json())
  //             .then((response) => {
  //               console.log('Status da resposta:', response.status);
  //               console.log('Headers da resposta:', response.headers);
  //               console.log('Resposta do backend:', response);
  //               resolve();
  //             })
  //             .catch((error) => {
  //               console.error('Erro no pagamento:', error);
  //               reject(error);
  //             });
  //           });
  //         },
  //         onError: (error) => {
  //           console.error('Erro no Brick:', error);
  //         }
  //       }
  //     };
  //     window.paymentBrickController = await bricksBuilder.create("payment", "paymentBrick_container", settings);
  //   };
  //   renderPaymentBrick(bricksBuilder);
  // ''';

  //   final scriptElement = ScriptElement()
  //     ..innerHtml = script
  //     ..setAttribute("data-source", "brick");
  //   document.body!.append(scriptElement);
  // }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text('Checkout Mercado Pago Bricks')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              width: 600,
              height: 900,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, color: Colors.green, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        "Pagamento 100% seguro",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Seus dados estão protegidos com criptografia SSL.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  // Aqui vai o Brick
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: HtmlElementView(viewType: _viewType),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ícones de bandeiras de cartão
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Image.asset('assets/bandeiras/visa.png', height: 32),
                  //     const SizedBox(width: 8),
                  //     Image.asset('assets/bandeiras/mastercard.png',
                  //         height: 32),
                  //     const SizedBox(width: 8),
                  //     Image.asset('assets/bandeiras/elo.png', height: 32),
                  //     // Adicione outras bandeiras se quiser
                  //   ],
                  // ),
                  const SizedBox(height: 16),
                  // Informações de contato/ajuda
                  Text(
                    "Dúvidas? Fale com nosso suporte: suporte@seudominio.com",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
