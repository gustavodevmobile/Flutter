import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Boxcard extends StatefulWidget {
  final String name;
  final String number;
  final IconButton delete;
  final IconButton update;
  const Boxcard(this.update, this.delete, this.name, this.number, {super.key});

  @override
  State<Boxcard> createState() => _BoxcardState();
}

class _BoxcardState extends State<Boxcard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
              title: Text(
                widget.name,
                style: GoogleFonts.bebasNeue(fontSize: 25),
              ),
              subtitle: Text(widget.number, style: GoogleFonts.bebasNeue(fontSize: 15),),
              leading: const Icon(Icons.contact_phone),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [widget.delete, widget.update],
                ),
              )),
        ],
      ),
    );
  }
}
