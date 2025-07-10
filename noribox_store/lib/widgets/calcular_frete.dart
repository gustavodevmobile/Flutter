import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:noribox_store/utils/formatters.dart';

class CalculaFreteWidget extends StatefulWidget {
  final Future<String> Function(String cep)? onCalcularFrete;

  const CalculaFreteWidget({super.key, this.onCalcularFrete});

  @override
  State<CalculaFreteWidget> createState() => _CalculaFreteWidgetState();
}

class _CalculaFreteWidgetState extends State<CalculaFreteWidget> {
  final _cepController = TextEditingController();
  String? _resultado;
  bool _loading = false;
  String? _erro;

  void _calcular() async {
    setState(() {
      _loading = true;
      _resultado = null;
      _erro = null;
    });
    try {
      if (widget.onCalcularFrete != null) {
        final res = await widget.onCalcularFrete!(_cepController.text);
        setState(() => _resultado = res);
      } else {
        // Simulação de resultado
        await Future.delayed(const Duration(seconds: 1));
        setState(() =>
            _resultado = 'Frete: R\$ 19,90 - Entrega em até 7 dias úteis');
      }
    } catch (e) {
      setState(() => _erro = 'Erro ao calcular frete');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: 400.ms, delay: 200.ms),
        SlideEffect(duration: 400.ms, begin: const Offset(0, 0.1)),
      ],
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text('Calcule o frete e prazo de entrega'),
            Container(
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [Formatters.cepFormatter],
                        controller: _cepController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Digite seu CEP',
                          border: InputBorder.none,
                          //isDense: true,
                        ),
                        //maxLength: 9,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _loading ? null : _calcular,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Calcular'),
                    ),
                  ],
                ),
              ),
            ),
            if (_resultado != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _resultado!,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            if (_erro != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _erro!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
