import 'package:flutter/material.dart';
import 'package:noribox_store/themes/themes.dart';

class ContadorQuantidade extends StatefulWidget {
  final int quantidadeInicial;
  final ValueChanged<int>? onQuantidadeChanged;

  const ContadorQuantidade({
    super.key,
    this.quantidadeInicial = 1,
    this.onQuantidadeChanged,
  });

  @override
  State<ContadorQuantidade> createState() => _ContadorQuantidadeState();
}

class _ContadorQuantidadeState extends State<ContadorQuantidade> {
  int quantidade = 1;
  bool _isHoverRemove = false;
  bool _isHoverAdd = false;

  @override
  void initState() {
    super.initState();
    quantidade = widget.quantidadeInicial;
  }

  void atualizarQuantidade(int novoValor) {
    setState(() {
      quantidade = novoValor;
    });
    if (widget.onQuantidadeChanged != null) {
      widget.onQuantidadeChanged!(quantidade);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text('Quantidade',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Themes.greyPrimary,
              )),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                onEnter: (_) => setState(() => _isHoverRemove = true),
                onExit: (_) => setState(() => _isHoverRemove = false),
                child: IconButton(
                  onPressed: () {
                    if (quantidade > 1) {
                      atualizarQuantidade(quantidade - 1);
                    }
                  },
                  icon: Icon(
                    Icons.remove,
                    color: _isHoverRemove ? Themes.white : Colors.black,
                  ),
                  hoverColor: Themes.redPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  child: Text(
                    '$quantidade',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              MouseRegion(
                onEnter: (_) => setState(() => _isHoverAdd = true),
                onExit: (_) => setState(() => _isHoverAdd = false),
                child: IconButton(
                  onPressed: () {
                    atualizarQuantidade(quantidade + 1);
                  },
                  icon: Icon(
                    Icons.add,
                    color: _isHoverAdd ? Themes.white : Colors.black,
                  ),
                  hoverColor: Themes.redPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
