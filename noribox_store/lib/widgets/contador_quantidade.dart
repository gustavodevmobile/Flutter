import 'package:flutter/material.dart';
import 'package:noribox_store/themes/themes.dart';

class ContadorQuantidade extends StatefulWidget {
  const ContadorQuantidade({super.key});

  @override
  State<ContadorQuantidade> createState() => _ContadorQuantidadeState();
}

class _ContadorQuantidadeState extends State<ContadorQuantidade> {
  bool _isHoverRemove = false;
  bool _isHoverAdd = false;
  // bool _isPressedRemove = false;
  // bool _isPressedAdd = false;

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
                    setState(() {
                     
                      // Aqui você pode adicionar a lógica para diminuir a quantidade
                    });
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
                  child: const Text(
                    '1',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              MouseRegion(
                onEnter: (_) => setState(() => _isHoverAdd = true),
                onExit: (_) => setState(() => _isHoverAdd = false),
                child: IconButton(
                  onPressed: () {},
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
