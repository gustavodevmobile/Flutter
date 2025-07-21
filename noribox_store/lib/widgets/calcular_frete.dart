import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/utils/formatters.dart';
import 'package:noribox_store/widgets/custom_button.dart';
import 'package:noribox_store/widgets/custom_text_rich.dart';

class CalculaFreteWidget extends StatefulWidget {
  final double? width;
  final Color? color;
  final String? text;
  final Color? colorText;
  final Future<List<Map<String, dynamic>>> Function(String cep)?
      onCalcularFrete;
  final bool hasProduto;
  final void Function(double precoFrete)? onSelecionarFrete;
  final bool isBorder;

  const CalculaFreteWidget(
      {super.key,
      this.width,
      this.color,
      this.text,
      this.colorText,
      this.onCalcularFrete,
      this.hasProduto = true,
      this.onSelecionarFrete,
      this.isBorder = false});

  @override
  State<CalculaFreteWidget> createState() => _CalculaFreteWidgetState();
}

class _CalculaFreteWidgetState extends State<CalculaFreteWidget> {
  final _cepController = TextEditingController();
  List<Map<String, dynamic>>? _resultado;
  bool _loading = false;
  String? _erro;

  void _calcular() async {
    setState(() {
      _loading = true;
      _resultado = null;
      _erro = null;
    });
    try {
      //if (widget.hasProduto) {
      if (widget.onCalcularFrete != null) {
        final res = await widget.onCalcularFrete!(_cepController.text);
        //print('Resultado do frete: $res');
        setState(() => _resultado = res);
      } else {
        // Simulação de resultado
        await Future.delayed(const Duration(seconds: 1));
        // setState(() =>
        //     _resultado = 'Frete: R\$ 19,90 - Entrega em até 7 dias úteis');
      }
      //}
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
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: widget.isBorder
              ? BoxDecoration(
                  color: Themes.greyLight,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  widget.text ?? 'Calcular frete e prazo de entrega',
                  style: TextStyle(
                    color: widget.colorText ?? Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
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
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),

                            //isDense: true,
                          ),
                          //maxLength: 9,
                        ),
                      ),
                      const SizedBox(width: 4),
                      CustomButton(
                        enabled: widget.hasProduto,
                        onPressed: _loading ? null : _calcular,
                        width: 100,
                        height: 50,
                        borderRadius: 10,
                        elevation: 2,
                        child: _loading
                            ? const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Calcular'),
                      ),
                      
                    ],
                  ),
                ),
                if (_resultado != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: _resultado!.map((item) {
                        return Card(
                          color: widget.color ?? Colors.white,
                          child: InkWell(
                            onTap: () {
                              if (widget.onSelecionarFrete != null) {
                                widget.onSelecionarFrete!(
                                    double.parse(item['preco']));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 70,
                                    height: 30,
                                    child: Image.asset(
                                      item['imagemServico'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  CustomTextRich(
                                    textPrimary: 'R\$',
                                    fontSizePrimary: 10,
                                    colorTextPrimary: Themes.greyPrimary,
                                    textSecondary: Formatters.formatercurrency(
                                        item['preco'].toString()),
                                    fontSizeSecondary: 16,
                                    colorTextSecondary: Themes.redPrimary,
                                    textTertiary:
                                        ' - ${item['prazoEntrega']} dias úteis',
                                    fontSizeTertiary: 14,
                                    colorTextTertiary: Themes.greyPrimary,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
        ),
      ),
    );
  }
}
