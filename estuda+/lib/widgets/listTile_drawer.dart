import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estudamais/models/models.dart';
import 'package:provider/provider.dart';

class ListTileDrawer extends StatelessWidget {
  final String contextText;
  final Function onTap;
  final Icon icon;
  const ListTileDrawer({
    required this.contextText,
    required this.onTap,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelPoints>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: Card(
          child: ListTile(
            leading: icon, iconColor: Colors.indigo,
            title: Text(
              contextText,
              style: GoogleFonts.aboreto(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18,),
            onTap: () {
              onTap();
            },
          ),
        ),
      );
    });
  }
}
