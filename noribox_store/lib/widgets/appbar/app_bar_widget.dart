import 'package:flutter/material.dart';
import 'package:noribox_store/widgets/appbar/app_bar_desktop.dart';
import 'package:noribox_store/widgets/appbar/app_bar_mobile.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Container(),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          if (widthScreen < 1100) {
            return AppBarWidgetMobile();
          }
          return AppBarWidgetDesktop();
        },
      ),
      actions: [Container()],
    );
  }
}
