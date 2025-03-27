import 'package:flutter/material.dart';

class BoxEditDialog extends StatefulWidget {
  final TextEditingController updateName;
  final TextEditingController updateNumber;
  final String contactsIndexName;
  final String contactsIndexNumber;
  // final Function() onUpdate;
  final TextButton onUpdate;

  const BoxEditDialog(this.onUpdate, this.updateName, this.updateNumber,
      this.contactsIndexName, this.contactsIndexNumber,
      {super.key});

  @override
  State<BoxEditDialog> createState() => _BoxEditDialogState();
}

class _BoxEditDialogState extends State<BoxEditDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Atualizar',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  icon: const Icon(Icons.person),
                  hintText: widget.contactsIndexName.toString()),
              controller: widget.updateName,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  icon: const Icon(Icons.phone),
                  hintText: (widget.contactsIndexNumber.toString())),
              controller: widget.updateNumber,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TextButton(
                //   onPressed: () {
                //     setState(() {
                //       widget.onUpdate;
                //     });
                //   },
                //   child: Text(
                //     'Ok',
                //     style: TextStyle(fontSize: 20, color: Colors.black),
                //   ),
                // ),
                widget.onUpdate,
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
