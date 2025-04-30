import 'package:estudamais/providers/global_providers.dart';
import 'package:estudamais/shared_preference/storage_shared_preferences.dart';
import 'package:estudamais/theme/app_theme.dart';
import 'package:estudamais/widgets/show_snackbar_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onItemSelected;

  const CustomDropdown(
      {required this.items,
      this.selectedItem,
      required this.onItemSelected,
      super.key});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? overlayEntry;
  bool isMenuOpen = false;
  String? _selectedItem;
  StorageSharedPreferences storageSharedPreferences =
      StorageSharedPreferences();

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    overlayEntry = null; // Limpa a referência ao OverlayEntry
    super.dispose();
  }

  void _toggleMenu() {
    print('widget.items ${widget.items}');
    if (Provider.of<GlobalProviders>(listen: false, context).isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    //print(widget.items);
    overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(overlayEntry!);
    setState(() {
      Provider.of<GlobalProviders>(listen: false, context)
          .closeDropdownMenu(true);
    });
  }

  void _closeMenu() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null; // Limpa a referência ao OverlayEntry
    }
    setState(() {
      Provider.of<GlobalProviders>(listen: false, context)
          .closeDropdownMenu(false);
    });

    // print(_isMenuOpen);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    //final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: widget.items.isEmpty
                  ? [
                      ListTile(
                        title: Text(
                          'Nenhum email salvo',
                          style: AppTheme.customTextStyle2(color: Colors.black),
                        ),
                      )
                    ]
                  : widget.items.map(
                      (item) {
                        return ListTile(
                          minTileHeight: 10,
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              _selectedItem = item;
                            });
                            widget.onItemSelected(item);
                            _closeMenu();
                          },
                          trailing: IconButton(
                              onPressed: () {
                                storageSharedPreferences.removeEmail(item,
                                    (onError) {
                                  showSnackBarFeedback(
                                      context, onError, Colors.red);
                                }, (onSuccess) {
                                  showSnackBarFeedback(
                                      context, onSuccess, Colors.green);
                                }).then((_) {
                                  widget.items.remove(item);
                                  _closeMenu();
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              )),
                        );
                      },
                    ).toList(),
                    
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
      child: GestureDetector(
        onTap: _toggleMenu,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedItem ?? 'Selecione um item',
                style: const TextStyle(color: Colors.black),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
