import 'dart:ui_web' as ui;
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:noribox_store/views/resultado_pagamento_screen.dart';
import 'package:noribox_store/widgets/checkout_container.dart';

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

      return div;
    });

    window.onMessage.listen((event) {
      if (!mounted) return; // <-- Adicione esta linha!
      if (event.data is Map && event.data['type'] == 'payment_result') {
        final result = event.data['data'];
        print('Resultado do pagamento recebido: $result');
        //Navega para a tela de resultado, passando os dados
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ResultadoPagamentoScreen(resultado: result),
          ),
        );
      }
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
            maxInstallments: 6 
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
                window.parent.postMessage(
                  { type: 'payment_result', data: response },
                  '*'
                );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text('Checkout Mercado Pago Bricks')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CheckoutContainer(
            child: HtmlElementView(viewType: _viewType),
          ),
        ),
      ),
    );
  }
}
