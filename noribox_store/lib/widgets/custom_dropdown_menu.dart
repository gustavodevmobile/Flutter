import 'package:flutter/material.dart';
import 'package:noribox_store/themes/themes.dart';

final ValueNotifier<int?> customDropdownOpenIndex = ValueNotifier<int?>(null);

class CustomDropdownMenu extends StatefulWidget {
  final String categoria;
  final List<String> subCategorias;
  final void Function(String subCategoria)? onSelected;
  final Color textColorSubCategoria;
  final Color textColorCategoria;
  final Color hoverColor;
  final TextStyle? textStyle;
  final Widget? icon;
  final double elevation;
  final int menuIndex;
  final double dxOffset;

  const CustomDropdownMenu({
    super.key,
    required this.categoria,
    required this.subCategorias,
    required this.menuIndex,
    this.onSelected,
    this.dxOffset = 0,
    this.textColorSubCategoria = Colors.black,
    this.textColorCategoria = Colors.black,
    this.hoverColor = Themes.greyLight,
    this.textStyle,
    this.icon,
    this.elevation = 8,
  });

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  bool _isMenuOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    customDropdownOpenIndex.addListener(_handleMenuChange);
  }

  void _handleMenuChange() {
    if (customDropdownOpenIndex.value != widget.menuIndex && _isMenuOpen) {
      _closeMenu();
    }
  }

  @override
  void dispose() {
    customDropdownOpenIndex.removeListener(_handleMenuChange);
    if (context.mounted) {
      _closeMenu();
    }
    super.dispose();
  }

  void _openMenu() {
    customDropdownOpenIndex.value = widget.menuIndex; // Notifica todos
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isMenuOpen = true;
    });
  }

  void _closeMenu() {
    if (context.mounted) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {
        _isMenuOpen = false;
      });
    }
  }

  double _getMaxSubCategoriaWidth(BuildContext context) {
    double maxWidth = 0;
    final textStyle = widget.textStyle ??
        TextStyle(
          color: widget.textColorSubCategoria,
          fontSize: 16,
        );
    for (final sub in widget.subCategorias) {
      final tp = TextPainter(
        text: TextSpan(text: sub, style: textStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      if (tp.width > maxWidth) maxWidth = tp.width;
    }
    // Adicione padding extra para o visual ficar agradável
    return maxWidth +
        48; // 48 = padding horizontal + ícones, ajuste se necessário
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final overlayWidth = _getMaxSubCategoriaWidth(context);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - ((size.width * 1.5 - size.width) / 2),
        top: offset.dy + size.height,
        width: overlayWidth,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(widget.dxOffset, size.height),
          child: MouseRegion(
            onExit: (_) {
              if (_isMenuOpen) _closeMenu();
            },
            child: Material(
              color: Colors.white,
              elevation: widget.elevation,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: ListView(
                //padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                shrinkWrap: true,
                children: widget.subCategorias.map((sub) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      widget.onSelected?.call(sub);
                      _closeMenu();
                    },
                    hoverColor: widget.hoverColor,
                    child: SizedBox(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              sub,
                              style: widget.textStyle ??
                                  TextStyle(
                                    color: widget.textColorSubCategoria,
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          if (!_isMenuOpen) _openMenu();
        },
        // onExit: (_) {
        //   if (_isMenuOpen) _closeMenu();
        // },
        cursor: SystemMouseCursors.click,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            // borderRadius: BorderRadius.circular(8),
            //
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            widget.categoria,
            style: widget.textStyle ??
                TextStyle(
                  color: widget.textColorCategoria,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
        ),
      ),
    );
  }
}
