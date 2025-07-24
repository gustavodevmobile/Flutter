import 'package:flutter/material.dart';
import 'package:noribox_store/themes/themes.dart';
import 'package:noribox_store/widgets/custom_dropdown_menu.dart';

final List<Widget> dropdownMenus = [
  CustomDropdownMenu(
    menuIndex: 0,
    dxOffset: 8,
    categoria: 'Mesas e Cadeiras',
    subCategorias: ['Mesas', 'Cadeiras', 'Bancos', 'Conjuntos', 'Sofas Booths'],
    onSelected: (sub) {
      // ação ao selecionar subcategoria
    },
    //backgroundColor: Themes.white,
    textColorSubCategoria: Themes.blackLight,
    textColorCategoria: Themes.white,

    //icon: Icon(Icons.shopping_bag, color: Colors.white),
  ),
  SizedBox(width: 24),
  CustomDropdownMenu(
    menuIndex: 1,
    dxOffset: -20,
    categoria: 'Noribox',
    subCategorias: ['Folha inteira', 'Meia folha'],
    onSelected: (sub) {
      // ação ao selecionar subcategoria
    },
    //backgroundColor: Themes.white,
    textColorSubCategoria: Themes.blackLight,
    textColorCategoria: Themes.white,

    //icon: Icon(Icons.shopping_bag, color: Colors.white),
  ),
  SizedBox(width: 24),
  CustomDropdownMenu(
    menuIndex: 2,
    dxOffset: -20,
    categoria: 'Fogao',
    subCategorias: ['Eletrônicos', 'Moda', 'Beleza', 'Casa'],
    onSelected: (sub) {
      // ação ao selecionar subcategoria
    },
    //backgroundColor: Themes.white,
    textColorSubCategoria: Themes.blackLight,
    textColorCategoria: Themes.white,

    //icon: Icon(Icons.shopping_bag, color: Colors.white),
  ),
  SizedBox(width: 24),
  CustomDropdownMenu(
    menuIndex: 3,
    dxOffset: -5,
    categoria: 'Geladeiras',
    subCategorias: ['Eletrônicos', 'Moda', 'Beleza', 'Casa'],
    onSelected: (sub) {
      // ação ao selecionar subcategoria
    },
    //backgroundColor: Themes.white,
    textColorSubCategoria: Themes.blackLight,
    textColorCategoria: Themes.white,

    //icon: Icon(Icons.shopping_bag, color: Colors.white),
  ),
  SizedBox(width: 24),
  CustomDropdownMenu(
    menuIndex: 4,
    dxOffset: -5,
    categoria: 'Sushicases',
    subCategorias: ['Eletrônicos', 'Moda', 'Beleza', 'Casa'],
    onSelected: (sub) {
      // ação ao selecionar subcategoria
    },
    //backgroundColor: Themes.white,
    textColorSubCategoria: Themes.blackLight,
    textColorCategoria: Themes.white,

    //icon: Icon(Icons.shopping_bag, color: Colors.white),
  ),
  SizedBox(width: 24),
  CustomDropdownMenu(
    menuIndex: 5,
    dxOffset: -17,
    categoria: 'Pratos',
    subCategorias: ['Porcelana', 'Cerâmica', 'Melamina'],
    onSelected: (sub) {
      print('Subcategoria selecionada: $sub');
    },
    //backgroundColor: Themes.white,
    textColorSubCategoria: Themes.blackLight,
    textColorCategoria: Themes.white,

    //icon: Icon(Icons.shopping_bag, color: Colors.white),
  ),
  SizedBox(width: 24),
  CustomDropdownMenu(
    menuIndex: 6,
    dxOffset: -15,
    categoria: 'Panelas',
    subCategorias: ['Eletrônicos', 'Moda', 'Beleza', 'Casa'],
    onSelected: (sub) {
      // ação ao selecionar subcategoria
    },
    //backgroundColor: Themes.white,
    textColorSubCategoria: Themes.blackLight,
    textColorCategoria: Themes.white,

    //icon: Icon(Icons.shopping_bag, color: Colors.white),
  ),
  SizedBox(width: 24),
  CustomDropdownMenu(
    menuIndex: 7,
    dxOffset: -20,
    categoria: 'Facas',
    subCategorias: ['Eletrônicos', 'Moda', 'Beleza', 'Casa'],
    onSelected: (sub) {
      // ação ao selecionar subcategoria
    },
    //backgroundColor: Themes.white,
    textColorSubCategoria: Themes.blackLight,
    textColorCategoria: Themes.white,

    //icon: Icon(Icons.shopping_bag, color: Colors.white),
  ),
  SizedBox(width: 24),
];
